import 'package:flutter/material.dart';
import 'package:geolocator/api/api_call.dart';
import 'package:geolocator/screen/not_found.dart';
import 'package:geolocator/screen/result_screen.dart';
import 'package:loading_indicator/loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late double _scale;
  late AnimationController _controller;
  final TextEditingController _ipinput = TextEditingController();

  //loading
  static const List<Color> _kDefaultRainbowColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

//dispose animation
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 47, 43, 43),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'GeoLocator',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      Image.asset(
                        'asset/logo.png',
                        width: 50,
                        height: 50,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height / 3 - 50,
                  child: Image.asset('asset/gif.gif'),
                ),
                const Text(
                  'Enter target IP:',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: TextField(
                    style: const TextStyle(color: Colors.yellow),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.yellowAccent, //this has no effect
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: "192.168.43.2",
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 103, 160, 130))),
                    keyboardType: TextInputType.number,
                    controller: _ipinput,
                  ),
                ),
                SizedBox(
                  height: height / 9,
                ),
                Center(
              child: GestureDetector(
                onTap: () async {
                  try {
                    loadingWidget();
                    var result = await fetchDetails(_ipinput.text, context);
                    if (_scaffoldKey.currentContext != null) {
                      Navigator.of(_scaffoldKey.currentContext!)
                          .push(MaterialPageRoute(builder: (context) {
                        return ResultScreen(
                          result: result,
                        );
                      }));
                    }
                  } catch (e) {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NotFoundScreen()));
                  }
                },
                onTapDown: _tapDown,
                onTapUp: _tapUp,
                child: Transform.scale(
                  scale: _scale,
                  child: _animatedButton(),
                ),
              ),
            ),
            SizedBox(height: 30,),
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.info),
                label: const Text('How to get others IP'),
                onPressed: () {
                  getipinfo();
                },
              ),
            )
              ],
            ),
      )),
    );
  }

  //animate button
  Widget _animatedButton() {
    return Container(
      height: 70,
      width: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0x80000000),
              blurRadius: 12.0,
              offset: Offset(0.0, 5.0),
            ),
          ],
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff33ccff),
              Color(0xffff99cc),
            ],
          )),
      child: const Center(
        child: Text(
          'Check',
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 13, 35, 231)),
        ),
      ),
    );
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }

  //get the ip (bottomsheet)
  Future getipinfo() {
    return showModalBottomSheet(
        backgroundColor: const Color.fromARGB(255, 38, 72, 113),
        elevation: 1,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width -
              40, // here increase or decrease in width
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (context) {
          return Container(
            margin: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  Text(
                    'How to get anyone\'s IP',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 134, 59),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '''
1. Go to https://grabify.link/
2. Copy any YouTube video link or any other link
3. Paste it in the field
4. Click the 'Create URL' button
5. Share it with anyone

If anyone opens the link, you will be able to see their IP address on that website.

6. Copy the IP address and paste it into this app.
7. Click the 'Check' button

Congratulations, you've got it.
                    ''',
                    style: TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )
                ],
              ),
            ),
          );
        });
  }

  loadingWidget() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 2 - 200),
            child: const SizedBox(
              height: 200,
              width: 200,
              child: LoadingIndicator(
                indicatorType: Indicator.orbit,
                colors: _kDefaultRainbowColors,
                strokeWidth: 4.0,
              ),
            ),
          ),
        );
      },
    );
  }
}
