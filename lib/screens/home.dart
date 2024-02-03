import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randomquotes/components/speed_dial.dart';
import 'package:randomquotes/components/speed_dial_child.dart';
import 'package:randomquotes/constants/app_assets.dart';
import 'package:randomquotes/constants/app_cache.dart';
import 'package:randomquotes/constants/app_colors.dart';
import 'package:randomquotes/extensions/app_lang.dart';
import 'package:randomquotes/model/quote.dart';
import 'package:randomquotes/screens/about_popup.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //List<QuoteModel> quotesData = [];
  String _selectedLanguage = 'tr';

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
    //_fetchQuotes();
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage =
          prefs.getString(AppCache.selectedLanguageCode) ?? 'tr';
    });
  }

  Future<void> _saveLanguagePreference(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppCache.selectedLanguageCode, language);
  }

  // Future<void> _fetchQuotes() async {
  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collection('quotes_$selectedLanguage')
  //       .get();
  //   setState(() {
  //     quotesData = querySnapshot.docs
  //         .map((doc) => QuoteModel.fromFirestore(doc))
  //         .toList();
  //     quotesData.shuffle();
  //   });
  // }

  // QuoteModel getRandomQuote() {
  //   final random = Random();
  //   return quotesData[random.nextInt(quotesData.length)];
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('quotes_$_selectedLanguage')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final quotesData = snapshot.data!.docs;
          quotesData.shuffle();
          return vxSwiperWidget(quotesData);
        },
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.menu_outlined),
        closedForegroundColor: Vx.gray800,
        openForegroundColor: Vx.white,
        closedBackgroundColor: Vx.white,
        openBackgroundColor: Vx.gray800,
        labelsBackgroundColor: Vx.white,
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

  void _changeLanguage() {
    var newLanguage = _selectedLanguage == 'tr' ? 'en' : 'tr';
    _saveLanguagePreference(newLanguage);
    setState(() {
      _selectedLanguage = newLanguage;
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

  VxSwiper vxSwiperWidget(quotesData) {
    return VxSwiper(
      scrollDirection: Axis.vertical,
      height: context.screenHeight,
      viewportFraction: 1.0,
      onPageChanged: (index) {
        setState(() {});
      },
      items: quotesData.map<Widget>(
        (e) {
          var model = QuoteModel.fromFirestore(e);
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

  Widget quoteAuthorWidget(QuoteModel e) {
    return e.author.text.white.italic.xl2
        .make()
        .shimmer()
        .box
        .outerShadowLg
        .make();
  }

  Widget quoteTextWidget(QuoteModel e) {
    return e.quote.text.white.italic.bold.xl3
        .make()
        .shimmer()
        .box
        .outerShadow3Xl
        .make();
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
