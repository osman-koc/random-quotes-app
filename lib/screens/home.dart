import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:randomquotes/constants/app_assets.dart';
import 'package:randomquotes/constants/app_colors.dart';
import 'package:randomquotes/constants/app_settings.dart';
import 'package:randomquotes/extensions/app_lang.dart';
import 'package:randomquotes/helpers/app_cache_helper.dart';
import 'package:randomquotes/model/quote.dart';
import 'package:randomquotes/screens/about_popup.dart';
import 'package:randomquotes/screens/select_language_popup.dart';
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
  String _selectedLanguage = AppSettings.selectedLang;
  bool _loadedData = false;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = AppSettings.selectedLang;
    _loadLanguagePreference();
    _getQuotesFuture = _getQuotes();
  }

  Future<void> _loadLanguagePreference() async {
    final lang = await AppCacheHelper.getSelectedLanguage();
    setState(() {
      _selectedLanguage = lang;
    });
    if (kDebugMode)
      print('====> _loadLanguagePreference selecetdLanguage is ' +
          _selectedLanguage);
  }

  void _changeLanguage(String selectedLangCode) async {
    await AppCacheHelper.saveLanguagePreference(selectedLangCode);
    setState(() {
      _selectedLanguage = selectedLangCode;
      _getQuotesFuture = _getQuotes();
    });
  }

  void _showPopup(BuildContext context, Widget popup) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return popup;
      },
    );
  }

  Future<List<QuoteModel>> _getQuotes() async {
    List<QuoteModel> uniqueData = [];

    try {
      await _loadLanguagePreference();
      final querySnapshot = await FirebaseFirestore.instance
          .collection('quotes_$_selectedLanguage')
          .get();
      var quotesData = querySnapshot.docs
          .map((doc) => QuoteModel.fromFirestore(doc))
          .toList();
      quotesData.shuffle();
      quotesData.forEach((item) {
        if (!uniqueData.contains(item)) {
          uniqueData.add(item);
        }
      });
    } catch (ex) {
      if (kDebugMode) print(ex);
    }

    setState(() {
      _loadedData = uniqueData.isNotEmpty;
    });

    if (kDebugMode)
      print('====> _getQuotes method end. Data count is ' +
          uniqueData.count().toString());

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
                  label: context.translate.languageSettings,
                  onPressed: () {
                    setState(() {
                      _showPopup(
                        context,
                        SelectLanguagePopup(
                          selectedLangCode: _selectedLanguage,
                          onLanguageSelected: _changeLanguage,
                        ),
                      );
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
                      _showPopup(context, const AboutScreenPopup());
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
              Row(
                children: [
                  likeButton(model),
                  SizedBox(width: 30),
                  shareIconButton(model),
                ],
              )
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
    return e.quote.text.white.italic.bold.xl3.make().box.outerShadow2Xl.make();
  }

  Widget quoteAuthorWidget(QuoteModel e) {
    return e.author.text.white.italic.xl2.make().box.outerShadowLg.make();
  }

  Row likeButton(QuoteModel quoteItem) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            quoteItem.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
            color: Vx.white,
            size: 34,
          ),
          onPressed: () {
            setState(() {
              _toggleLike(quoteItem);
            });
          },
        ),
        quoteItem.likeCount.text.white.make(),
      ],
    );
  }

  Future<void> _toggleLike(QuoteModel quoteItem) async {
    if (!quoteItem.isLiked) {
      quoteItem.addLikedUser();
    } else {
      quoteItem.removeLikedUser();
    }
    _updateQuote(quoteItem);
  }

  Future<void> _updateQuote(QuoteModel quoteItem) async {
    try {
      final quoteRef = FirebaseFirestore.instance
          .collection('quotes_$_selectedLanguage')
          .doc(quoteItem.id);
      await quoteRef.update(quoteItem.toMap());
    } catch (e) {
      if (kDebugMode) print('Error: $e');
    }
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
