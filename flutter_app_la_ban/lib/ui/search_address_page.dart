// import 'dart:html';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_app_la_ban/const/const_value.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_webservice/places.dart';
//
// class SearchAddressPage extends StatefulWidget {
//   @override
//   _SearchAddressPageState createState() => _SearchAddressPageState();
// }
//
// class _SearchAddressPageState extends State<SearchAddressPage> {
//   TextEditingController _editingController;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     _editingController = TextEditingController(text: "123");
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.close),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         title: Text("Search"),
//       ),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Column(
//           children: [
//             buildSearchBar(),
//             Expanded(
//                 child: ListView.separated(
//                     itemBuilder: (BuildContext context, index) => ListTile(
//                           title: Text("afdsaf"),
//                         ),
//                     separatorBuilder: (context, index) => Divider(),
//                     itemCount: 10))
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildSearchBar() {
//     return Container(
//       height: 44,
//       margin: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.grey,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Icon(Icons.search),
//           ),
//           Expanded(
//             child: TextFormField(
//               onTap: () async {
//                 GeolocatorPlatform.instance.
//               },
//               decoration: InputDecoration(
//                   hintText: "Nhập địa chỉ", border: InputBorder.none),
//               controller: _editingController,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
