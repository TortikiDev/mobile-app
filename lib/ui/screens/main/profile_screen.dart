import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortiki/bloc/base_bloc.dart';
import 'package:tortiki/bloc/profile/index.dart';
// import 'package:tortiki/bloc/feed/index.dart';
import 'package:tortiki/ui/app_theme.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  // const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    var maskFormatter = MaskTextInputFormatter(
        mask: '+# (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});

    Widget _input(String hint, MaskTextInputFormatter controller) {
      var inputDecoration = InputDecoration(
          contentPadding: EdgeInsets.all(16),
          hintStyle: TextStyle(
              fontSize: appTheme.textTheme.subtitle1.fontSize,
              fontFamily: appTheme.textTheme.subtitle1.fontFamily,
              color: appTheme.colorScheme.onBackground.withOpacity(0.6)),
          hintText: hint);

      return Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 16),
        child: Material(
            elevation: 10,
            shadowColor: appTheme.colorScheme.onBackground,
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [maskFormatter],
              // style: TextStyle(
              //     fontSize: appTheme.textTheme.subtitle1.fontSize,
              //     fontFamily: appTheme.textTheme.subtitle1.fontFamily,
              //     color: appTheme.colorScheme.onBackground),
              // decoration: inputDecoration,
            )),
      );
    }

    Widget _button(String text, void func()) {
      return RaisedButton(
        padding: EdgeInsets.only(left: 36, right: 36),
        splashColor: appTheme.colorScheme.onSecondary,
        color: appTheme.colorScheme.primary,
        child: Text(text,
            style: TextStyle(
                fontWeight: appTheme.textTheme.button.fontWeight,
                color: appTheme.colorScheme.onPrimary,
                fontSize: appTheme.textTheme.button.fontSize)),
        onPressed: () {
          func();
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      );
    }

    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      print(state);
      return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
              child: Scaffold(
                appBar: AppBar(
                    automaticallyImplyLeading: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Авторизация',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                        // Your widgets here
                      ],
                    )),
                body: Container(
                  child: Align(
                      child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 24, left: 17, right: 17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Введите свой номер телефона',
                              style: TextStyle(
                                  color: appTheme.colorScheme.onSurface,
                                  fontFamily:
                                      appTheme.textTheme.caption.fontFamily,
                                  fontSize:
                                      appTheme.textTheme.caption.fontSize),
                            )
                          ],
                        ),
                      ),
                      _input('+7 999 1234567', maskFormatter),
                      SizedBox(height: 40),
                      _button('ДАЛЕЕ', () {
                        print(maskFormatter.getMaskedText());
                      })
                    ],
                  )),
                ),
              ),
              color: Colors.white));
    });
  }
}
