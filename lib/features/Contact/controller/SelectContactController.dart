import 'package:flutter/material.dart';
import 'package:firebaseconnection/Model/modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebaseconnection/features/Contact/class/selectContactClass.dart';
import 'package:flutter_contacts/flutter_contacts.dart';


import '../class/selectContactClass.dart';

final selectContactsControllerfutureprovider = FutureProvider(
      (ref) {
    final selectContactsClass = ref.watch(selectContactsClassProvider);
    return selectContactsClass.getContacts();
  },
);

final selectContactsControllerprovider = Provider((ref) {
  final selectContactsClass = ref.watch(selectContactsClassProvider);
  return SelectContactsController(
    ref: ref,
    selectContactsClass: selectContactsClass,
  );
});

class SelectContactsController {
  final ProviderRef ref;
  final SelectContactsClass selectContactsClass;

  SelectContactsController({
    required this.ref,
    required this.selectContactsClass,
  });


  void selectContact(Contact selectedcontact, BuildContext context, String displayName) {
    selectContactsClass.selectContact(selectedcontact,context, displayName);
    }
}