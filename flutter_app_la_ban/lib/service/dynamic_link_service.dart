import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DynamicLinkService {
  Future handleDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(data);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLinkData) async {
      _handleDeepLink(dynamicLinkData);
    }, onError: (OnLinkErrorException e) {
      print('DynamicLink error ${e.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      print('_handleDeepLink: ${data.link}');
    }
  }

  Future<String> createDynamicLink(LatLng lat, double zoom) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://flutterapplaban.page.link',
        link: Uri.parse(
          'https://www.compound.com/post?lat=${lat.latitude}&long=${lat.longitude}',
        ),
        androidParameters: AndroidParameters(
          packageName: 'com.example.flutter_app_la_ban',
        ),
        iosParameters: IosParameters(
            bundleId: 'com.example.flutterAppLaBan',
            minimumVersion: '1.0',
            appStoreId: '1534484049'));
    ShortDynamicLink dynamicUrl = await parameters.buildShortLink();
    return dynamicUrl.shortUrl.toString();
  }
}
