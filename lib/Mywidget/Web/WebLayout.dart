import 'package:firebaseconnection/Model/ChatContactModel.dart';
import 'package:firebaseconnection/Mywidget/Mobile/chats.dart';
import 'package:firebaseconnection/features/auth/views/EnterNumber.dart';
import 'package:firebaseconnection/features/Chat/views/personal%20sms.dart';
import 'package:flutter/material.dart';

import '../../Model/modal.dart';

class WebLayout extends StatelessWidget {
  WebLayout({this.friends, super.key});

  final ChatContactModel? friends;
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var totalwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: totalwidth / 2.9,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 8,
                  width: totalwidth / 2.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assest/images/person.jpg'),
                          radius: 30,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.people))
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 15,
                        width: totalwidth / 3.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.search),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3.9,
                              child: TextFormField(
                                controller: name,
                                decoration: InputDecoration(
                                    hintText: 'Search or start new chat'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.filter_list),
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                Expanded(child: Chats(device: 'web'))
              ],
            ),
          ),
          Expanded(
            child: Visibility(
              visible: friends != null,
              replacement: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTi6LhidYotN7iTYDIOvKWorKEF_CfeEjWjFQ&usqp=CAU',
                      height: 70,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'WhatsApp for Window',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Send and receive messages without keeping your phone online.',
                      // style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Use  Whatsapp on up to 4 linkind device and 1 phone at the same time.',
                      // style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              child: personalsms(uid: '',
                uname: '',
                isGroup: false,
                members: '',
                groupPic: '',
                members_name: '',
              ),
            ),
          )
        ],
      ),
      // body: Row(
      //   children: [
      //     //contacts
      //
      //
      //
      //     //chatview
      //
      //
      //   ],
      // ),
    );
  }
}
