import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:marocsie/app/widgets/dialog_widget.dart';

class PermissionUtils {
  static void requestPermission(
    List<Permission> permission,
    BuildContext context, {
    Function? permissionGrant,
    Function? permissionDenied,
    Function? permissionNotAskAgain,
    bool isOpenSettings = false,
    bool isShowMessage = false,
    required String message,
  }) {
    // permission.request().then((value) {

    // },)
    permission.request().then((statuses) {
      var allPermissionGranted = true;

      statuses.forEach((key, value) {
        allPermissionGranted =
            allPermissionGranted && (value == PermissionStatus.granted);
      });
      print("All Permissions granted: $allPermissionGranted " );
      if (allPermissionGranted) {
        if (permissionGrant != null) {
          permissionGrant();
        }
      } else {
        if (permissionDenied != null) {
          permissionDenied();
        }
        if (isOpenSettings) {
          DialogWidgets.showOkCancelAlertDialog(
            context: context,
            message: message,
            cancelButtonTitle: Platform.isAndroid ? "No" : "Cancel",
            okButtonTitle: Platform.isAndroid ? "Yes" : "Ok",
            cancelButtonAction: () {},
            okButtonAction: () {
              openAppSettings();
            },
          );
        } else if (isShowMessage) {
          DialogWidgets.showAlertDialog(context,
              """Please grant the required permission from settings to access this feature.""");
        }
      }
    });
  }
}
