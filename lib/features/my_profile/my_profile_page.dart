import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salarycredits/models/profile/profile_model.dart';
import 'package:salarycredits/services/user_handler.dart';
import 'package:salarycredits/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../models/document/document_model.dart';
import '../../models/login/login_response_model.dart';
import '../../services/file_handler.dart';
import '../../utility/custom_loader.dart';
import '../../utility/global.dart';
import '../../values/colors.dart';
import '../../values/strings.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final UserHandler userHandler = UserHandler();
  final FileHandler fileHandler = FileHandler();
  LoginResponseModel user = LoginResponseModel();
  Documents documents = Documents();
  ProfileModel profileModel = ProfileModel();
  late Future<ProfileModel> futureProfileModel = Future(() => ProfileModel());
  late List<MyDocuments> kycAadhaar = [];
  late MyDocuments kycPAN = MyDocuments();
  final formKey = GlobalKey<FormState>();
  final form2Key = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  bool passwordVisible = false;

  DateFormat outputFormatDate = DateFormat('dd MMM, yyyy');
  bool isLoading = false, isError = false, isLoadingDP = false, isLoadingPan = false, isFileSelected = false;
  String error = "", errorMsg = "", randOTPNumber = "";
  String mobileNumberMasked = "Mobile Number - ", mobileNumber = "";

  late Future<String> futureSendOtpData = Future(() => "");
  bool showVerifyOtp = false;
  bool showMobileUpdate = true;
  bool isMobileUpdated = false;
  bool isResentOtp = false;

  final ImagePicker picker = ImagePicker();
  String imagePath = "";
  late File imageFile, kycFile = File("");
  String fileTypeId = "1";
  double aniMaValue = 0;
  late BuildContext dContext; //variable for dialog context

  // final networkConnectivity = Connectivity();
  // bool isNetConnected = false;
  //
  // checkInternet() async {
  //   ConnectivityResult result = await networkConnectivity.checkConnectivity();
  //   if (result != ConnectivityResult.none) {
  //     isNetConnected = true;
  //   }
  //
  //   networkConnectivity.onConnectivityChanged.listen((result) {
  //     if (result != ConnectivityResult.none) {
  //       isNetConnected = true;
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));
        futureProfileModel = loadUserProfileData();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  callback(newValue) {
    setState(() {
      user.mobile = newValue;
    });
  }

  void determinateIndicator() {
    Timer.periodic(const Duration(seconds: 4000), (Timer timer) {
      setState(() {
        if (aniMaValue == 1) {
          timer.cancel();
        } else {
          aniMaValue = aniMaValue + 0.1;
        }
      });
    });
  }

  uploadProfilePic(DocumentRequestModel requestModel) async {
    setState(() {
      isLoadingDP = true;
      error = '';
    });

    try {
      await fileHandler.uploadFile(requestModel).then((Documents result) {
        setState(() {
          isLoadingDP = false;
          documents = result;

          user.profilePicture = documents.getFilePath;
          profileModel.userInformation?.profilePicture = documents.getFilePath;
        });
      }).catchError((err, stackTrace) {
        setState(() {
          isLoading = false;
          error = fileHandler.errorMessage;
        });
      });
    } catch (ex) {
      setState(() {
        isLoading = false;
        error = 'Network not available';
      });
    }
  }

  uploadKyc(DocumentRequestModel requestModel) async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      await fileHandler.uploadFile(requestModel).then((Documents result) {
        setState(() {
          isLoading = false;
          documents = result;

          Navigator.of(dContext).pop(); //Close the dialog
        });
      }).catchError((err, stackTrace) {
        setState(() {
          isLoading = false;
          error = userHandler.errorMessage;
        });
      });
    } catch (ex) {
      setState(() {
        isLoading = false;
        error = 'Network not available';
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
        uploadProfilePic(DocumentRequestModel(user.applicantId, "", "0", "", fileTypeId, imageFile.path));
      });
      // reload();
    }
  }

  Future<void> requestCameraPermission() async {
    const permission = Permission.camera;

    if (await permission.isDenied) {
      final result = await permission.request();
      if (result.isGranted) {
        //Permission is granted
        //showImagePicker(); //Open the camera/gallery both
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

//check if user already logged in
  Future<ProfileModel> loadUserProfileData() async {
    return await userHandler.getUserProfileData(user.applicantId!);
  }

  String getUserTitle(UserInformation? userInformation) {
    String? lDesignation = userInformation?.designation;
    String? lLocation = userInformation?.cityName;
    String lUserTitle = "N/A";

    lUserTitle = "$lDesignation | $lLocation";
    return lUserTitle;
  }

  String getDOB(String dob) {
    String lDOB = "N/A";
    try {
      if (dob != "") {
        lDOB = outputFormatDate.format(DateTime.parse(dob));
      }
    } on FormatException catch (_) {}

    return lDOB;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColor.lightBlue2,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: AppColor.lightBlue2,
      body: SafeArea(
        child: Center(
          child: FutureBuilder<ProfileModel>(
            future: futureProfileModel,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  profileModel = snapshot.data!;

                  if (profileModel.myDocuments != null) {
                    profileModel.myDocuments?.forEach((doc) {
                      if (doc.fileTypeId == 2) {
                        kycAadhaar.add(doc);
                      } else if (doc.fileTypeId == 1) {
                        kycPAN = doc;
                      }
                    });
                  }
                }
                return profileModel.userInformation == null
                    ? const Center(child: Text("Data not available\nCheck your internet connectivity"))
                    : getProfileScreen();
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              } else {
                return const CustomLoader();
              }
            },
          ),
        ),
      ),
    );
  }

  SingleChildScrollView getProfileScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 40.0),
      child: Column(
        children: [
          Container(
            height: 355.0,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.all(Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                  color: AppColor.lightGrey,
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16, left: 8.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 32, left: 65.0),
                      child: Text(
                        "My Profile",
                        style: AppStyle.pageTitle,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 55,
                                backgroundColor: AppColor.lightBlue,
                                child: isLoadingDP
                                    ? const CircularProgressIndicator(
                                        backgroundColor: AppColor.white,
                                        color: AppColor.lightBlue,
                                      )
                                    : CircleAvatar(
                                        backgroundColor: AppColor.darkBlue,
                                        radius: 53,
                                        child: ClipOval(
                                          child: profileModel.userInformation?.profilePicture == null
                                              ? Text(Global.getNameInitials(user.firstName, user.lastName),
                                                  style: const TextStyle(color: AppColor.white))
                                              : Image.network(
                                                  '${profileModel.userInformation?.profilePicture}',
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

                                    fileTypeId = "4";
                                    if (status) {
                                      //showImagePicker(); //Open the camera/gallery both
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
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text('${user.firstName} ${user.lastName ?? "NA"}', style: AppStyle.pageTitleLarge1),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(getUserTitle(profileModel.userInformation), style: AppStyle.userTitle),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 90.0,
                      width: 100.0,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Text("${Global.getYears(profileModel.userInformation!.dOB.toString())}Yrs", style: AppStyle.pageTitle),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Text("Age", style: AppStyle.textLabel),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                      height: 80,
                      child: Padding(
                        padding: EdgeInsets.only(top: 36.0),
                        child: VerticalDivider(
                          thickness: 2,
                          color: AppColor.lightGrey,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 90.0,
                      width: 100.0,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Text('\u{20B9}${user.netPayableSalary?.round() ?? 0}', style: AppStyle.pageTitle),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Text("Salary", style: AppStyle.textLabel),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                      height: 80,
                      child: Padding(
                        padding: EdgeInsets.only(top: 36.0),
                        child: VerticalDivider(
                          thickness: 2,
                          color: AppColor.lightGrey,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 90.0,
                      width: 100.0,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Text(profileModel.userInformation?.genderType ?? "NA", style: AppStyle.pageTitle),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Text("Gender", style: AppStyle.textLabel),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 26.0),
                child: Text("Contact Details", style: AppStyle.userProfile),
              )
            ],
          ),
          const SizedBox(height: 16.0),
          Container(
            height: 70.0,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: AppColor.lightGrey,
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox.fromSize(
                    size: const Size(42, 42),
                    child: const ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: Material(
                        color: AppColor.lightBlue,
                        child: Icon(Icons.email, size: 24, color: AppColor.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0, top: 14.0),
                        child: Text(
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          '${user.userEmail}', //${user.userEmail}
                          style: AppStyle.pageTitle,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 0.0, top: 2),
                        child: Text(
                          "Email",
                          style: AppStyle.textLabel,
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.done, size: 26, color: AppColor.green),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            height: 70.0,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: AppColor.lightGrey,
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox.fromSize(
                    size: const Size(42, 42),
                    child: const ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: Material(
                        color: AppColor.bgScreen3,
                        child: Icon(Icons.mobile_friendly_rounded, size: 24, color: AppColor.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0, top: 14.0),
                        child: Text(
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          user.mobile ?? "NA", //${user.userEmail}
                          style: AppStyle.pageTitle,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 0.0, top: 2),
                        child: Text(
                          "Mobile",
                          style: AppStyle.textLabel,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          showMobileUpdateView();
                        },
                        icon: const Icon(Icons.edit, size: 24, color: AppColor.darkBlue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            height: 70.0,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: AppColor.lightGrey,
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox.fromSize(
                    size: const Size(42, 42),
                    child: const ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: Material(
                        color: AppColor.bgScreen4,
                        child: Icon(Icons.calendar_today, size: 24, color: AppColor.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0, top: 14.0),
                        child: Text(
                          getDOB(profileModel.userInformation!.dOB.toString()), //${user.userEmail}
                          style: AppStyle.pageTitle,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 0.0, top: 2),
                        child: Text(
                          "Date of birth",
                          style: AppStyle.textLabel,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 26.0),
                child: Text("Documents", style: AppStyle.userProfile),
              )
            ],
          ),
          const SizedBox(height: 16.0),
          Container(
            height: 70.0,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: AppColor.lightGrey,
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox.fromSize(
                    size: const Size(42, 42),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: Material(
                        color: AppColor.bgScreen5,
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Image.asset("assets/pan_card.png", color: AppColor.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 0.0, top: 26.0),
                        child: Text(
                          "PAN Card", //${user.userEmail}
                          style: AppStyle.pageTitle,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right:16.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: kycPAN.filePath != null
                          ? InkWell(
                              onTap: () async {
                                //show image/file
                                String filePath = kycPAN.filePath.toString();
                                if (filePath.contains(".pdf")) {
                                  openPDFDialog(filePath, "PAN Card"); // Open the PDF dialog
                                } else {
                                  openIMGDialog(filePath, "PAN Card"); // Open the PDF dialog
                                }
                              },
                              child: const Icon(Icons.download_done, size: 26, color: AppColor.darkBlue),
                            )
                          : IconButton(
                              onPressed: () {
                                fileTypeId = "1";
                                showDialogForKycUpload("PAN Card", "A clear photo of PAN card"); //open popup to choose doc
                              },
                              icon: const Icon(Icons.upload_rounded, size: 26, color: AppColor.darkBlue),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            height: 70.0,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: AppColor.lightGrey,
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox.fromSize(
                    size: const Size(42, 42),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: Material(
                        color: AppColor.bgScreen6,
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Image.asset("assets/aadhaarCard.png", color: AppColor.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 0.0, top: 26.0),
                        child: Text(
                          "Aadhaar Card", //${user.userEmail}
                          style: AppStyle.pageTitle,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right:16.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        child: kycAadhaar.isNotEmpty
                            ? InkWell(
                                onTap: () async {
                                  //show image/file

                                  if (kycAadhaar.length == 2) {
                                    String filePath1 = kycAadhaar[0].filePath.toString();
                                    String filePath2 = kycAadhaar[1].filePath.toString();

                                    if (filePath1.contains(".pdf")) {
                                      openPDFDialog(filePath1, "Aadhaar Card"); // Open the PDF dialog
                                    } else {
                                      if (!filePath1.contains(".pdf") && !filePath2.contains(".pdf")) {
                                        openIMGDialog2(filePath1, filePath2, "Aadhaar Card"); // Open the PDF dialog
                                      }
                                    }
                                  } else {
                                    String filePath = kycAadhaar[0].filePath.toString();
                                    if (filePath.contains(".pdf")) {
                                      openPDFDialog(filePath, "Aadhaar Card"); // Open the PDF dialog
                                    } else {
                                      openIMGDialog(filePath, "Aadhaar Card"); // Open the PDF dialog
                                    }
                                  }
                                },
                                child: const Icon(Icons.download_done, size: 26, color: AppColor.darkBlue),
                              )
                            : IconButton(
                                onPressed: () {
                                  fileTypeId = "2";
                                  showDialogForKycUpload("Aadhaar Card", "A clear photo of Aadhaar Card (both sides)"); //open popup to choose doc
                                },
                                icon: const Icon(Icons.upload_rounded, size: 26, color: AppColor.darkBlue),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
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
            height: 140.0,
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

  Padding verifyOtpScreen(StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.only(top: 72.0, left: 16.0, right: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                child: Image.asset("assets/logo_favicon.png", width: 72, height: 72),
              ),
            ],
          ),
          const SizedBox(height: 25.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppText.oneTimePassword,
                style: const TextStyle(
                  color: AppColor.lightBlack,
                  fontSize: 32.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  AppText.oneTimePasswordDesc,
                  style: const TextStyle(
                    color: AppColor.lightBlack,
                    fontSize: 15.0,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
          const SizedBox(height: 26.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                mobileNumberMasked,
                style: const TextStyle(
                  color: AppColor.lightBlack,
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: otpController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "* Required.";
                      } else if (value.length < 6) {
                        return "Invalid OTP";
                      } else {
                        return null;
                      }
                    },
                    maxLength: 6,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: AppText.oneTimePassword,
                    ),
                  ),
                ],
              ),
            ),
          ),
          isError
              ? Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                  child: Text(
                    errorMsg,
                    style: const TextStyle(color: Colors.red, fontSize: 13.0),
                  ),
                )
              : const Text(""),
          Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 72.0, right: 72.0),
            child: SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.lightBlue,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)), // <-- Radius
                  ),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    //verify
                    //verifyMobile();
                    if (user.applicantId! > 0) {
                      if (otpController.text.toString() == randOTPNumber) {
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          userHandler.verifyMobileNumber(user.applicantId!).then((String result) {
                            setState(() {
                              isLoading = false;
                            });

                            if (result.isNotEmpty) {
                              var data = jsonDecode(result);
                              //String status = data['Status'].toString();
                              String message = data['Message'].toString();

                              if (message == "Mobile Verified") {
                                setState(() {
                                  user.isMobileVerified = true;
                                });

                                userHandler.updateMobileNumber(user.applicantId!, mobileNumber).then((String result) {
                                  setState(() {
                                    isLoading = false;
                                  });

                                  var data = jsonDecode(result);
                                  String message = data['Message'].toString();

                                  if (message == "success") {
                                    setState(() {
                                      user.isMobileVerified = true;
                                      user.mobile = mobileController.text.toString();
                                      showMobileUpdate = true;
                                      showVerifyOtp = false;
                                      mobileController.text = "";
                                    });

                                    callback(user.mobile); //update mobile number widget using call back method

                                    Navigator.of(context).pop();
                                  } else {
                                    Global.showAlertDialog(context, message);
                                  }
                                });
                              } else {
                                Global.showAlertDialog(context, message);
                              }
                            } else {
                              Global.showAlertDialog(context, "Network not available");
                            }
                          });
                        } on Exception {
                          setState(() {
                            isLoading = false;
                            Global.showAlertDialog(context, "Network not available");
                          });
                        }
                      } else {
                        Global.showAlertDialog(context, "Invalid OTP");
                      }
                    } else {
                      Global.showAlertDialog(context, "Something went wrong, please try again");
                    }
                  }
                },
                child: isLoading
                    ? const CircularProgressIndicator(
                        backgroundColor: AppColor.white,
                        color: AppColor.lightBlue,
                      )
                    : const Text(
                        'Verify',
                        style: TextStyle(color: AppColor.white, fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ),
          Column(
            children: [
              InkWell(
                onTap: () async {
                  if (user.applicantId! > 0) {
                    randOTPNumber = Global.getRandomNumber();

                    setState(() {
                      isResentOtp = true;
                      error = '';
                    });

                    try {
                      await userHandler.sendOtp(mobileController.text.toString(), randOTPNumber).then((result) {
                        setState(() {
                          isResentOtp = false;

                          var data = jsonDecode(result);
                          String message = data['Message'].toString();

                          isError = true;
                          errorMsg = message;

                          showVerifyOtp = true;
                          showMobileUpdate = false;

                          user.mobile = mobileController.text.toString();
                          mobileNumber = user.mobile!;
                          mobileNumberMasked = "Mobile Number - ${Global.getMaskedMobile(mobileNumber)}";
                        });
                      });
                    } on Exception {
                      setState(() {
                        isLoading = false;
                        Global.showAlertDialog(context, "Network not available");
                      });
                    }
                  } else {
                    Global.showAlertDialog(context, "Something went wrong, please try again");
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 32, left: 16.0, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Resend OTP",
                        style: TextStyle(color: AppColor.lightBlue, fontSize: 16.0, fontWeight: FontWeight.normal),
                      ),
                      isResentOtp
                          ? const CircularProgressIndicator(
                              backgroundColor: AppColor.white,
                              color: AppColor.lightBlue,
                            )
                          : const Icon(Icons.refresh, size: 24.0, color: AppColor.lightBlue)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding updateMobileScreen(StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.only(top: 42.0, left: 16.0, right: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                child: Image.asset("assets/logo_favicon.png", width: 72, height: 72),
              ),
            ],
          ),
          const SizedBox(height: 25.0),
          const Text(
            "Update Mobile Number",
            style: TextStyle(
              color: AppColor.lightBlack,
              fontSize: 28.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16.0),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Add your latest mobile number",
                style: TextStyle(
                  color: AppColor.lightBlack,
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: Form(
              key: form2Key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: mobileController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "* Required.";
                      } else {
                        return Global.validateMobile(value);
                      }
                    },
                    maxLength: 10,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    decoration: const InputDecoration(
                      prefix: Text("+91 "),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: 'Enter your phone number',
                      labelText: "Enter your phone number",
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0, left: 16.0, right: 16.0),
            child: SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.lightBlue,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)), // <-- Radius
                  ),
                ),
                onPressed: () async {
                  if (form2Key.currentState!.validate()) {
                    //update mobile
                    if (user.applicantId! > 0) {
                      randOTPNumber = Global.getRandomNumber();

                      setState(() {
                        isLoading = true;
                        error = '';
                      });

                      try {
                        await userHandler.sendOtp(mobileController.text.toString(), randOTPNumber).then((result) {
                          setState(() {
                            isLoading = false;

                            var data = jsonDecode(result);
                            String message = data['Message'].toString();

                            isError = true;
                            errorMsg = message;

                            showVerifyOtp = true;
                            showMobileUpdate = false;

                            user.mobile = mobileController.text.toString();
                            mobileNumber = user.mobile!;
                            mobileNumberMasked = "Mobile Number - ${Global.getMaskedMobile(mobileNumber)}";
                          });
                        });
                      } on Exception {
                        setState(() {
                          isLoading = false;
                          Global.showAlertDialog(context, "Network not available");
                        });
                      }
                    } else {
                      Global.showAlertDialog(context, "Something went wrong, please try again");
                    }
                  }
                },
                child: isLoading
                    ? const CircularProgressIndicator(
                        backgroundColor: AppColor.white,
                        color: AppColor.lightBlue,
                      )
                    : const Text(
                        'Update Mobile',
                        style: TextStyle(color: AppColor.white, fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showMobileUpdateView() {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        dContext = context;
        return AlertDialog(
            insetPadding: EdgeInsets.zero,
            content: StatefulBuilder(// You need this, notice the parameters below:
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: double.maxFinite,
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  color: AppColor.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  showVerifyOtp = false;
                                  showMobileUpdate = true;
                                  error = "";
                                  errorMsg = "";
                                  isError = false;
                                  mobileController.text = "";
                                });

                                Navigator.of(context).pop(); //Close the dialog
                              },
                              icon: const Icon(Icons.close, size: 24, color: AppColor.lightBlack)),
                        ),
                      ),
                      Visibility(visible: showVerifyOtp, child: verifyOtpScreen(setState)),
                      Visibility(visible: showMobileUpdate, child: updateMobileScreen(setState)),
                    ],
                  ),
                ),
              );
            }));
      },
    );
  }

  void showDialogForKycUpload(String title, message) {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        dContext = context;
        return AlertDialog(
            insetPadding: EdgeInsets.zero,
            content: StatefulBuilder(// You need this, notice the parameters below:
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: double.maxFinite,
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  color: AppColor.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  error = "";
                                  isLoading = false;
                                  isFileSelected = false;
                                  kycFile = File("");

                                  Navigator.of(context).pop(); //Close the dialog
                                },
                                icon: const Icon(Icons.close, size: 24, color: AppColor.lightBlack)),
                          ],
                        ),
                        const SizedBox(height: 42),
                        Text(title, style: AppStyle.pageTitle),
                        const SizedBox(height: 6),
                        const Divider(
                          thickness: 2,
                        ),
                        const SizedBox(height: 6),
                        Text(message, style: AppStyle.textLabel2),
                        const SizedBox(height: 32),
                        InkWell(
                          onTap: () async {
                            //choose file
                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'pdf', 'jpeg', 'png'],
                            );

                            if (result != null) {
                              //PlatformFile file = result.files.first;
                              setState(() {
                                kycFile = File(result.files.single.path!);
                                isFileSelected = true;
                                aniMaValue = 100;
                                determinateIndicator();
                              });
                            }
                          },
                          child: Container(
                            height: 130,
                            width: 130,
                            decoration: const BoxDecoration(
                              color: AppColor.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.lightGrey,
                                  blurRadius: 5.0,
                                  spreadRadius: 3.0,
                                  //offset: Offset(1.0, 1.0), // shadow direction: bottom right
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Select File",
                                  style: AppStyle.textLabel2,
                                ),
                                const SizedBox(height: 8),
                                isFileSelected
                                    ? const Icon(Icons.done_all, size: 42, color: AppColor.grey)
                                    : const Icon(Icons.cloud_upload_outlined, size: 42, color: AppColor.grey),
                              ],
                            ),
                          ),
                        ),
                        isFileSelected
                            ? Padding(
                                padding: const EdgeInsets.only(top: 36.0, left: 16.0, right: 16.0),
                                child: Container(
                                  width: double.maxFinite,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    color: AppColor.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 70.0,
                                        width: double.maxFinite,
                                        decoration: const BoxDecoration(
                                          color: AppColor.white,
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColor.lightGrey,
                                              blurRadius: 1.0,
                                              spreadRadius: 1.0,
                                            )
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: SizedBox.fromSize(
                                                size: const Size(42, 42),
                                                child: const ClipRRect(
                                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                                  child: Material(
                                                    color: AppColor.lightBlue,
                                                    child: Icon(Icons.file_copy_outlined, size: 24, color: AppColor.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: double.infinity,
                                              width: 150.0,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 0.0, top: 16.0),
                                                    child: Text(
                                                      title,
                                                      style: AppStyle.pageTitle2,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 0.0, top: 8),
                                                    child: LinearProgressIndicator(
                                                      color: AppColor.lightBlue,
                                                      value: aniMaValue,
                                                      minHeight: 6,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              child: IconButton(
                                                onPressed: () {
                                                  //deselect file
                                                  setState(() {
                                                    isFileSelected = false;
                                                    kycFile = File("");
                                                  });
                                                },
                                                icon: const Icon(Icons.delete, size: 24, color: AppColor.lightBlack),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller: passwordController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "* Required";
                                          }
                                          return null;
                                        },
                                        obscureText: passwordVisible,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                          hintText: "Password if any",
                                          labelText: "Password if any",
                                          suffixIcon: IconButton(
                                            icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                                            onPressed: () {
                                              setState(() {
                                                passwordVisible = !passwordVisible;
                                              });
                                            },
                                          ),
                                          alignLabelWithHint: false,
                                          filled: false,
                                        ),
                                        keyboardType: TextInputType.visiblePassword,
                                        textInputAction: TextInputAction.done,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : const Text(""),
                        Padding(
                          padding: const EdgeInsets.only(top: 26, left: 16.0, right: 16.0),
                          child: Text("Supported File Formats".toUpperCase(), style: AppStyle.heading16),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 26, left: 16.0, right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset("assets/pdf_icon.png", color: AppColor.bgScreen4, width: 48.0, height: 48.0),
                              Image.asset("assets/jpg_icon.png", color: AppColor.loanBox3, width: 48.0, height: 48.0),
                              Image.asset("assets/png_icon.png", color: AppColor.yellowLight, width: 48.0, height: 48.0),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 26, left: 16.0, right: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("\u2022 File size should not be more than 4MB.", style: AppStyle.normalDesc),
                              SizedBox(height: 6.0),
                              Text("\u2022 Share password in case file is protected.", style: AppStyle.normalDesc),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Center(
                            child: Text(
                              error,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                        Padding(
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

                                setState(() {
                                  isLoading = true;
                                });

                                if (kycFile.path.isNotEmpty) {
                                  await uploadKyc(
                                      DocumentRequestModel(user.applicantId, passwordController.text.toString(), "0", "", fileTypeId, kycFile.path));

                                  if (documents.getFilePath.isNotEmpty) {
                                    if (fileTypeId == "1") {
                                      kycPAN = MyDocuments(filePath: documents.getFilePath, fileTypeId: documents.getFileTypeId);
                                    } else if (fileTypeId == "2") {
                                      kycAadhaar.clear();
                                      kycAadhaar.add(MyDocuments(filePath: documents.getFilePath, fileTypeId: documents.getFileTypeId));
                                    }
                                  }
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Global.showAlertDialog(dContext, "Choose Document");
                                }
                              },
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      backgroundColor: AppColor.white,
                                      color: AppColor.lightBlue,
                                    )
                                  : const Text(
                                      'Upload',
                                      style: TextStyle(color: AppColor.white, fontSize: 16.0, fontWeight: FontWeight.w500),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
      },
    );
  }

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

  void openIMGDialog(String imgUrl, fileName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$fileName'),
          content: SizedBox(
            width: double.infinity,
            height: 250,
            child: Image.network(imgUrl, loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                // Image has been loaded
                return child;
              } else {
                // Display a loading indicator while loading
                return const CustomLoader();
              }
            }, fit: BoxFit.cover),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void openIMGDialog2(String imgUrl1, String imgUrl2, fileName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$fileName'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Front Side", style: AppStyle.pageTitle),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 250,
                child: Image.network(imgUrl1, loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    // Image has been loaded
                    return child;
                  } else {
                    // Display a loading indicator while loading
                    return const CustomLoader();
                  }
                }, fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              const Text("Back Side", style: AppStyle.pageTitle),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 250,
                child: Image.network(imgUrl2, loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const CustomLoader();
                  }
                }, fit: BoxFit.cover),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void openPDFDialog(String pdfUrl, fileName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$fileName'),
          content: SizedBox(
            width: double.infinity,
            height: 450,
            child: SfPdfViewer.network(
              pdfUrl, // URL of the PDF file
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
