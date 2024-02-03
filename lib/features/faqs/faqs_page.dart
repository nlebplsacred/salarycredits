import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/loan/faqs_model.dart';
import '../../models/login/login_response_model.dart';
import '../../services/loan_handler.dart';
import '../../utility/custom_loader.dart';
import '../../values/colors.dart';
import '../../values/styles.dart';

class FaqsPage extends StatefulWidget {
  const FaqsPage({super.key});

  @override
  State<FaqsPage> createState() => _FaqsPageState();
}

class _FaqsPageState extends State<FaqsPage> {
  LoanHandler loanHandler = LoanHandler();
  LoginResponseModel user = LoginResponseModel();

  FAQBaseModel faqBaseModel = FAQBaseModel();
  Future<FAQBaseModel> futureFAQBaseModel = Future(() => FAQBaseModel());

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));
        futureFAQBaseModel = getFAQsList();
      });
    });
  }

  Future<FAQBaseModel> getFAQsList() async {
    return await loanHandler.getFaqsList("en");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgDefault1,
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
          "Frequently asked Questions",
          style: TextStyle(
            color: AppColor.lightBlack,
            fontSize: 15.0,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColor.lightBlack),
        backgroundColor: AppColor.white,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<FAQBaseModel>(
          future: futureFAQBaseModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  faqBaseModel = snapshot.data!;
                }
              }
              return faqBaseModel.getFaqsList.isEmpty ? const Center(child: Text("No data available")) : getFaqsScreen(faqBaseModel);
            } else if (snapshot.hasError) {
              // Handle the error
              return Center(child: Text('${snapshot.error}'));
            } else {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CustomLoader()),
              );
            }
          },
        ),
      ),
    );
  }

  Padding getFaqsScreen(FAQBaseModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0, bottom: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
              shrinkWrap: true, // use it
              physics: const NeverScrollableScrollPhysics(),
              itemCount: model.getFaqsList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    border: Border.all(width: 1, color: AppColor.grey2),
                  ),
                  child: ListTile(
                    dense: false,
                    title: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        title: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(model.getFaqsList[index].getQuestion, style: AppStyle.textLabel3),
                            )),
                        children: <Widget>[
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                child: Text(model.getFaqsList[index].getAnswers, style: AppStyle.textLabel2),
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
