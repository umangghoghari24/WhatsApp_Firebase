import 'package:firebaseconnection/Model/ChatContactModel.dart';
import 'package:firebaseconnection/Mywidget/Web/WebLayout.dart';
import 'package:firebaseconnection/commen/ErrorPage.dart';
import 'package:firebaseconnection/commen/krmLoader.dart';
import 'package:firebaseconnection/features/Chat/Controller/ChatController.dart';
import 'package:firebaseconnection/features/Chat/views/personal%20sms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../Model/GroupModel.dart';
import '../../Model/modal.dart';
import '../../features/Contact/views/SelectContactScreen.dart';

class Chats extends ConsumerStatefulWidget {
  final String device;


  const Chats({required this.device, super.key});

  @override
  ConsumerState<Chats> createState() => _ChatsState();
}

class _ChatsState extends ConsumerState<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            StreamBuilder<List<GroupModel>>(
                stream: ref.read(chatClassControllerProvider).getGroups(),
                builder: (context, snapshots) {
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return const krmLoader();
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshots.data != null ? snapshots.data!.length : 0,
                      itemBuilder: (context, index) {
                        GroupModel groupModel = snapshots.data![index];
                        return InkWell(
                          onTap: () {
                            if (widget.device == 'mobile') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => personalsms(
                                    uid: groupModel.groupId,
                                    uname: groupModel.name,
                                    isGroup: false,
                                  ),
                                ),
                              );
                            } else {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => WebLayout(
                              //       friends: groupModel.groupId,
                              //
                              //     ),
                              //   ),
                              // );
                            }
                          },
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                    groupModel.groupPic,
                                  ),
                                ),
                                title: Text(
                                  groupModel.name,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    groupModel.lastMessage,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                trailing: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    DateFormat.Hm().format(groupModel.timeSent),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              // const Divider(
                              //   color: Colors.black,
                              //   // indent: 5,
                              // )
                            ],
                          ),
                        );
                      });
                }),

            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: StreamBuilder<List<ChatContactModel>>(
                  stream: ref.watch(chatClassControllerProvider).getChatcontacts(),
                  builder: (context, snapshots) {
                    if (snapshots.connectionState == ConnectionState.waiting) {
                      return krmLoader();
                    }
                    List<ChatContactModel> chatcontacts = snapshots.data!;
                    return ListView.builder(
                      itemCount: chatcontacts.length,
                      itemBuilder: (context, index) {
                        ChatContactModel contactlist = chatcontacts[index];

                        var timeSent = DateFormat.Hm().format(contactlist.timeSent);
                        return ListTile(
                          onTap: () {
                            if (widget.device == 'mobile') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => personalsms(
                                    uid: contactlist.contactId,
                                    uname: contactlist.name,
                                    isGroup: true,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WebLayout(
                                            friends: contactlist,
                                          )));
                            }
                          },
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              contactlist.profilePic,
                            ),
                          ),
                          title: Text(contactlist.name.toString() ?? ''),
                          subtitle: Text(contactlist.lastMessage ?? ''),
                          trailing: Text(timeSent.toString() ?? ''),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chat),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectContactsScreen(device: 'mobile')));
          },
      ),
    );
  }
}
