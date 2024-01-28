// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:animated_custom_dropdown/custom_dropdown.dart';
// import 'package:getdonor/utils/app_constants.dart';
// import 'package:http/http.dart' as http;
// import '../../model/provinsi_model.dart';

// class MyDropdownScreen extends StatefulWidget {
//   final Function(int) onSelected;

//   MyDropdownScreen({required this.onSelected});
//   @override
//   _MyDropdownScreenState createState() => _MyDropdownScreenState();
// }

// class _MyDropdownScreenState extends State<MyDropdownScreen> {
  

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: CustomDropdown<Provinsi>.searchRequest(
//         futureRequest: fetchProvinsiData,
//         hintText: 'Search Province',
//         items: [], // Initially empty, will be populated by futureRequest
//         onChanged: (Provinsi? value) {
//           print('Selected Province: ${value?.idProv}');
//           setState(() {});
//         },
//         // Add any other necessary properties according to your requirements
//       ),
//     );
//   }
// }
