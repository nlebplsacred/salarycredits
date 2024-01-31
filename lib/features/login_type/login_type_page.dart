import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salarycredits/features/login_with_email/login_with_email_page.dart';
import 'package:salarycredits/features/login_with_mobile/login_with_mobile_page.dart';
import 'package:salarycredits/values/colors.dart';
import 'package:salarycredits/values/strings.dart';
import 'package:salarycredits/values/styles.dart';

class LoginTypePage extends StatefulWidget {
  const LoginTypePage({super.key});

  @override
  State<LoginTypePage> createState() => _LoginTypePageState();
}

class _LoginTypePageState extends State<LoginTypePage> {
  late PageController pageController;
  int pageNo = 0;
  late final Timer carasoulTimer;

  Timer getTimer() {
    return Timer.periodic(const Duration(seconds: 3), (timer) {
      if (pageNo == 6) {
        pageNo = 0;
      }

      pageController.animateToPage(
        pageNo,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOutCirc,
      );
      pageNo++;
    });
  }

  @override
  void initState() {
    pageController = PageController(initialPage: 0, viewportFraction: 0.85);
    carasoulTimer = getTimer();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    child: Image.asset("assets/logo_favicon.png",
                        width: 72, height: 72),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 275,
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (index) {
                    pageNo = index;
                    setState(() {});
                  },
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: pageController,
                      builder: (context, child) {
                        return child!;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.white,
                        ),
                        margin: const EdgeInsets.only(
                            left: 8, right: 8, top: 30, bottom: 12),
                        //add content
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20.0, bottom: 10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    maxRadius: 30.0,
                                    backgroundColor: AppColor.white,
                                    child: Image.network(AppText.productIcon[index],
                                        width: 50, height: 50, color: AppColor.lightBlue),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(AppText.productName[index],
                                      style: AppStyle.splashHeading2),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(AppText.productDesc[index],
                                        style: AppStyle.splashDesc2,
                                        textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: 5,
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => SizedBox(
                    width: 20.0,
                    child: Icon(
                      Icons.circle,
                      size: 12.0,
                      color: pageNo == index ? AppColor.skyBlue : AppColor.lightGrey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 90.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    color: AppColor.lightBlue,
                    elevation: 3,
                    child: InkWell(
                      onTap: () {
                        //click event
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return const LoginWithEmailPage();
                        }));
                      },
                      child: const SizedBox(
                        height: 60.0,
                        width: 310.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Icon(
                                Icons.email,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            Text(
                              "Continue with Email",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    color: AppColor.darkBlue,
                    elevation: 3,
                    child: InkWell(
                      onTap: () {
                        //click event
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return const LoginWithMobilePage();
                        }));
                      },
                      child: const SizedBox(
                        height: 60.0,
                        width: 310.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Icon(
                                Icons.mobile_friendly_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            Text(
                              "Continue with Mobile",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
