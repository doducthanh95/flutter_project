import 'dart:async';
import 'dart:io';

import 'package:ILaKinh/bloc/map_bloc.dart';
import 'package:ILaKinh/service/dynamic_link_service.dart';
import 'package:ILaKinh/ui/compass_page.dart';
import 'package:ILaKinh/ui/map_page.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:rxdart/subjects.dart';
import 'package:screenshot/screenshot.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  double agle = 0;
  ScreenshotController _screenshotController = ScreenshotController();
  MapBloc _bloc = MapBloc();
  final _dynamicLink = DynamicLinkService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _handleDeepLink();
  }

  void _handleDeepLink() async {
    await _dynamicLink.handleDynamicLinks();
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _handleDeepLink();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("La bàn số"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showMore,
          )
        ],
      ),
      body: Screenshot(
        controller: _screenshotController,
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              MapPage(
                bloc: _bloc,
              ),
              IgnorePointer(
                  child: CompassPage(
                bloc: _bloc,
                callBack: (double value) {
                  setState(() {
                    agle = value;
                  });
                },
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
                child: Text("Xoay theo bản đồ"),
                onPressed: () {},
              ),
              CupertinoActionSheetAction(
                child: Text("Chia sẻ vị trí"),
                onPressed: _shareLocation,
              ),
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
    Navigator.pop(context);
    await FlutterShare.share(title: "Share", linkUrl: url);
  }

  _captureScreen() async {
    Navigator.pop(context);
    print("File Saved to Gallery");
    _screenshotController
        .capture(delay: Duration(milliseconds: 10))
        .then((File image) async {
      final result = await ImageGallerySaver.saveImage(image.readAsBytesSync());
      print("File Saved to Gallery");
    }).catchError((onError) {
      print(onError);
    });
  }
}
