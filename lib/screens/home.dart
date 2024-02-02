import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:randomquotes/constants/app_assets.dart';
import 'package:randomquotes/constants/app_colors.dart';
import 'package:randomquotes/extensions/app_lang.dart';
import 'package:randomquotes/model/quote.dart';
import 'package:share_plus/share_plus.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder<List<Quote>>(
        future: fetchQuotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<Quote> quotesData = snapshot.data!;
              return StatefulBuilder(
                builder: (context, setState) {
                  return vxSwiperItem(context, quotesData);
                },
              );
            }
            return context.translate.nothingFound.text.makeCentered();
          } else if (snapshot.connectionState == ConnectionState.none) {
            return context.translate.error.text.makeCentered();
          }
          return const CircularProgressIndicator().centered();
        },
      ),
    );
  }

  VxSwiper vxSwiperItem(BuildContext context, List<Quote> quotesData) {
    var selectedColor = AppColors(context).bgRandomColor;
    return VxSwiper(
      scrollDirection: Axis.vertical,
      height: context.screenHeight,
      viewportFraction: 1.0,
      onPageChanged: (index) {
        setState(() {});
      },
      items: quotesData.map<Widget>(
        (e) {
          return VStack(
            [
              appLogoWidget(),
              quoteTextWidget(e),
              quoteAuthorWidget(e),
              shareIconButton(e)
            ],
            crossAlignment: CrossAxisAlignment.center,
            alignment: MainAxisAlignment.spaceAround,
          ).animatedBox.p16.color(selectedColor).make().h(context.screenHeight);
        },
      ).toList(),
    );
  }

  Widget quoteAuthorWidget(Quote e) {
    return e.quoteAuthor.text.white.italic.xl2
        .make()
        .shimmer()
        .box
        .outerShadowLg
        .make();
  }

  Widget quoteTextWidget(Quote e) {
    return e.quoteText.text.white.italic.bold.xl3
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

  IconButton shareIconButton(Quote quoteItem) {
    return IconButton(
      icon: const Icon(
        Icons.share,
        color: Colors.white,
        size: 30,
      ),
      onPressed: () {
        Share.share("'${quoteItem.quoteText}' - ${quoteItem.quoteAuthor}");
      },
    );
  }

  Future<List<Quote>> fetchQuotes() async {
    String langCode = "en";
    final dataUri = Uri.parse("https://osmkoc.com/data/quotes-$langCode.json");

    final response = await http.get(dataUri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['quotes'];

      List<Quote> quotes =
          jsonList.map((json) => Quote.fromJson(json)).toList();

      return quotes;
    } else {
      throw Exception(context.translate.failedToLoadQuotes);
    }
  }
}
