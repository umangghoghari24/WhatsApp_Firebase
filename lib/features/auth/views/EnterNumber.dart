import 'package:country_picker/country_picker.dart';
import 'package:firebaseconnection/commen/utils.dart';
import 'package:firebaseconnection/features/auth/class/AuthClass.dart';
import 'package:firebaseconnection/features/auth/views/OTPScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Enternumber extends ConsumerStatefulWidget {
  const Enternumber({Key? key}) : super(key: key);
  @override
  ConsumerState<Enternumber> createState() => _EnternumberState();
}

class _EnternumberState extends ConsumerState<Enternumber> {
  TextEditingController countrys = TextEditingController();
  TextEditingController number = TextEditingController();
  final mykey = GlobalKey();
  String countryCode = '';
  String countryname = '';

  void sendOTP(BuildContext context) {
    if (number.text.length == 10 && countryCode!='') {
      String mynember="+"+countryCode.toString()+number.text.toString();
    //String mynember='+917046151045';
      ref.read(authClassProvider).signInWithPhone(context, mynember);
    } else {
      showSnackBar(
        context: context,
        message: "All Fields Are Requird",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var totalsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 7,
                ),
                Text(
                  'Enter your phone number',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                ),
                // Icon(Icons.more_vert,),
              ],
            ),
            Text('WhatsApp will need to verify your account. Whats my'),
            SizedBox(
              height: MediaQuery.of(context).size.height / 150,
            ),
            Text('number?'),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: Container(
                child: Column(
                  children: [
                    Form(
                      key: mykey,
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: countryname.toString(),
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  showCountryPicker(
                                      context: context,
                                      showPhoneCode: true,
                                      countryListTheme: CountryListThemeData(
                                          textStyle: TextStyle(
                                            fontSize: 18,
                                          ),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10)),
                                          inputDecoration: InputDecoration(
                                              prefixIcon: IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons
                                                      .arrow_back_rounded)),
                                              suffixIcon:
                                                  Icon(Icons.search_rounded),
                                              labelText: 'Choose a country',
                                              labelStyle: TextStyle(
                                                fontSize: 25,
                                                color: Colors.green,
                                              ))),
                                      onSelect: (country) {
                                        setState(() {
                                          // country.phoneCode.toString();
                                          countryCode =
                                              country.phoneCode.toString();
                                          countryname = country.name.toString();
                                        });
                                      });
                                },
                                icon: Icon(Icons.arrow_circle_down_outlined))),
                        controller: countrys,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: totalsize / 4,
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: countryCode.toString(),
                                  prefixIcon: Icon(
                                    Icons.add,
                                    size: 15,
                                  )),
                              keyboardType: TextInputType.number,
                              //   ),
                              //
                            )),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextField(
                            controller: number,
                            keyboardType: TextInputType.number,
                          ),
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 50,
            ),
            Text('Carrier charges may apply'),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
            ),
            ElevatedButton(onPressed: () {
              sendOTP(context);
            //  Navigator.push(context, MaterialPageRoute(builder: (context)=>OTPScreen()));
            }, child: const Text('Next'))
          ],
        ),
      ),
    );
  }
}
