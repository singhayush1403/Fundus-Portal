// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fundus_sn_web/DiscPos.dart';
import 'package:fundus_sn_web/DiscTes.dart';
import 'package:fundus_sn_web/GoogleSignIn.dart';
import 'package:fundus_sn_web/MacTes.dart';
import 'package:fundus_sn_web/PerRet.dart';
import 'package:fundus_sn_web/PosteriorSTP.dart';
import 'package:fundus_sn_web/Repository.dart/FirestoreRepo.dart';
import 'package:fundus_sn_web/Repository.dart/LocalNotifier.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:provider/provider.dart';
import 'package:quantity_input/quantity_input.dart';

import 'MetaPm.dart';

void main() async {
  await Firebase.initializeApp();
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider<LocalNotifier>(create: (context) {
        return LocalNotifier();
      }, builder: (context, child) {
        return MyHomePage(title: "hello");
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 0;
  Matrix4 matrix4 = Matrix4.identity();
  bool signedIn = false;
  List<String> titles = [
    "Meta-PM",
    "Posterior-staphyloma",
    "Macular tesselation",
    "Disc Tessellation",
    "Disc positional & morphological changes",
    "Peripheral retina changes"
  ];
  List<Widget> pages = [
    MetaPMSelectionWidget(),
    PosteriorSTPSelectionWidget(),
    MacularTesselation(),
    DiscTessellation(),
    DiscPositional(),
    PeripheralRetina(),
  ];
  int selectedIndex = 0;
  String selected = "Meta-PM";
  TapDownDetails? details;
  late TransformationController controller;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    controller = TransformationController();
    initialiseStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!signedIn) {
      return GoogleSignInPage(() {
        setState(() {
          signedIn = true;
        });
      });
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    // return GoogleSignInPage();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.black,
        //
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Fundus Image Classification"),
        actions: [
          Center(
            child: Consumer<LocalNotifier>(
              builder: (context, value, child) {
                return Text(
                    '${value.totalImages - value.imageQueue.length - 1}/${value.totalImages} images labelled',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
              },
            ),
          ),
          Container(width: 10),
          signedIn
              ? IconButton(
                  icon: Icon(Icons.logout, color: Colors.white),
                  onPressed: () async {
                    GoogleSignIn _googleSignIn = GoogleSignIn();
                    await _googleSignIn.signOut();
                    await FirebaseAuth.instance.signOut();

                    setState(() {
                      signedIn = false;
                    });
                    //  FirestoreRepository.writeAllImages();
                  },
                )
              : Container()
        ],
      ),
      body: Consumer<LocalNotifier>(
        builder: (context, value, child) {
          return Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.blue.shade200,
                      ),
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                            // color: Colors.white,
                            color: Color.fromARGB(255, 188, 231, 189),
                            borderRadius: BorderRadius.circular(4)),
                        child: DropdownButton<String>(
                            focusColor: Color.fromARGB(255, 188, 231, 189),
                            dropdownColor: Color.fromARGB(255, 188, 231, 189),
                            value: selected,
                            items: titles
                                .map((e) => DropdownMenuItem<String>(
                                      child: Text(
                                        e,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      value: e,
                                    ))
                                .toList(),
                            onChanged: (e) {
                              setState(() {
                                selected = e!;
                                selectedIndex = titles.indexOf(e);
                              });
                            }),
                      ),
                    ),
                    Container(
                      width: 50,
                    ),
                    RaisedButton(
                        padding: EdgeInsets.all(10),
                        color: Color.fromARGB(255, 188, 231, 189),
                        onPressed: () async {
                          String feedback = value.verifyInputsAndSendFeedback();
                          if (feedback != "") {
                            FToast fToast = FToast();
                            fToast.init(context);
                            fToast.showToast(
                                toastDuration: Duration(seconds: 3),
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(feedback,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                    )),
                                gravity: ToastGravity.TOP);
                          } else {
                            await value.setImageData();
                            setState(() {
                              selectedIndex = 0;
                              selected = titles[0];
                            });
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.all(15),
                          child: Text(
                            "Save changes and label next image",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    // RaisedButton(
                    //   onPressed: () {
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //       builder: (context) {
                    //         return MetaPMSelectionWidget();
                    //       },
                    //     ));
                    //   },
                    //   child: Text("View Labelled Images"),
                    // )
                  ],
                ),
                choiceSelectionWidget(value),
                Spacer(),
              ],
            ),
          );
        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  int scale = 5;
  choiceSelectionWidget(LocalNotifier notifier) {
    Widget choiceSelectionWidget = Container();
    choiceSelectionWidget = pages[selectedIndex];
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          choiceSelectionWidget,
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  final position = details!.localPosition;

                  final x = -position.dx;
                  final y = -position.dy;
                  final zoomed = Matrix4.identity()
                    ..scale(scale)
                    ..translate(x, y);
                  final value = zoomed;

                  controller.value = value;
                },
                onTapDown: (tddetails) {
                  setState(() {
                    details = tddetails;
                  });
                },
                onDoubleTap: () {
                  final value = Matrix4.identity();
                  controller.value = value;
                },
                child: notifier.selectedModel != null
                    ? Stack(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 126, 218, 218)),
                              height: MediaQuery.of(context).size.height * 0.8,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: InteractiveViewer(
                                  transformationController: controller,
                                  // panEnabled: false,
                                  scaleEnabled: false,
                                  alignPanAxis: true,
                                  clipBehavior: Clip.hardEdge,
                                  maxScale: 10,
                                  child: notifier.selectedModel != null
                                      ? Image.network(
                                          notifier.selectedModel!.imageURL!,
                                          fit: BoxFit.contain,
                                        )
                                      : Container())),
                          QuantityInput(
                              value: scale,
                              acceptsZero: false,
                              acceptsNegatives: false,
                              label: "Zoom Scale",
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.black),
                                  counterStyle:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              onChanged: (value) {
                                setState(() {
                                  if (int.parse(value) >= 1) {
                                    scale = int.parse(value);
                                  }
                                });
                              }),
                        ],
                      )
                    : Center(
                        child: Container(
                            margin: EdgeInsets.only(right: 200),
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator()),
                      ),
              ),
              // selectedIndex == 2 || selectedIndex == 3
              //     ? Center(
              //         child: SizedBox(
              //           height: MediaQuery.of(context).size.height * 0.8,
              //           width: 600,
              //           child: StatefulDragArea(
              //             //   transform: matrix4,
              //             child: Image.network(
              //                 "https://pub.dev/static/img/pub-dev-logo-2x.png?hash=umitaheu8hl7gd3mineshk2koqfngugi"),
              //           ),
              //         ),
              //       )
              //     : Container()
            ],
          )
        ],
      ),
    );
  }

  void initialiseStream() {
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        signedIn = true;
      });
    }
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        setState(() {
          signedIn = true;
        });
      } else {
        setState(() {
          signedIn = false;
        });
      }
    });
  }
}

