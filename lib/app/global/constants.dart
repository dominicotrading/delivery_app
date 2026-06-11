// ignore_for_file: constant_identifier_names
import 'package:get/get.dart';

const String MOBILE_CONNECTION_STATUS = "ConnectivityResult.mobile";
const String WIFI_CONNECTION_STATUS = "ConnectivityResult.wifi";
const String AGORA_APP_ID = "941990c5bcb149469923d6f690567282";
// int unseenMsgCount = 0;
// ResCallRequestModel? bgCallReqModel;

final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

List<String> genderType = ["Male", "Female"];

bool appInBg = false.obs();
double inputBorderRadius = 30;