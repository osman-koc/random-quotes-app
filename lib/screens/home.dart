import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randomquotes/constants/app_assets.dart';
import 'package:randomquotes/constants/app_colors.dart';
import 'package:randomquotes/extensions/app_lang.dart';
import 'package:randomquotes/helpers/app_cache_helper.dart';
import 'package:randomquotes/model/quote.dart';
import 'package:randomquotes/screens/about_popup.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<QuoteModel>>? _getQuotesFuture;
  String _selectedLanguage = 'tr';
  bool _loadedData = false;

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
    _getQuotesFuture = _getQuotes();
  }

  Future<void> _loadLanguagePreference() async {
    final lang = await AppCacheHelper.getSelectedLanguage();
    setState(() {
      _selectedLanguage = lang;
    });
  }

  void _changeLanguage() async {
    var newLanguage = _selectedLanguage == 'tr' ? 'en' : 'tr';
    await AppCacheHelper.saveLanguagePreference(newLanguage);
    setState(() {
      _selectedLanguage = newLanguage;
      _getQuotesFuture = _getQuotes();
    });
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AboutScreenPopup();
      },
    );
  }

  Future<List<QuoteModel>> _getQuotes() async {
    await _loadLanguagePreference();
    final querySnapshot = await FirebaseFirestore.instance
        .collection('quotes_$_selectedLanguage')
        .get();
    var quotesData =
        querySnapshot.docs.map((doc) => QuoteModel.fromFirestore(doc)).toList();
    quotesData.shuffle();

    List<QuoteModel> uniqueData = [];
    quotesData.forEach((item) {
      if (!uniqueData.contains(item)) {
        uniqueData.add(item);
      }
    });

    setState(() {
      _loadedData = uniqueData.isNotEmpty;
    });

    return uniqueData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getQuotesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return VStack(
              [
                appLogoWidget(),
                context.translate.loading.text.white.make(),
                CircularProgressIndicator(),
              ],
              crossAlignment: CrossAxisAlignment.center,
              alignment: MainAxisAlignment.spaceAround,
            )
                .animatedBox
                .p16
                .color(Vx.gray800)
                .make()
                .h(context.screenHeight)
                .w(context.screenWidth);
          } else if (_loadedData) {
            return vxSwiperWidget(snapshot.data);
          } else {
            return const SizedBox();
          }
        },
      ),
      floatingActionButton: !_loadedData
          ? SizedBox()
          : SpeedDial(
              child: Icon(Icons.menu_outlined),
              closedForegroundColor: Vx.gray800,
              openForegroundColor: Vx.white,
              closedBackgroundColor: Vx.white,
              openBackgroundColor: Vx.gray800,
              labelsBackgroundColor: Vx.white,
              labelsStyle: TextStyle(color: Vx.black),
              speedDialChildren: <SpeedDialChild>[
                SpeedDialChild(
                  child: Icon(Icons.language_outlined),
                  foregroundColor: Vx.white,
                  backgroundColor: Vx.emerald600,
                  label: context.translate.changeLanguage,
                  onPressed: () {
                    setState(() {
                      _changeLanguage();
                    });
                  },
                  closeSpeedDialOnPressed: true,
                ),
                SpeedDialChild(
                  child: Icon(Icons.info_outline),
                  foregroundColor: Vx.white,
                  backgroundColor: Vx.amber600,
                  label: context.translate.about,
                  onPressed: () {
                    setState(() {
                      _showAboutDialog(context);
                    });
                  },
                ),
              ],
            ),
    );
  }

  VxSwiper vxSwiperWidget(data) {
    return VxSwiper(
      scrollDirection: Axis.vertical,
      height: context.screenHeight,
      viewportFraction: 1.0,
      items: data.map<Widget>(
        (model) {
          var selectedColor = AppColors(context).bgRandomColor;
          return VStack(
            [
              appLogoWidget(),
              quoteTextWidget(model),
              quoteAuthorWidget(model),
              shareIconButton(model)
            ],
            crossAlignment: CrossAxisAlignment.center,
            alignment: MainAxisAlignment.spaceAround,
          ).animatedBox.p16.color(selectedColor).make().h(context.screenHeight);
        },
      ).toList(),
    );
  }

  Container appLogoWidget() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black87.withOpacity(0.2),
            spreadRadius: 0.1,
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Image.asset(AppAssets.appIconWhite, width: 50),
    );
  }

  Widget quoteTextWidget(QuoteModel e) {
    return e.quote.text.white.italic.bold.xl3
        .make()
        .box
        .outerShadow2Xl
        .make();
  }

  Widget quoteAuthorWidget(QuoteModel e) {
    return e.author.text.white.italic.xl2
        .make()
        .box
        .outerShadowLg
        .make();
  }

  IconButton shareIconButton(QuoteModel quoteItem) {
    return IconButton(
      icon: const Icon(
        Icons.share,
        color: Vx.white,
        size: 34,
      ),
      onPressed: () {
        Share.share("'${quoteItem.quote}' - ${quoteItem.author}");
      },
    );
  }
}
