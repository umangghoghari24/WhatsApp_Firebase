import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../commen/Defaultpic.dart';
import '../../../commen/krmLoader.dart';
import '../../Group/views/CreateGroupScreen.dart';
import '../class/selectContactClass.dart';
import '../controller/SelectContactController.dart';

// class SelectContactsScreen extends ConsumerWidget {
//   static const String routeName = "select_contact";
//   final device;
//   const SelectContactsScreen({required this.device,super.key});
class SelectContactsScreen extends ConsumerStatefulWidget {

  static const String routeName = "select_contact";
  final device;
  const SelectContactsScreen({required this.device ,super.key});

  @override
  ConsumerState<SelectContactsScreen> createState() => _SelectContactsScreenState();
}

class _SelectContactsScreenState extends ConsumerState<SelectContactsScreen> {
  List<Contact> contacts = [];
  //this list holds the data for the listview
  List<Contact> founduser = [];
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


  void getContacts() async{
    ref.read(selectContactsClassProvider).getContacts().then((value) {
      setState(() {
        contacts=value;
        founduser = value;
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
      print(founduser);
    });

  }

  bool issearch=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: issearch? TextFormField(
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
          ) : const Text("Select Contact"),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  issearch=!issearch;
                });
              },
              icon: issearch?const Icon(Icons.cancel) : const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Column(
          children: [
            ListTile(
              title: Row(
                children: [
                  // SizedBox(width: 8,),
                  CircleAvatar(radius: 38,
                      backgroundImage: NetworkImage(
                        userprofilePic,
                      ),
                  ),
                  SizedBox(width: 10,),
                  Text('New Group'),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreatGroupScreen()));
              },
            ),
            Divider(thickness: 0.6,),
            SizedBox(
              height: MediaQuery.of(context).size.height/1.4,
              child: founduser.isNotEmpty ? ListView.builder(
              itemCount: founduser.length,
              itemBuilder: (context,index) => Container(
                margin: const EdgeInsets.symmetric(vertical: 7),
                child: ListTile(
                  onTap: () {
                    selectContact(founduser[index], context, ref,founduser[index].displayName);
                  },
                  leading: founduser[index].photo != null
                      ? CircleAvatar(
                    radius: 40,
                    backgroundImage: MemoryImage(founduser[index].photo!),
                    backgroundColor: Colors.transparent,

                  ) : const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      userprofilePic,
                    ),
                  ),
                  title: Text(founduser[index].displayName.toString()),
                ),
               ),
              )  :  krmLoader(),
            ),
          ],
        ),
    );
  }

  Widget serchview(){
    return Padding(
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
                    itemBuilder: (context,index) => Container(
                      child: Card(
                        elevation: 1,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: ListTile(
                            leading: founduser[index].photo != null
                                ? CircleAvatar(
                              radius: 40,
                              backgroundImage: MemoryImage(founduser[index].photo!),
                              backgroundColor: Colors.transparent,
                            ):const CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                userprofilePic,
                              ),
                            ),
                            title: Text(founduser[index].displayName.toString()),
                          ),
                        ),
                      ),
                    ),
                  ) : krmLoader()
              ),
            ],
            ),

        );
  }
}

// import 'package:firebaseconnection/commen/Colors.dart';
// import 'package:firebaseconnection/commen/Defaultpic.dart';
// import 'package:firebaseconnection/commen/ErrorPage.dart';
// import 'package:firebaseconnection/commen/SearchView.dart';
// import 'package:firebaseconnection/commen/krmLoader.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../commen/Colors.dart';
// import '../../../commen/Defaultpic.dart';
// import '../controller/SelectContactController.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
//
// class SelectContactsScreen extends ConsumerWidget {
//   static const String routeName = "select_contact";
//   final device;
//   const SelectContactsScreen({required this.device, super.key,});
//
//   void selectContact(
//       Contact selectedcontact,
//       BuildContext context,
//       WidgetRef ref,
//       String displayName
//       ) {
//     ref.read(selectContactsControllerprovider).selectContact(
//       selectedcontact,
//        context,
//       displayName
//     );
//   }
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor:  Color(0xff128C7E),
//           title:  Text("Select Contact"),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchView(device: 'mobile')));
//               },
//               icon:  Icon(Icons.search),
//             ),
//             PopupMenuButton(
//                 icon: Icon(Icons.more_vert),
//                 itemBuilder: (context) => [
//                   PopupMenuItem(child: Text("Invite a friend")),
//                   PopupMenuItem(child: Text("Contacts")),
//                   PopupMenuItem(child: Text("Refresh")),
//                   PopupMenuItem(child: Text("Help")),
//                 ]),
//           ],
//         ),
//         body: ref.watch(selectContactsControllerfutureprovider).when(
//             data: (contactlist) {
//               return ListView.builder(
//                 itemCount: contactlist.length,
//                 itemBuilder: (context, index) {
//                   if (index==0) {
//                     return Row(
//                       children: [
//                         SizedBox(width: MediaQuery.of(context).size.width/20,),
//                         SizedBox(height: 60,),
//                         CircleAvatar(
//                           child: IconButton( onPressed: () {},
//                             icon: Icon(Icons.people),
//                           ),
//                           radius: 25,
//                           backgroundColor: Colors.white,
//                         ),
//                         Text('New group'),
//                       ],
//                     );
//                   } else if (index ==1 ) {
//                     return Row(
//                       children: [
//                         SizedBox(width: MediaQuery.of(context).size.width/20,),
//                         CircleAvatar(
//                           child: IconButton( onPressed: () {},
//                             icon: Icon(Icons.person_add),
//                           ),
//                           radius: 25,
//                           backgroundColor: Colors.white,
//                         ),
//                         Text('New contact'),
//                       ],
//                     );
//                   }
//                   contactlist[index].photo;
//                   return InkWell(
//                     onTap: () {
//                       selectContact(contactlist[index], context, ref, contactlist[index].displayName);
//                     },
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8),
//                           child: ListTile(
//                             leading: contactlist[index].photo != null
//                                 ? CircleAvatar(
//                               radius: 30,
//                               backgroundImage: MemoryImage(
//                                 contactlist[index].photo!,
//                               ),
//                             )
//                                 : const CircleAvatar(
//                               radius: 30,
//                               backgroundImage: NetworkImage(
//                                 userprofilePic,
//                               ),
//                             ),
//                             title: Text(
//                               contactlist[index].displayName,
//                               style: const TextStyle(
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ),
//                         ),
//                         // const Divider(
//                         //   color: dividerColor,
//                         // )
//                       ],
//                     ),
//                   );
//                 },
//               );
//             },
//             error: (error, trace) {
//               return ErrorPage(
//                 error: error.toString(),
//               );
//             },
//             loading: () {
//               return const krmLoader();
//             },
//             ),
//         );
//     }
// }