import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
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
  final _colors = [
    Vx.gray800,
    Vx.red800,
    Vx.blue800,
    Vx.green800,
    Vx.teal800,
    Vx.purple800,
    Vx.pink800,
    Vx.orange800,
  ];

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
                  var selectedColor = _colors[Random().nextInt(_colors.length)];
                  var appNameWidget =
                      context.translate.appName.text.white.xl3.bold.make();

                  return VxSwiper(
                    scrollDirection: Axis.vertical,
                    height: context.screenHeight,
                    viewportFraction: 1.0,
                    onPageChanged: (index) {
                      setState(() {});
                    },
                    items: quotesData.map<Widget>(
                      (e) {
                        var quoteTextWidget = e
                            .quoteText.text.white.italic.bold.xl3
                            .make()
                            .shimmer()
                            .box
                            .shadow2xl
                            .make();
                        var quoteAuthorWidget = e.quoteAuthor.text.make();
                        return VStack(
                          [
                            appNameWidget,
                            quoteTextWidget,
                            quoteAuthorWidget,
                            shareIconButton(e.quoteText)
                          ],
                          crossAlignment: CrossAxisAlignment.center,
                          alignment: MainAxisAlignment.spaceAround,
                        )
                            .animatedBox
                            .p16
                            .color(selectedColor)
                            .make()
                            .h(context.screenHeight);
                      },
                    ).toList(),
                  );
                },
              );
            }
            return "Nothing found".text.makeCentered();
          } else if (snapshot.connectionState == ConnectionState.none) {
            return "Error".text.makeCentered();
          }
          return const CircularProgressIndicator().centered();
        },
      ),
    );
  }

  IconButton shareIconButton(String quoteText) {
    return IconButton(
      icon: const Icon(
        Icons.share,
        color: Colors.white,
        size: 30,
      ),
      onPressed: () {
        Share.share(quoteText);
      },
    );
  }

  Future<List<Quote>> fetchQuotes() async {
    String langCode = "en";
    final dataUri = Uri.parse("https://osmkoc.com/quotes-$langCode.json");

    final response = await http.get(dataUri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['quotes'];

      List<Quote> quotes =
          jsonList.map((json) => Quote.fromJson(json)).toList();

      return quotes;
    } else {
      throw Exception('Failed to load quotes');
    }
  }
}
