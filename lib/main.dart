import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseconnection/Mywidget/Mobile/MobileLayout.dart';
import 'package:firebaseconnection/Mywidget/Web/WebLayout.dart';
import 'package:firebaseconnection/commen/utils.dart';
import 'package:firebaseconnection/features/auth/controller/AuthController.dart';
import 'package:firebaseconnection/features/auth/views/CreateProfile.dart';
import 'package:firebaseconnection/firebase_options.dart';
import 'package:firebaseconnection/loginpage.dart';
import 'package:firebaseconnection/myLayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'Enum/Enum1.dart';
import 'commen/cameraview.dart';

late List<CameraDescription> _cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {

  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}
class _MyAppState extends ConsumerState<MyApp> {


  bool _iconbool = false;

  // Theme icon

  IconData _iconLight = Icons.wb_sunny;
  IconData _iconDark = Icons.nights_stay;

  // Light and Dark theme color

  ThemeData _LightTheme =
  ThemeData(primarySwatch: Colors.amber, brightness: Brightness.light);

  ThemeData _DarkTheme = ThemeData(
    primarySwatch: Colors.red,
    brightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // title: 'Flutter Demo',
        theme: _iconbool ? _DarkTheme : _LightTheme,
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //   useMaterial3: true,
        // ),
        debugShowCheckedModeBanner: false,
        home: ref.watch(userLogindataProvider).when(data: (data) {
          if (data != null) {
            return myLayout();
          } else {
            return loginpage();
          }
        },
            error: (e, stack) {
          showSnackBar(
            context: context,
            message: e.toString(),
          );
        }, loading: () {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }));
  }
}

//  CameraApp

class Cameraapp extends StatefulWidget {
  final uid;
   Cameraapp({required this.uid,Key? key}) : super(key: key);

  @override
  State<Cameraapp> createState() => _CameraappState();
}

class _CameraappState extends State<Cameraapp> {
  late CameraController controller;

  var camera_index=0;
  var showreal= true;
  var showflash= false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = CameraController(_cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
  var currnetcamerastatus = 1;
  var isshow= false;

  void initstate(){
    super.initState();

    setState(() {
      currnetcamerastatus = 1;
    });
  }
  var currnetcamera = 2;

  void initstate2(){
    super.initState();
    setState(() {
      currnetcamerastatus = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return const Scaffold();
    if (!controller.value.isInitialized) {
      return Scaffold(
      );
    }

    return MaterialApp(
      home:
      Stack(
        children: [
          CameraPreview(controller),
          Positioned(
              top: 50,
              left: 10,
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 25,
              )),
          Positioned(
              top: 48,
              right: 10,
              child: Container(
                child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                  onPressed: () {
                    if (showflash==true){
                      setState(() {
                        showflash=!showflash;
                        controller.setFlashMode(FlashMode.off);
                      });
                    }else{
                      setState(() {
                        showflash=!showflash;
                        controller.setFlashMode(FlashMode.torch);
                      });
                    }
                  },
                  child: Icon(
                    showflash?Icons.flash_on:Icons.flash_off,
                    color: Colors.white,
                  ),
                ),
              )
          ),
          Positioned(
              top: 44, left: 153,
              child: Text('00:00', style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.normal),)),
          Positioned(
              bottom: 95,
              left: 10,
              child: CircleAvatar(
                backgroundColor: Colors.black26,
                child: Icon(
                  Icons.image,
                  color: Colors.white,
                ),
              )),
          Positioned(
              bottom: 75,
              left: 141,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                  onPressed: () async{
                    final path=  await join( (await getTemporaryDirectory()).path,'${DateTime.now()}.png');
                    XFile picture = await controller.takePicture();
                    picture.saveTo(path);
                    print(path);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>cameraview(path: path,uid: widget.uid,   messageEnum: MessageEnum.image,
                      text: '',
                      type: 'text',
                      isStatus: true,)));
                  },
                  child: Icon( Icons.radio_button_on_outlined,
                      color: Colors.white,
                      size: 70
                  ))
          ),
          Positioned(
            bottom: 95,
            right: 10,
            child: Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                onPressed: () {
                  if (showreal==true){
                    setState(() {
                      camera_index=0;
                      showreal=!showreal;
                    });
                  }else{
                    setState(() {
                      camera_index=1;
                      showreal=!showreal;
                    });
                  }
                  controller=CameraController(_cameras[camera_index], ResolutionPreset.max);
                  controller.initialize().then((_) {
                    if (!mounted) {
                      return;
                    }
                    setState(() {
                    });
                  }).catchError((Object e) {
                    if (e is CameraException) {}
                  });
                },
                child: Icon(
                  Icons.flip_camera_android,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 250,
              left: 175,
              child: Icon(
                Icons.minimize,
                color: Colors.black,
              )),
          Positioned(bottom: 150,
            child: Container(
              height: 100, width: 1000,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 20,
                itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(height: 0, width: 50,
                      color: Colors.white,),
                  );
                },
              ),
            ),),
          Positioned(
            bottom: 0,
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: 7,),
                  Row(
                    children: [
                      SizedBox(
                        width: 110,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: currnetcamerastatus==1?Colors.grey.shade800:Colors.transparent,shape: StadiumBorder()),
                        // child: Text('Video'),
                        onPressed: () {
                          setState(() {
                            currnetcamerastatus=1;
                          });
                        },
                        child: Text('photo'),
                      ),
                      SizedBox(width: 3,),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: currnetcamerastatus==2?Colors.grey.shade800:Colors.transparent,shape: StadiumBorder()),
                        //   child: Text('Photo'),
                        onPressed: () {
                          setState(() {
                            currnetcamerastatus = 2;
                          });
                        },
                        child: Text('video'),
                      )
                    ],
                  ),
                ],
              ),
              height: 70,width: 1000,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

