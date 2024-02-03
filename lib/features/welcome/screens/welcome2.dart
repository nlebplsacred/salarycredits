import 'package:flutter/material.dart';
import 'package:salarycredits/values/colors.dart';
import 'package:salarycredits/values/strings.dart';
import 'package:salarycredits/values/styles.dart';

class Welcome2 extends StatelessWidget {
  const Welcome2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 100.0, left: 30, right: 30),
      color: AppColor.bgScreen3,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: Text(AppText.slideTitle2, style: AppStyle.splashHeading)),
              ],
            ),
            const SizedBox(height: 50.0),
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: ClipRRect(
                    child: Image.asset("assets/transaction_list.png",
                        color: AppColor.yellowLight, width: 48.0, height: 48.0)),
              ),
              Expanded(child: Text(AppText.slide3Item1, style: AppStyle.splashDesc))
            ]),
            const SizedBox(height: 40.0),
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: ClipRRect(
                    child: Image.asset("assets/calc_grey_100.png",
                        color: AppColor.yellowLight, width: 48.0, height: 48.0)),
              ),
              Expanded(child: Text(AppText.slide3Item2, style: AppStyle.splashDesc))
            ]),
            const SizedBox(height: 40.0),
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: ClipRRect(
                    child: Image.asset("assets/offer_grey_100.png",
                        color: AppColor.yellowLight, width: 48.0, height: 48.0)),
              ),
              Expanded(child: Text(AppText.slide3Item3, style: AppStyle.splashDesc))
            ]),
          ],
        ),
      ),
    );
  }
}
