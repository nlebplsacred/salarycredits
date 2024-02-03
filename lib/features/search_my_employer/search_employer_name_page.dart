import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salarycredits/models/login/employer_info.dart';

import '../../services/user_handler.dart';
import '../../utility/global.dart';
import '../../values/colors.dart';
import '../../values/strings.dart';
import '../../values/styles.dart';
import '../nominate_employer/nominate_my_employer_page.dart';

class SearchEmployerNamePage extends StatefulWidget {
  const SearchEmployerNamePage({super.key});

  @override
  State<SearchEmployerNamePage> createState() => _SearchEmployerNamePageState();
}

class _SearchEmployerNamePageState extends State<SearchEmployerNamePage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController searchEmployerController = TextEditingController();
  final UserHandler userHandler = UserHandler();
  EmployerInfo employerInfo = EmployerInfo(0, "NA");
  bool isLoading = false;
  String errorMessage = '';
  bool showSearchForm = true;
  bool showSearchResult = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searchEmployerController.dispose();
  }

  searchEmployer() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    await userHandler
        .searchEmployer(searchEmployerController.text.toString())
        .then((value) {
      setState(() {
        isLoading = false;
        employerInfo = value;

        if (employerInfo.employerId > 0) {
          showSearchResult = true;
          showSearchForm = false;
        } else {
          //redirect to dashboard if mobile is verified or open a new screen to verify mobile number
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const NominateMyEmployerActivity();
          }));
        }
      });
    }).catchError((error, stackTrace) {
      setState(() {
        isLoading = false;
        errorMessage = error;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 1.0,
        toolbarHeight: 60.0,
        titleSpacing: 2.0,
        title: Text(
        AppText.searchYourEmployer,
          style: const TextStyle(
            color: AppColor.lightBlack,
            fontSize: 15.0,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColor.lightBlack),
        backgroundColor: AppColor.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Visibility(visible: showSearchForm, child: getSearchForm()),
              Visibility(visible: showSearchResult, child: getResultForm())
            ],
          ),
        ),
      ),
    );
  }

  Padding getSearchForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        children: [
          Text(
           AppText.searchEmployerWelcomeToSalarycredits,
            style: AppStyle.splashDesc2,
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(AppText.searchYourEmployerByName,
                  style: AppStyle.splashDesc2, textAlign: TextAlign.left),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, left: 0.0, right: 0.0),
                    child: TextFormField(
                      controller: searchEmployerController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "* Required.";
                        } else {
                          return Global.validateEmployer(value);
                        }
                      },
                      keyboardType: TextInputType.text,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        hintText: 'Employer Name',
                        labelText: "Employer Name",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                    child: Center(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, left: 48.0, right: 48.0),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.lightBlue,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(8)), // <-- Radius
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            // Navigate the user to the Home page
                            searchEmployer(); //login with email
                          }
                        },
                        child: isLoading
                            ? const CircularProgressIndicator(
                                backgroundColor: AppColor.white,
                                color: AppColor.lightBlue,
                              )
                            : const Text(
                                'Search',
                                style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding getResultForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        children: [
          const Text(
            "1 match found",
            style: AppStyle.splashDesc2,
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(employerInfo.employerName,
              style: AppStyle.splashHeading3, textAlign: TextAlign.left),
          const SizedBox(
            height: 20.0,
          ),
          Text(
          AppText.yourEmployerAvailable,
            style: AppStyle.splashDesc2,
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            AppText.writeToUs,
            style: AppStyle.splashDesc2,
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 50.0,
            width: 60.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.lightBlue,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(8)), // <-- Radius
                ),
              ),
              onPressed: () {
                SystemNavigator.pop(); //exit the app
              },
              child: const Text(
                'Ok',
                style: TextStyle(
                    color: AppColor.white, fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }
}
