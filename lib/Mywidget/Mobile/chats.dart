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
  final bool isGroup;
  final String reciveruid;

  const Chats({required this.device,required this.isGroup,required this.reciveruid, super.key});

  @override
  ConsumerState<Chats> createState() => _ChatsState();
}

class _ChatsState extends ConsumerState<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
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

                          var timeSent = DateFormat.Hm().format(groupModel.timeSent);

                          String members_name = "";
                          if(groupModel.members_name.isNotEmpty) {
                            for (String value in groupModel.members_name)
                              if (value == "") {
                                members_name+="You ,";
                              }
                            else {
                              members_name+="$value ,";
                              }
                          }
                          return ListTile(
                            onTap: () {
                              if (widget.device == 'mobile') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => personalsms(
                                      uid: groupModel.groupId,
                                      uname: groupModel.name,
                                      groupPic: groupModel.groupPic,
                                      members: groupModel.members.toString(),
                                      isGroup: true,
                                      members_name: members_name,

                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebLayout(
                                    ),
                                  ),
                                );
                              }
                            },
                            // child: ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  groupModel.groupPic,
                                ),
                              ),
                              title: Text(groupModel.name.toString(),),
                              subtitle: Text(groupModel.lastMessage.toString() ?? '' ,),
                              trailing: Text(timeSent.toString() ?? '',),
                            // ),
                          );
                        });
                  }),

              StreamBuilder<List<ChatContactModel>>(
                  stream: ref.watch(chatClassControllerProvider).getChatcontacts(),
                  builder: (context, snapshots) {
                    if (snapshots.connectionState == ConnectionState.waiting) {
                      return krmLoader();
                    }
                    List<ChatContactModel> chatcontacts = snapshots.data!;
                    return ListView.builder(
                      shrinkWrap: true,
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
                                    members: '',
                                    groupPic: contactlist.profilePic,
                                    isGroup: widget.isGroup,
                                    members_name: '',
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
            ],
          ),
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
