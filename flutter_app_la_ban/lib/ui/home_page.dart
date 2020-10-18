import 'dart:async';
import 'dart:io';

import 'package:ILaKinh/bloc/map_bloc.dart';
import 'package:ILaKinh/const/const_value.dart';
import 'package:ILaKinh/service/dynamic_link_service.dart';
import 'package:ILaKinh/ui/compass_page.dart';
import 'package:ILaKinh/ui/map_page.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:rxdart/subjects.dart';
import 'package:screenshot/screenshot.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  double agle = 0;
  ScreenshotController _screenshotController = ScreenshotController();
  final _bloc = MapBloc();
  DynamicLinkService _dynamicLink;

  var testLink = '123456';

  @override
  void initState() {
    // TODO: implement initState
    _dynamicLink = DynamicLinkService(_bloc);
    _handleDeepLink();
    super.initState();
  }

  void _handleDeepLink() async {
    _dynamicLink.handleDynamicLinks();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    if (state == AppLifecycleState.resumed) {
      _handleDeepLink();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(
        appBar: AppBar(
          title: Text("La bàn số"),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _showMore,
            )
          ],
        ),
        body: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              MapPage(
                bloc: _bloc,
                parentContext: context,
              ),
              IgnorePointer(
                  child: CompassPage(
                bloc: _bloc,
              ))
            ],
          ),
        ),
      ),
    );
  }

  _showMore() {
    showCupertinoModalPopup(
        context: context,
        builder: (builder) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                  child: Text("Chia sẻ vị trí"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _shareLocation();
                  }),
              CupertinoActionSheetAction(
                child: Text("Chụp màn hình"),
                onPressed: _captureScreen,
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text("Hủy"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  Future<void> _shareLocation() async {
    String url = await _dynamicLink.createDynamicLink(_bloc.getPosition(), 20);
    await FlutterShare.share(title: "Share", linkUrl: url);
  }

  _captureScreen() async {
    Navigator.pop(context);
    print("File Saved to Gallery");

    _screenshotController
        .capture(delay: Duration(milliseconds: 10))
        .then((File image) async {
      GallerySaver.saveImage(image.path)
          .then((value) => showToast("Lưu ảnh thành công!"));
    }).catchError((onError) {
      print(onError);
    });
  }
}
