import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../bloc/error_handling/index.dart';
import 'buttons/dialog_button.dart';

mixin ShowDialogMixin {
  void showSimpleDialog(
      {required BuildContext context,
      required String message,
      VoidCallback? onOkPressed,
      VoidCallback? onDismiss}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final localizations = AppLocalizations.of(context)!;
          return WillPopScope(
            onWillPop: () {
              onDismiss?.call();
              return Future.value(true);
            },
            child: AlertDialog(
                content: Text(message),
                contentPadding: EdgeInsets.fromLTRB(24, 40, 16, 34),
                actions: <Widget>[
                  DialogButton(
                      title: localizations.ok,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onOkPressed?.call();
                      }),
                ]),
          );
        });
  }

  void showTwoButtonsDialog(
      {required BuildContext context,
      required String message,
      String? okButtonTitle,
      String? cancelButtonTitle,
      VoidCallback? onOkPressed,
      VoidCallback? onDismiss}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final localizations = AppLocalizations.of(context)!;
          return WillPopScope(
            onWillPop: () {
              onDismiss?.call();
              return Future.value(true);
            },
            child: AlertDialog(
                content: Text(message),
                contentPadding: EdgeInsets.fromLTRB(24, 40, 16, 34),
                actions: <Widget>[
                  DialogButton(
                      title: cancelButtonTitle ?? localizations.cancel,
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  DialogButton(
                      title: okButtonTitle ?? localizations.ok,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onOkPressed?.call();
                      }),
                ]),
          );
        });
  }

  void showErrorDialog({
    required BuildContext context,
    required ErrorDialogMessage errorMessage,
    VoidCallback? onOkPressed,
    VoidCallback? onDismiss,
  }) {
    final localizations = AppLocalizations.of(context)!;
    String message;
    switch (errorMessage) {
      case ErrorDialogMessage.somethingWentWrong:
        message = localizations.somethingWentWrong;
        break;
      case ErrorDialogMessage.serverIsNotAvailable:
        message = localizations.serverIsNotAvailable;
        break;
      case ErrorDialogMessage.connectionTimeout:
        message = localizations.connectionTimeout;
        break;
      case ErrorDialogMessage.connectionError:
        message = localizations.connectionError;
        break;
      case ErrorDialogMessage.apiResponseParsingError:
        message = localizations.apiResponseParsingError;
        break;
      case ErrorDialogMessage.badRequest:
        message = localizations.badRequest;
        break;
      case ErrorDialogMessage.authorizationError:
        message = localizations.authorizationError;
        break;
      case ErrorDialogMessage.forbidden:
        message = localizations.forbidder;
        break;
      case ErrorDialogMessage.resourceNotFound:
        message = localizations.resourceNotFound;
        break;
      case ErrorDialogMessage.methodNotAllowed:
        message = localizations.methodNotAllowed;
        break;
      case ErrorDialogMessage.internalServerError:
        message = localizations.internalServerError;
        break;
      case ErrorDialogMessage.badGateway:
        message = localizations.badGateway;
        break;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
              onWillPop: () {
                onDismiss?.call();
                return Future.value(true);
              },
              child: AlertDialog(
                  title: Text(localizations.error),
                  content: Text(message),
                  actions: <Widget>[
                    DialogButton(
                        title: localizations.ok,
                        onPressed: () {
                          Navigator.of(context).pop();
                          onOkPressed?.call();
                        }),
                  ]));
        });
  }
}