class StatefulDragArea extends StatefulWidget {
  final Widget? child;

  const StatefulDragArea({Key? key, this.child}) : super(key: key);

  @override
  _DragAreaStateStateful createState() => _DragAreaStateStateful();
}

class _DragAreaStateStateful extends State<StatefulDragArea> {
  Offset position = Offset(300, 500);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          child: GestureDetector(
            child: widget.child,
            onPanUpdate: (details) {
              setState(() {
                position = position + details.delta;
              });
            },
          ),
        )
      ],
    );
  }
}

class HoverImage extends StatefulWidget {
  final String? image;

  HoverImage({this.image});

  @override
  _HoverImageState createState() => _HoverImageState();
}

class _HoverImageState extends State<HoverImage>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation? _animation;
  Animation? padding;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 275),
      vsync: this,
    );
    _animation = Tween(begin: 1.0, end: 5).animate(CurvedAnimation(
        parent: _controller!, curve: Curves.ease, reverseCurve: Curves.easeIn));
    padding = Tween(begin: 0.0, end: -25.0).animate(CurvedAnimation(
        parent: _controller!, curve: Curves.ease, reverseCurve: Curves.easeIn));
    _controller!.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value) {
        setState(() {
          _controller!.forward();
        });
      },
      onExit: (value) {
        setState(() {
          _controller!.reverse();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0.0, 20.0),
              spreadRadius: -10.0,
              blurRadius: 20.0,
            )
          ],
        ),
        child: Container(
          height: 220.0,
          width: 170.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          clipBehavior: Clip.hardEdge,
          transform: Matrix4(_animation!.value, 0, 0, 0, 0, _animation!.value,
              0, 0, 0, 0, 1, 0, padding!.value, padding!.value, 0, 1),
          child: Image.network(
            widget.image!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
