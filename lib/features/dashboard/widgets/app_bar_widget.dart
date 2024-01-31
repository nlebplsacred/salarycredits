import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salarycredits/features/help_and_support/help_and_support_page.dart';

import '../../../models/login/login_response_model.dart';
import '../../../utility/global.dart';
import '../../../values/colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final LoginResponseModel user;

  const AppBarWidget(this.user, {super.key});

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hi ${user.firstName} ${user.lastName ?? ""}', textAlign: TextAlign.left),
                  const Text(
                    "Welcome to SalaryCredits",
                    style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, color: AppColor.grey, height: 1.3),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return const HelpSupportPage();
                    }));
                  },
                  icon: const Icon(Icons.support_agent_rounded, size: 26,),
                  color: AppColor.lightBlue,
                ),
              ),
            ],
          ),
        ],
      ),
      titleTextStyle: const TextStyle(
        color: AppColor.lightBlack,
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: AppColor.white,
      shadowColor: AppColor.bgDefault1,
      elevation: 1,
      toolbarHeight: 65.0,
      titleSpacing: 3,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColor.white, // <-- SEE HERE
        statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
        statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 12.0, bottom: 10.0, right: 0),
        child: Builder(
          builder: (BuildContext context) {
            return InkWell(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Stack(children: [
                CircleAvatar(
                  backgroundColor: AppColor.darkBlue,
                  child: ClipOval(
                    child: user.profilePicture == null
                        ? Text(Global.getNameInitials(user.firstName, user.lastName), style: const TextStyle(color: AppColor.white))
                        : Image.network(
                            '${user.profilePicture}',
                            fit: BoxFit.cover,
                            height: 38,
                            width: 38,
                          ),
                  ),
                ),
                Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ]),
            );
          },
        ),
      ),
    );
  }
}
