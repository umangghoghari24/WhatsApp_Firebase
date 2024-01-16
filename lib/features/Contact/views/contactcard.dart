import 'package:firebaseconnection/Model/GroupContact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';

class contactcard extends StatelessWidget {
  const contactcard({required this.contactmodal,this.isselected=false,super.key});
  final GroupContactModel contactmodal;
  final  bool isselected;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green,
              radius: 30,
              backgroundImage: NetworkImage(contactmodal.profilePic.toString()),
            ),
            Positioned(
                right: 1,
                bottom: 1,
                child: isselected ? CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.lightGreen,
                    child: Icon(Icons.check,size: 10,color: Colors.white,)
                )
                    : Container()
            )
            // :Container(width: 10,)
          ],
        ),
        title: Text(contactmodal.name ?? ''),
        subtitle: Text('few minutes ago'),
        );
    }
}