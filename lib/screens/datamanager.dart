import 'package:flutter/cupertino.dart';

class DataManager {
  var _useruuid;
  var _userToken;

  static final DataManager ourInstance = DataManager();

  static GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  static DataManager getInstance() {
    return ourInstance;
  }

  String userId() {
    return _useruuid;
  }

  setUserId(value) {
    _useruuid = value;
  }

  String userToken() {
    return _userToken;
  }

  setUserToken(value) {
    _userToken = value;
  }
}
