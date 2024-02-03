import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salarycredits/values/styles.dart';

import '../../values/colors.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 1.0,
        toolbarHeight: 60.0,
        titleSpacing: 2.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColor.white, // <-- SEE HERE
          statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
        title: const Text(
          "About SalaryCredits",
          style: TextStyle(
            color: AppColor.lightBlack,
            fontSize: 15.0,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColor.lightBlack),
        backgroundColor: AppColor.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              const Text("We're all about the spirit of 'helping each other out'", style: AppStyle.pageTitle),
              Image.network("https://www.salarycredits.com/content/images/work-smarter.png"),
              const SizedBox(height: 16.0),
              const Text("We support and help your employees feel secure when it comes to their finances", style: AppStyle.pageTitle),
              const SizedBox(height: 16.0),
              const Text(
                  "SalaryCredits didn't appear out of thin air. If we seem madly passionate about creating employee financial well-being at work, it's because we’ve been on the other side, too.",
                  style: AppStyle.smallGrey1),
              const SizedBox(height: 16.0),
              const Text(
                  "The average person spends a third of their life at work. That's a lot of time, right? We believe this should be spent in an environment that's supportive and inspiring. Apart from providing personal loans, we help your employees get a better understanding of their money and provide many tips to change the way they think about and deal with money.",
                  style: AppStyle.smallGrey1),
            ],
          ),
        ),
      ),
    );
  }
}
