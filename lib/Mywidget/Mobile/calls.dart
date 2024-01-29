import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseconnection/features/VideoCall/Controller/VideoCallController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../Model/VideoCall.dart';

class VCalls extends ConsumerStatefulWidget {
  const VCalls({Key? key}) : super(key: key);

  @override
  ConsumerState<VCalls> createState() => _videocallState();
}

class _videocallState extends ConsumerState<VCalls> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 40,
                  child: Icon(Icons.link),
                ),
                title: Text('creat call link'),
                subtitle: Text('share a link for your watsApp call'),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Text('recent')),
              FutureBuilder<List<VideoCall>>(
                future:
                    ref.watch(videocallClasscontrollerProvider).call(context),
                builder: (context, snapshots) {
                  if (snapshots.hasData && snapshots.data != null) {
                    return ListView.builder(
                        itemCount: snapshots.data!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, Index) {
                          VideoCall videoCall = snapshots.data![Index];
                          var timeSent =
                              DateFormat.Hm().format(videoCall.timeSent);

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(videoCall.receiverPic),
                              radius: 40,
                            ),
                            title: Text(videoCall.receiverName),
                            subtitle: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.green,
                                  ),
                                  Text(timeSent),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.1,
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.call,
                                            color: Colors.green,
                                          )))
                                ],
                              ),
                            ),
                          );
                        });
                  }
                  return Container();
                },
              ),
            ]))

        // body: FutureBuilder<DocumentSnapshot>(
        //   future: ref.watch(videocallClasscontrollerProvider).call,
        //   builder: (context, snapshots) {
        //     if (snapshots.hasData && snapshots.data?.data() != null) {
        //       VideoCall videoCall = VideoCall.fromMap(
        //           snapshots.data!.data() as Map<String, dynamic>
        //       );
        //
        //       print("Videocall =${videoCall}");
        //
        //       if (videoCall!=null) {
        //         return ListView.builder(
        //             itemCount: 1,
        //             shrinkWrap: true,
        //             itemBuilder: (context, Index) {
        //               return ListTile(
        //                 title: Text(videoCall.receiverName),
        //               );
        //             });
        //       }
        //     }
        //     return Container();
        //   },
        // ),
        );
  }
}
