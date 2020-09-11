import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:fluttergametrieuphu/base/base_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Injection {
  static Injector injector = Injector.getInjector();

  static initInjection() async {
    final preferences = await SharedPreferences.getInstance();
    injector.map<BaseBloc>((i) => BaseBloc(preferences), isSingleton: false);
  }
}
