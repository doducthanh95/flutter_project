import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DynamicLinkService {
  Future handleDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(data);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLinkData) async {
      _handleDeepLink(data);
    }, onError: (OnLinkErrorException e) {
      print('DynamicLink error ${e.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      print('ddthanh _handleDeepLink: ${data.link}');
    }
  }

  Future<String> createDynamicLink(LatLng lat, double zoom) async {
    final ShortDynamicLink shortenedLink =
        await DynamicLinkParameters.shortenUrl(Uri.parse(
            'https://flutterapplaban.page.link/shortUrl/?link=$zoom'));

    final Uri shortUrl = shortenedLink.shortUrl;
    return shortUrl.toString();
  }
}
