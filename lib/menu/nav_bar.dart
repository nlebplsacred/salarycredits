import 'package:flutter/material.dart';
import 'package:salarycredits/features/about_us/about_us_page.dart';
import 'package:salarycredits/features/emi_calculator/emi_calculator_page.dart';
import 'package:salarycredits/features/log_out/log_out_page.dart';
import 'package:salarycredits/models/login/login_response_model.dart';
import 'package:salarycredits/values/colors.dart';

import '../features/active_salary_account/active_salary_account_page.dart';
import '../features/faqs/faqs_page.dart';
import '../features/help_and_support/help_and_support_page.dart';
import '../features/my_applications/my_applications_page.dart';
import '../features/my_profile/my_profile_page.dart';
import '../utility/global.dart';
// import 'package:share_plus/share_plus.dart';

class NavBar extends StatelessWidget {
  final LoginResponseModel user;

  const NavBar(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    //userModel.profilePicture = null;
    return Drawer(
      backgroundColor: AppColor.bgDefault1,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('${user.firstName} ${user.lastName ?? ""}', style: const TextStyle(color: AppColor.white),),
            accountEmail: Text('${user.userEmail}', style: const TextStyle(color: AppColor.white),),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppColor.white,
              child: CircleAvatar(
                backgroundColor: AppColor.darkBlue,
                radius: 34.5,
                child: ClipOval(
                  child: user.profilePicture == null
                      ? Text(Global.getNameInitials(user.firstName, user.lastName), style: const TextStyle(color: AppColor.white))
                      : Image.network(
                          '${user.profilePicture}',
                          height: 90.0,
                          width: 90.0,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xFF5C6BC0),
                  Color(0xFF1B278D),
                ],
                tileMode: TileMode.mirror,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("My Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const MyProfilePage();
              }));
              //Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt_rounded),
            title: const Text("Applications"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const MyApplicationsPage();
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_rounded),
            title: const Text("Active Salary Account"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const ActiveSalaryAccountPage();
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.calculate_rounded),
            title: const Text("EMI Calculator"),
            onTap: () {
              Navigator.pop(context);
              //send to calculator page
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const EMICalculatorPage();
              }));
            },
          ),
          const Divider(thickness: 1),
          ListTile(
            leading: const Icon(Icons.question_answer_rounded),
            title: const Text("FAQs"),
            onTap: () {
              Navigator.pop(context);
              //send to faqs page
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const FaqsPage();
              }));
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.settings_rounded),
          //   title: const Text("Settings"),
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.support_agent_rounded),
            title: const Text("Help & Support"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const HelpSupportPage();
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_rounded),
            title: const Text("About Us"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const AboutUsPage();
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.share_rounded),
            title: const Text("Share App"),
            onTap: () async  {
              Navigator.pop(context);

              // //write code to share this app
              // if (Platform.isAndroid) {
              //
              //   Share.share('https://play.google.com/store/apps/details?id=com.northernlights.salarycredits', subject: "SalaryCredits - Employee Wellness Tool");
              //
              // } else if (Platform.isIOS)  {
              //
              //   final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
              //   final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
              //
              //   // The 'identifierForVendor' is a unique identifier for the app on the device.
              //   // You can use it to construct the App Store URL.
              //   final String? appId = iosInfo.identifierForVendor;
              //
              //   // Construct the App Store URL using the app's identifier.
              //   final String appStoreUrl = 'https://apps.apple.com/app/$appId';
              //
              //   Share.share(appStoreUrl, subject: "SalaryCredits - Employee Wellness Tool");
              // }
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.star_rate_rounded),
          //   title: const Text("Rate App"),
          //   onTap: () {
          //     print('my profile');
          //     Navigator.pop(context);
          //   },
          // ),
          const Divider(thickness: 1),
          ListTile(
            leading: const Icon(Icons.exit_to_app_rounded),
            title: const Text("Sign Out"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const LogOutPage();
              }));
            },
          ),
        ],
      ),
    );
  }
}
