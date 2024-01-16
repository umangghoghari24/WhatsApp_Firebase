// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class status extends StatefulWidget {
//
//   const status({Key? key}) : super(key: key);
//
//
//   @override
//   State<status> createState() => _statusState();
// }
//
// File ? _imageFile;
//
//
//
// class _statusState extends State<status> {
//   var myfriend1=[
//     'umang',
//     'nirali',
//     'rakesh',
//     'ankita',
//     'vijay',
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Container(
//               child: ListTile(
//                   trailing: Icon(Icons.more_horiz),
//                   leading: Stack(
//                       children: <Widget> [
//                         CircleAvatar(
//                           radius: 30,
//                           backgroundColor: Colors.blue,
//                           backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2016/11/14/04/45/elephant-1822636_960_720.jpg"),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.all(Radius.circular(100)),
//                               border: Border.all(color: Colors.red),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 3,
//                           right:1,
//                           child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.green,
//                                 borderRadius: BorderRadius.all(Radius.circular(20)),
//                               ),
//                               height: 28,
//                               width: 30,
//                               child: IconButton(onPressed: () {
//                                   showModalBottomSheet(
//                                       context: context,
//                                       builder: (context) {
//                                         return Wrap(children: [
//                                           ListTile(
//                                             onTap: () {
//                                               getfromcamera();
//                                             },
//                                             leading: Padding(
//                                               padding:
//                                               const EdgeInsets.only(left: 110),
//                                               child: Icon(
//                                                 Icons.camera_alt,
//                                               ),
//                                             ),
//                                             title: Text('Camera',
//                                                 style: TextStyle(
//                                                     fontStyle: FontStyle.italic,
//                                                     fontSize: 17,
//                                                     fontWeight: FontWeight.bold)),
//                                           ),
//                                           Divider(thickness: 1),
//                                           ListTile(
//                                               onTap: () {
//                                                 getfromgallry();
//                                               },
//                                               leading: Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     left: 110),
//                                                 child: Icon(Icons.image),
//                                               ),
//                                               title: Text('Gallery',
//                                                   style: TextStyle(
//                                                       fontStyle: FontStyle.italic,
//                                                       fontSize: 17,
//                                                       fontWeight:
//                                                       FontWeight.bold))),
//                                         ]);
//                                       });
//                               },
//                                   icon: Icon(Icons.add,
//                                     color: Colors.black,
//                                     size: 25,))
//                           ),
//                         )
//                       ]
//                   ),
//                   title: Text("My Status"),
//                   subtitle: Text('Today 8:15 AM')
//               ),
//             ),
//             Divider(
//               thickness: 1.5,
//             ),
//             ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: myfriend1.length,
//                 itemBuilder: (context,index){
//                   return
//                     Container(
//                       child: ListTile(
//                         onTap: (){
//                         },
//                         leading: CircleAvatar(
//                           backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2016/11/14/04/45/elephant-1822636_960_720.jpg"
//                           ),
//                           radius: 30,
//                           backgroundColor: Colors.blue,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.all(Radius.circular(100)),
//                               border: Border.all(color: Colors.red),
//                             ),
//                           ),
//                         ),
//                         title: Text(myfriend1[index]),
//                         subtitle: Text('just now'),
//                       ),
//                     );
//                 }
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//               onPressed: (
//                   ) {
//                 print('Type a status');
//               },
//               child:IconButton(
//                 onPressed: () {
//                   //    Navigator.push(context,MaterialPageRoute(builder: (context)=>personalstatus()));
//                 },icon: Icon(Icons.edit),
//               )
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           FloatingActionButton(
//             onPressed: () {
//               print('select photos');
//             },
//             child: Icon(Icons.camera_alt_outlined),
//           ),
//         ],
//       ),
//     );
//   }
//   getfromgallry() async {
//     final pickedFile = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//     );
//     if (pickedFile == null) return;
//     setState(() {
//       _imageFile = File(pickedFile.path);
//     });
//   }
//
//   getfromcamera() async {
//     final pickedFile = await ImagePicker()
//         .pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }
// }
//
