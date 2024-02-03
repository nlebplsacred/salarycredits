import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:salarycredits/features/loan_apply_confirm_otp/loan_apply_otp_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/document/document_model.dart';
import '../../models/loan/lender_consent_model.dart';
import '../../models/loan/loan_model.dart';
import '../../models/login/login_response_model.dart';
import '../../services/file_handler.dart';
import '../../services/loan_handler.dart';
import '../../utility/global.dart';
import '../../values/colors.dart';
import '../../values/styles.dart';

class LoanProfilePicturePage extends StatefulWidget {
  final LoanModel loanModel;

  const LoanProfilePicturePage({required this.loanModel, super.key});

  @override
  State<LoanProfilePicturePage> createState() => _LoanProfilePicturePageState();
}

class _LoanProfilePicturePageState extends State<LoanProfilePicturePage> {
  LoginResponseModel user = LoginResponseModel();
  LoanModel loanApplicationModel = LoanModel();
  LoanHandler loanHandler = LoanHandler();
  FileHandler fileHandler = FileHandler();
  LenderConsent lenderConsent = LenderConsent();
  LoanDocumentsModel loanDocumentsModel = LoanDocumentsModel();
  Documents documents = Documents();
  final ImagePicker picker = ImagePicker();
  String imagePath = "";
  late File imageFile;

  bool isLoading = false, isLoadingDP = false, isFileSelected = false;
  String errorMsg = "", profilePicture = "";

