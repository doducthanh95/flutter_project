import 'package:flutter/widgets.dart';
import 'package:fluttergametrieuphu/di/Injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseBloc {
  SharedPreferences preferences;

  BaseBloc(this.preferences);

  void depose() {}

  void reload() {}
}
