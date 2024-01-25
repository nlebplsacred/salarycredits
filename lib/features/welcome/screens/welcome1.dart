import 'package:flutter/material.dart';
import 'package:salarycredits/values/colors.dart';
import 'package:salarycredits/values/strings.dart';
import 'package:salarycredits/values/styles.dart';

class Welcome1 extends StatelessWidget {
  const Welcome1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 100.0, left: 30, right: 30),
      color: AppColor.bgScreen1,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text(AppText.slideTitle1, style: AppStyle.splashHeading)),
              ],
            ),
            const SizedBox(height: 50.0),
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: ClipRRect(
                    child: Image.asset("assets/loan_yellow_100.png",
                        color: AppColor.yellowLight, width: 48.0, height: 48.0)),
              ),
              Expanded(child: Text(AppText.slide1Item1, style: AppStyle.splashDesc))
            ]),
            const SizedBox(height: 40.0),
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: ClipRRect(
                    child: Image.asset("assets/credit_card_yellow_100.png",
                        color: AppColor.yellowLight, width: 48.0, height: 48.0)),
              ),
              Expanded(child: Text(AppText.slide1Item2, style: AppStyle.splashDesc))
            ]),
            const SizedBox(height: 40.0),
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: ClipRRect(
                    child: Image.asset("assets/rent2_yellow_100.png",
                        color: AppColor.yellowLight, width: 48.0, height: 48.0)),
              ),
              Expanded(child: Text(AppText.slide1Item3, style: AppStyle.splashDesc))
            ]),
          ],
        ),
      ),
    );
  }
}
