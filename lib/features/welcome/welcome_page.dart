import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salarycredits/features/login_type/login_type_page.dart';
import 'package:salarycredits/features/welcome/screens/welcome1.dart';
import 'package:salarycredits/features/welcome/screens/welcome2.dart';
import 'package:salarycredits/features/welcome/screens/welcome3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //controller to keep track of which page we are on
  final PageController _controller = PageController();

  //keep track we are on last page or not
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = (index == 2);
              });
            },
            children: const [
              Welcome1(),
              Welcome2(),
              Welcome3(),
            ],
          ),
          //dot indicator
          Container(
            alignment: const Alignment(0, 0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //skip
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                          return const LoginTypePage();
                        }));
                  },
                  child: const Text("skip",
                      style: TextStyle(color: Colors.white, fontSize: 17.0)),
                ),

                SmoothPageIndicator(controller: _controller, count: 3),

                //next or done
                isLastPage
                    ? GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                          return const LoginTypePage();
                        }));
                  },
                  child: const Text("got it",
                      style:
                      TextStyle(color: Colors.white, fontSize: 17.0)),
                )
                    : GestureDetector(
                  onTap: () {
                    _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                  child: const Text("next",
                      style:
                      TextStyle(color: Colors.white, fontSize: 17.0)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

