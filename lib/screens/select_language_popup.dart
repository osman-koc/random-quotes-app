import 'package:flutter/material.dart';
import 'package:randomquotes/constants/app_colors.dart';
import 'package:randomquotes/extensions/app_lang.dart';
import 'package:randomquotes/util/localization.dart';

class SelectLanguagePopup extends StatelessWidget {
  final Function(String) onLanguageSelected;
  final String selectedLangCode;

  const SelectLanguagePopup({
    super.key,
    required this.onLanguageSelected,
    required this.selectedLangCode,
  });

  @override
  Widget build(BuildContext context) {
    return getAlertDialog(context);
  }

  AlertDialog getAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text(context.translate.selectLanguage),
      content: buildLanguageList(context),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(context.translate.close),
        ),
      ],
    );
  }

  Widget buildLanguageList(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: AppLocalizations.supportedLangCodes.length,
        itemBuilder: (context, index) {
          final langCode = AppLocalizations.supportedLangCodes[index];
          final langName = AppLocalizations.getLanguageName(context, langCode);
          final selectedLangColor = AppColors(context).popupSelectedBg;

          return ListTile(
            title: Text(
              langName,
              style: TextStyle(
                fontWeight: langCode == selectedLangCode
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            tileColor: langCode == selectedLangCode ? selectedLangColor : null,
            onTap: () {
              Navigator.of(context).pop(langCode);
              onLanguageSelected(langCode);
            },
          );
        },
      ),
    );
  }
}
