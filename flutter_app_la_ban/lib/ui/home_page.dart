import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:ILaKinh/bloc/map_bloc.dart';
import 'package:ILaKinh/const/const_value.dart';
import 'package:ILaKinh/service/dynamic_link_service.dart';
import 'package:ILaKinh/ui/compass_page.dart';
import 'package:ILaKinh/ui/map_page.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/subjects.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  double agle = 0;
  ScreenshotController _screenshotController = ScreenshotController();
  final _bloc = MapBloc();
  DynamicLinkService _dynamicLink;

  GlobalKey _containerKey = GlobalKey();

  Uint8List _image;
  Uint8List _image2;
  bool _isShowChildScreen = false;

  @override
  void initState() {
    // TODO: implement initState
    _dynamicLink = DynamicLinkService(_bloc);
    _handleDeepLink();

    _bloc.streamMapSnapshoot.listen((event) {
      if (event != null)
        setState(() {
          _image = event;
        });
    });
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
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            MapPage(
              bloc: _bloc,
              parentContext: context,
            ),
            RepaintBoundary(
              key: _containerKey,
              child: IgnorePointer(
                  child: CompassPage(
                bloc: _bloc,
              )),
            ),
            Visibility(
              visible: _isShowChildScreen,
              child: _captureScreenWidget(),
            )
          ],
        ),
      ),
    );
  }

  Widget _captureScreenWidget() {
    return _image == null
        ? Container()
        : Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
              height: MediaQuery.of(context).size.height / 4 - 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.blue)),
              child: Screenshot(
                controller: _screenshotController,
                child: Stack(
                  children: [
                    Image(
                      image: MemoryImage(_image),
                    ),
                    Image(image: MemoryImage(_image2))
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
    _bloc.takeMapSnapshot();

    RenderRepaintBoundary renderRepaintBoundary =
        _containerKey.currentContext.findRenderObject();
    ui.Image boxImage = await renderRepaintBoundary.toImage(pixelRatio: 1);
    ByteData byteData =
        await boxImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uInt8List = byteData.buffer.asUint8List();
    _image2 = uInt8List;
    setState(() {
      _isShowChildScreen = true;
    });

    var _newFile = await _screenshotController.capture(pixelRatio: 10);
    await GallerySaver.saveImage(_newFile.path);
    Future.delayed(Duration(seconds: 2)).then((value) {
      setState(() {
        _isShowChildScreen = false;
      });
    });
  }
}