  @override
  void initState() {
    super.initState();
    loanApplicationModel = widget.loanModel;

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));
      });
    });
  }

  uploadProfilePic(DocumentRequestModel requestModel) async {
    setState(() {
      isLoadingDP = true;
      errorMsg = '';
    });

    try {
      await fileHandler.uploadFile(requestModel).then((Documents result) {
        setState(() {
          isLoadingDP = false;
          documents = result;
          profilePicture = documents.getFilePath;
          isFileSelected = true;
        });
      }).catchError((err, stackTrace) {
        setState(() {
          isLoadingDP = false;
          errorMsg = fileHandler.errorMessage;
        });
      });
    } catch (ex) {
      setState(() {
        isLoadingDP = false;
        errorMsg = 'Network not available';
      });
    }
  }

  _imgFromGallery() async {
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 50).then((value) {
      if (value != null) {
        _cropImage(File(value.path));
        imagePath = value.path;
      }
    });
  }

  _imgFromCamera() async {
    await picker.pickImage(source: ImageSource.camera, imageQuality: 50).then((value) {
      if (value != null) {
        _cropImage(File(value.path));
        imagePath = value.path;
      }
    });
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        // Adjust aspect ratio as needed
        compressQuality: 100,
        // Image quality
        maxWidth: 1080,
        // Maximum width of the cropped image
        maxHeight: 1080,
        // Maximum height of the cropped image
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Profile Picture',
            toolbarColor: AppColor.darkBlue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: "Profile Picture"),
          WebUiSettings(
            context: context,
          ),
        ]);

    if (croppedFile != null) {
      imageCache.clear();
      setState(() async {
        imageFile = File(croppedFile.path);
        //call API to save image
        uploadProfilePic(DocumentRequestModel(user.applicantId, "", "0", "", "4", imageFile.path));
      });
      // reload();
    }
  }

  Future<void> requestCameraPermission() async {
    const permission = Permission.camera;

    if (await permission.isDenied) {
      final result = await permission.request();
      if (result.isGranted) {
        // Permission is granted
        //showImagePicker(); //Open camera/gallery
        _imgFromCamera(); //Open only camera
      } else if (result.isDenied) {
        showAlertDialogForCamera(); // Permission is denied
      } else if (result.isPermanentlyDenied) {
        openAppSettings();
      }
    } else {
      if (await permission.status.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }

  Future<bool> checkCameraPermission() async {
    const permission = Permission.camera;
    return await permission.status.isGranted;
  }

  Future<bool> checkCameraPermanentlyDenied() async {
    const permission = Permission.camera;
    return await permission.status.isPermanentlyDenied;
  }

  Future<bool> showCameraRequestRationale() async {
    const permission = Permission.camera;
    return await permission.shouldShowRequestRationale;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog.
        bool confirm = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm'),
            content: const Text('Are you sure you want to exit?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Exit'),
              ),
            ],
          ),
        );

        // Perform cleanup logic if the user confirms the exit.
        if (confirm == true) {
          SystemNavigator.pop();
        }
        // Return the result of the confirmation dialog.
        return confirm;
      },
      child: Scaffold(
        body: SafeArea(
          child: getProfilePictureScreen(),
        ),
      ),
    );
  }

  SingleChildScrollView getProfilePictureScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 32, left: 0.0),
                child: Text(
                  "Add Profile Photo",
                  style: AppStyle.userProfile,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 65,
                          backgroundColor: AppColor.lightBlue,
                          child: isLoadingDP
                              ? const CircularProgressIndicator(
                                  backgroundColor: AppColor.white,
                                  color: AppColor.lightBlue,
                                )
                              : CircleAvatar(
                                  backgroundColor: AppColor.darkBlue,
                                  radius: 63,
                                  child: ClipOval(
                                    child: profilePicture.isEmpty
                                        ? Text(Global.getNameInitials(user.firstName, user.lastName), style: const TextStyle(color: AppColor.white))
                                        : Image.network(
                                            profilePicture,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                        ),
                        Positioned(
                          bottom: -2,
                          right: -25,
                          child: RawMaterialButton(
                            onPressed: () async {
                              const permission = Permission.camera;
                              final status = await permission.status.isGranted;

                              if (status) {
                                //showImagePicker(); //Open camera/gallery
                                _imgFromCamera(); //Open only camera
                              } else {
                                //open popup for prominent disclose of permission
                                showAlertDialogForCamera();
                              }
                            },
                            elevation: 2.0,
                            fillColor: AppColor.lightBlue,
                            padding: const EdgeInsets.all(6.0),
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: AppColor.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32, left: 16.0, right: 16.0),
            child: Text("Take a clear selfy".toUpperCase(), style: AppStyle.pageTitle3),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
            child: Center(
              child: Text(
                errorMsg,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
          Visibility(
            visible: isFileSelected,
            child: Padding(
              padding: const EdgeInsets.only(top: 36.0, left: 16.0, right: 16.0),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.lightBlue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)), // <-- Radius
                    ),
                  ),
                  onPressed: () async {
                    //call API to save image/file
                    if (isFileSelected) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                        return LoanApplyOTPPage(loanModel: loanApplicationModel);
                      }));
                    } else {
                      Global.showAlertDialog(context, "Upload profile picture");
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          backgroundColor: AppColor.white,
                          color: AppColor.lightBlue,
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(color: AppColor.white, fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //start region img picker
  void showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    child: const Column(
                      children: [
                        Icon(
                          Icons.image,
                          size: 60.0,
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          "Gallery",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        )
                      ],
                    ),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 60.0,
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            "Camera",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  //end region

  void showAlertDialogForCamera() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: const Text('Allow access to Camera'),
          content: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColor.bgDefault1,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Data Access",
                      style: AppStyle.pageTitle2,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "SalaryCredits access camera and captures profile picture or KYC documents as part of loan application process.",
                      style: AppStyle.normalDesc,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "Data Collection",
                      style: AppStyle.pageTitle2,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "SalaryCredits collect and share the user information (i.e, Profile Photo, PAN, Aadhaar) to lender to provide the loan facility.",
                      style: AppStyle.normalDesc,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "Storage of your Personal Data",
                      style: AppStyle.pageTitle2,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "We store and process your personal data only in India, in accordance with RBI in respect of lending facility. Your personal data is totally safe &amp; secure with us.",
                      style: AppStyle.normalDesc,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "Sharing of your Personal Data",
                      style: AppStyle.pageTitle2,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "Any Personal Data that we have access to shall never be shared with anyone without your consent.\n\n In our product offerings we always seek your explicit consent to use/share your Personal Data.\n\n In our business and operational process, we only share the data on partial and 'need-to-know' basis to designated partners or service providers.",
                      style: AppStyle.normalDesc,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "Usage of your Personal Data",
                      style: AppStyle.pageTitle2,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "We use your Personal Data in our business/banking activities our or our partners' products/services as the following.\n\nTo facilitate loans and advances.\n\nTo download and send account statement.\n\nTo check the process your applications submitted to us for banking services or request received from you in respect of these services\n\nTo share updates and promotional offers with you.",
                      style: AppStyle.normalDesc,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.lightBlue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)), // <-- Radius
                ),
              ),
              onPressed: () {
                requestCameraPermission();
                Navigator.of(context).pop(); //Close the dialog
              },
              child: const Text(
                "Accept",
                textAlign: TextAlign.left,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); //Close the dialog
              },
              child: const Text('Skip'),
            ),
          ],
        );
      },
    );
  }
}
