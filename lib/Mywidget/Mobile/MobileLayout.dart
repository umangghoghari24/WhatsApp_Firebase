import 'package:firebaseconnection/Model/VideoCall.dart';
import 'package:firebaseconnection/features/Contact/views/SelectContactScreen.dart';
import 'package:firebaseconnection/features/Status/StatusView/status.dart';
import 'package:firebaseconnection/features/VideoCall/Views/CallPikupScreen.dart';
import 'package:firebaseconnection/features/VideoCall/Views/CallScreen.dart';
import 'package:firebaseconnection/features/auth/controller/AuthController.dart';
import 'package:firebaseconnection/features/auth/views/EnterNumber.dart';
import 'package:firebaseconnection/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chats.dart';
import 'status.dart';
import 'calls.dart';

class MobileLayout extends ConsumerStatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends ConsumerState<MobileLayout>
    with SingleTickerProviderStateMixin,
     WidgetsBindingObserver
{
  late TabController _tabController;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch(state){
      case AppLifecycleState.resumed:
           print("app Started");
           ref.read(authControllerProvider).changeUserstate(true);
           break;
        default:
          print("App close");
          ref.read(authControllerProvider).changeUserstate(false);
          break;
    }
  }
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
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _tabController = TabController(
  length: 3,
      vsync: this,
      initialIndex: 0,
    )
    ..addListener(() {
      setState(() {});
    });
  }

  var pages = <Widget> [
    Chats(device: 'mobile',isGroup: false,reciveruid: '',),
    status(uid: '',isGroup: '',),
    VCalls()
  ];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CallPikupScreen(
      scaffold: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Whatsapp',style: TextStyle(color: Colors.white),),
          actions: [
            Row(
              children: <Widget> [
                IconButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Cameraapp(uid: '',)));
                },
                  icon: Icon(Icons.camera_alt_outlined),
                  color: Colors.white,),
                SizedBox(width: 10,),
                IconButton(onPressed: (){
                  // print('Enter friend name');
                  // setState(() {
                  //   showsliverAppBar = !showsliverAppBar;
                  // });
                },
                  icon: Icon(Icons.search),
                  color: Colors.white,),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _iconbool = !_iconbool;
                      });
                    },
                    icon: Icon(_iconbool ? _iconDark : _iconLight),
                    color: Colors.white,
                ),
                PopupMenuButton(
                    icon: Icon(Icons.more_vert),iconColor: Colors.white,
                    color: Colors.white,
                    itemBuilder: (context) {
                      var mypop = DefaultTabController.of(context)!.index;
                      if (mypop == 1) {
                        return [
                            PopupMenuItem(child: Text("New group")),
                            PopupMenuItem(child: Text("New Broadcast")),
                            PopupMenuItem(child: Text("Linked devices")),
                            PopupMenuItem(child: Text("Starred messages")),
                            PopupMenuItem(child: Text("Payments")),
                            PopupMenuItem(child: Text("Settings")),
                        ];
                      }
                      else if (mypop == 2) {
                        return [
                          PopupMenuItem(child: Text("Status privacy")),
                          PopupMenuItem(child: Text("Settings")),
                        ];
                      }
                      else if (mypop == 3) {
                        return [
                          PopupMenuItem(child: Text("Clear call log")),
                          PopupMenuItem(child: Text("Settings")),
                        ];
                      }
                      return [];
                    }
                ),
              ],
            ),
          ],
          bottom: TabBar(indicatorColor: Colors.white,
            controller: _tabController,
            isScrollable: false,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            tabs: [
              // Icon(Icons.people),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Chats'),
                  DecoratedBox(
                      decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text('5',style: TextStyle(color: Colors.green),),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tab(text:"Status"),
                  Icon(Icons.radio_button_unchecked),
                ],
              ),
              Text('calls')
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
            children: pages,
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.chat),
        //   onPressed: (){
        //     Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectContactsScreen(device: 'mobile')));
        //     },
        // ),
      ),
    );
  }
}

