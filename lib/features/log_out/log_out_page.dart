import 'package:flutter/material.dart';
import 'package:salarycredits/features/login_type/login_type_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utility/custom_loader.dart';

class LogOutPage extends StatefulWidget {
  const LogOutPage({super.key});

  @override
  State<LogOutPage> createState() => _LogOutPageState();
}

class _LogOutPageState extends State<LogOutPage> {
  @override
  void initState() {
    super.initState();
    signOut();
  }

  signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); //

    if (context.mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const LoginTypePage();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const CustomLoader();
  }
}
