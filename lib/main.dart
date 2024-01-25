import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salarycredits/features/dashboard/dashboard_page.dart';
import 'package:salarycredits/services/api_auth.dart';
import 'package:salarycredits/features/welcome/welcome_page.dart';
import 'package:salarycredits/services/user_handler.dart';
import 'package:salarycredits/utility/custom_loader.dart';
import 'package:salarycredits/values/app_theme_style.dart';
import 'package:salarycredits/values/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'features/one_time_password/one_time_password.dart';
import 'models/login/login_response_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'SalaryCredits',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: UpgradeAlert(child: const SplashScreen()),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserHandler userHandler = UserHandler();
  LoginResponseModel loginModel = LoginResponseModel();
  final ApiToken apiToken = ApiToken();

  @override
  void initState() {
    super.initState();
    apiToken.getToken(); //generate token

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        if (prefs.getString('sessionUser').toString() != 'null') {
          loginModel = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));

          if (loginModel.userEmail != null) {
            //update fresh user information for session
            userHandler.updateUserSession(loginModel.applicantId!).then((value) => loginModel = value);

            //print("nitya${loginModel.mobile}");

            if (!loginModel.isMobileVerified! || loginModel.mobile == null) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return OneTimePasswordPage(user: loginModel);
              }));
            }
          }
        }
      });
    });
  }

  //check if user already logged in
  Future<String> loadDataFromSharedPreferences() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate a delay.
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionUser').toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Center(
        child: FutureBuilder(
          future: loadDataFromSharedPreferences(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == 'null') {
                return const WelcomePage();
              } else {
                LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(json.decode(snapshot.data.toString()));

                if (loginResponseModel.userEmail != null) {
                  return const DashboardPage();
                }
                return const WelcomePage();
              }
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}'); // Handle any errors that occur during data loading.
            } else {
              return const CustomLoader();
            }
          },
        ),
      ),
    );
  }
}
