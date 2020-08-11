import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:fluttergametrieuphu/base/base_bloc.dart';

class Injection {
  static final injection = Injector.getInjector();

  static initInjection() {
    injection.map<BaseBloc>((injector) => BaseBloc("test"));
  }
}
