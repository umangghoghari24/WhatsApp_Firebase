import 'package:firebaseconnection/commen/krmLoader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/Contact/class/selectContactClass.dart';
import '../features/Contact/controller/SelectContactController.dart';
import 'Defaultpic.dart';


class SearchView extends ConsumerStatefulWidget {
  static const String routeName = "select_contact";
  final device;
  const SearchView({required this.device ,super.key});
  void selectContact(
      Contact selectedcontact,
      BuildContext context,
      WidgetRef ref,
      String displayName

      ) {
    ref.read(selectContactsControllerprovider).selectContact(
      selectedcontact,
      context,
      displayName,
    );

  }

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  List<Contact> contacts = [];
  //this list holds the data for the listview
  List<Contact> founduser = [];

  void getContacts() async{
    ref.read(selectContactsClassProvider).getContacts().then(( value) {
      setState(() {
        contacts=value;
        contacts = value;
      });
    });
  }

  @override
  initState() {
    //at the beginning ,all users are show
    super.initState();
    getContacts();
  }



  // This function is called whenever the text filed changes
  void runFilter (String enterkeyword) {
    List<Contact> result = [];
    if(enterkeyword.isEmpty) {
      //if the seacrh filed is empty or only contains white-space, we'll display all user
      result = contacts;
    } else {

      result = contacts.where((user) =>
          user.name.toString().toLowerCase().contains(enterkeyword.toLowerCase())
      ).toList();

    }
    // Refresh the uid
    setState(() {
      founduser= result;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(
      //     child: Text("Search User Name",style: TextStyle(
      //         fontStyle: FontStyle.italic,
      //         fontWeight: FontWeight.bold
      //     ),),
      //   ),
      //   backgroundColor: Colors.purple,
      // ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 10,),
                TextFormField(
                  onChanged: (value) => runFilter(value),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      hintText: 'Search',
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(width: 2),
                      )
                  ),
                ),
                SizedBox(height: 10,),
                Expanded(
                    child: founduser.isNotEmpty ? ListView.builder(
                      itemCount: founduser.length,
                      itemBuilder: (context,index) => Card(
                        elevation: 1,
                        margin: EdgeInsets.symmetric(vertical: 2),
                        child: ListTile(
                          leading: contacts[index].photo != null
                              ? CircleAvatar(
                            radius: 30,
                            backgroundImage: MemoryImage(
                              contacts[index].photo!,
                            ),
                          )
                              : const CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              userprofilePic,
                            ),
                          ),
                            title: Text(
                              contacts[index].displayName,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            )
                        ),
                      ),
                    ) :
                    krmLoader()
                ),
                Text('No Result found please try with diffrent search',
                  style: TextStyle(
                      fontSize: 24),)
              ],
            ),
            ),
      );
    }
}



