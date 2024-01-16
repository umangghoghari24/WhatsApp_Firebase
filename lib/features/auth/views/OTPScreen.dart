import 'package:firebaseconnection/features/auth/class/AuthClass.dart';
import 'package:firebaseconnection/features/auth/controller/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sms_autofill/sms_autofill.dart';
class OTPScreen extends ConsumerStatefulWidget {

  final String verificationId;
  const OTPScreen({required this.verificationId, Key? key}) : super(key: key);

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {

  @override
  String userOTP ='';

  void initState() {
    listenOtp();
    super.initState();
  }
  void verifyOTP(BuildContext context, otpcode, ref) {
    ref.read(authControllerProvider).verifyOTP(context, widget.verificationId, otpcode);
  }

  void listenOtp() async {
    await SmsAutoFill().listenForCode();
    print("OTP Listen is called");
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Center(child: Text('We have sent an SMS with a code.',),),
            Padding(
              padding: const EdgeInsets.only(left: 60 ,right: 60 ),
              child: PinFieldAutoFill(
                currentCode: userOTP,
                codeLength: 6,
                onCodeChanged: (code) {
                  if(code!.length== 6) {
                    verifyOTP(context, code.toString(), ref);
                  }
                },
                onCodeSubmitted: (val) {
                  // print("OnCodeSubmitted : $val");
                  verifyOTP(context,val,ref);
                },

                // onChanged: (value){
                //   if(value.toString().length==6) {
                //     verifyOTP(context,value.toString());
                //   }
                // },
                // textAlign: TextAlign.center,
                // keyboardType: TextInputType.number,
                // maxLength: 6,
                // decoration: InputDecoration(
                //   hintText: '-   -   -   -   -   -',  hintStyle: TextStyle(
                //   fontSize: 20,
                //   fontWeight: FontWeight.bold,
                // )
                // ),
              ),
            )
          ],
        ),

      ),
    );
  }
}