// import 'package:flutter/material.dart';
// class SearchView extends StatefulWidget {
//   const SearchView({Key? key}) : super(key: key);
//
//   @override
//   State<SearchView> createState() => _SearchViewState();
// }
//
// class _SearchViewState extends State<SearchView> {
//   final List<Map<String, dynamic >> alluser = [
//     //
//     // {
//     //   'image':'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8buhkcsawXn5N6pYtHacXLt5lc7NhIZwfrQ&usqp=CAU',
//     //   'Gender': 'male',
//     //   'name' : 'Umang',
//     //   'age' : 20
//     // },
//     // {
//     //   'image':'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cGVyc29ufGVufDB8fDB8fHww&w=1000&q=80',
//     //   'Gender': 'Female',
//     //   'name' : 'Nirali',
//     //   'age' : 20
//     // },
//     // {
//     //   'image':'https://cdn2.psychologytoday.com/assets/styles/manual_crop_1_91_1_1528x800/public/field_blog_entry_images/2018-09/shutterstock_648907024.jpg?itok=7lrLYx-B',
//     //   'Gender': 'Female',
//     //   'name' : 'Ankita',
//     //   'age' : 21
//     // },
//     // {
//     //   'image':'https://www.indiafilings.com/learn/wp-content/uploads/2023/03/Can-a-single-person-own-a-firm-in-India.jpg',
//     //   'Gender': 'male',
//     //   'name' : 'jay',
//     //   'age' : 10
//     // },
//     // {
//     //   'image':'https://cdn2.psychologytoday.com/assets/styles/manual_crop_1_91_1_1528x800/public/field_blog_entry_images/2018-09/shutterstock_648907024.jpg?itok=7lrLYx-B',
//     //   'Gender': 'female',
//     //   'name' : 'jaya',
//     //   'age' : 30
//     // },
//     // {
//     //   'image':'https://img.freepik.com/free-photo/portrait-handsome-man-with-dark-hairstyle-bristle-toothy-smile-dressed-white-sweatshirt-feels-very-glad-poses-indoor-pleased-european-guy-being-good-mood-smiles-positively-emotions-concept_273609-61405.jpg',
//     //   'Gender': 'male',
//     //   'name' : 'raju',
//     //   'age' : 15
//     // },
//     // {
//     //   'image':'https://images.unsplash.com/flagged/photo-1570612861542-284f4c12e75f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cGVyc29ufGVufDB8fDB8fHww&w=1000&q=80',
//     //   'Gender': 'male',
//     //   'name' : 'sahil',
//     //   'age' : 19
//     // },
//     // {
//     //   'image':'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8buhkcsawXn5N6pYtHacXLt5lc7NhIZwfrQ&usqp=CAU',
//     //   'Gender': 'male',
//     //   'name' : 'Vijay',
//     //   'age' : 20
//     // },
//     // {
//     //   'image':'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cGVyc29ufGVufDB8fDB8fHww&w=1000&q=80',
//     //   'Gender': 'Female',
//     //   'name' : 'yuvraj',
//     //   'age' : 20
//     // },
//     // {
//     //   'image':'https://cdn2.psychologytoday.com/assets/styles/manual_crop_1_91_1_1528x800/public/field_blog_entry_images/2018-09/shutterstock_648907024.jpg?itok=7lrLYx-B',
//     //   'Gender': 'Female',
//     //   'name' : 'ravina',
//     //   'age' : 21
//     // },
//     // {
//     //   'image':'https://www.indiafilings.com/learn/wp-content/uploads/2023/03/Can-a-single-person-own-a-firm-in-India.jpg',
//     //   'Gender': 'male',
//     //   'name' : 'Kajal',
//     //   'age' : 10
//     // },
//     // {
//     //   'image':'https://cdn2.psychologytoday.com/assets/styles/manual_crop_1_91_1_1528x800/public/field_blog_entry_images/2018-09/shutterstock_648907024.jpg?itok=7lrLYx-B',
//     //   'Gender': 'female',
//     //   'name' : 'Nayan',
//     //   'age' : 30
//     // },
//     // {
//     //   'image':'https://img.freepik.com/free-photo/portrait-handsome-man-with-dark-hairstyle-bristle-toothy-smile-dressed-white-sweatshirt-feels-very-glad-poses-indoor-pleased-european-guy-being-good-mood-smiles-positively-emotions-concept_273609-61405.jpg',
//     //   'Gender': 'male',
//     //   'name' : 'mihir',
//     //   'age' : 15
//     // },
//     // {
//     //   'image':'https://images.unsplash.com/flagged/photo-1570612861542-284f4c12e75f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cGVyc29ufGVufDB8fDB8fHww&w=1000&q=80',
//     //   'Gender': 'male',
//     //   'name' : 'jaydev',
//     //   'age' : 19
//     // },
//   ];
//   //this list holds the data for the listview
//   List<Map<String, dynamic>> founduser = [];
//
//   @override
//   initState() {
//     //at the beginning ,all users are show
//     founduser = alluser;
//     super.initState();
//   }
//   // This function is called whenever the text filed changes
//   void runFilter (String enterkeyword) {
//     List<Map<String, dynamic>> result = [];
//     if(enterkeyword.isEmpty) {
//       //if the seacrh filed is empty or only wwcontains white-space, we'll display all user
//       result = alluser;
//     } else {
//
//       result = alluser.where((user) =>
//       // user['name'].toLowerCase().contanis(enterkeyword.toLowerCase())
//       user['name'].toLowerCase().contains(enterkeyword.toLowerCase())
//       ).toList();
//
//     }
//     // Refresh the uid
//     setState(() {
//       founduser= result;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Center(
//             child: Text("Search User Name",style: TextStyle(
//                 fontStyle: FontStyle.italic,
//                 fontWeight: FontWeight.bold
//             ),),
//           ),
//           backgroundColor: Colors.purple,
//         ),
//         body: Padding(
//             padding: const EdgeInsets.all(10),
//             child: Column(
//               children: [
//                 SizedBox(height: 10,),
//                 TextFormField(
//                   onChanged: (value) => runFilter(value),
//                   decoration: InputDecoration(
//                       contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
//                       hintText: 'Search',
//                       suffixIcon: Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         borderSide: BorderSide(width: 2),
//                       )
//                   ),
//                 ),
//                 SizedBox(height: 10,),
//                 Expanded(
//                     child: founduser.isNotEmpty ? ListView.builder(
//                       itemCount: founduser.length,
//                       itemBuilder: (context,index) => Card(
//                         elevation: 1,
//                         margin: EdgeInsets.symmetric(vertical: 2),
//                         child: ListTile(
//                           leading: CircleAvatar(
//                             radius: 30,
//                             backgroundImage: NetworkImage(founduser[index]['image']),
//                             backgroundColor: Colors.transparent,
//                           ),
//                           title: Text(founduser[index]['name']),
//                           subtitle: Row(
//                             children: [
//                               Text('${founduser[index]['Gender']}'),
//                               SizedBox(width: 8,),
//                               Text('${founduser[index]['age']}'),
//                             ],
//                           ),
//
//                         ),
//                       ),
//                     ) : Text('No Result found please try with diffrent search',
//                       style: TextStyle(
//                           fontSize: 24),)
//                 ),
//               ],
//             ),
//             ),
//         );
//     }
// }
