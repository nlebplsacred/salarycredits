import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:salarycredits/features/loan_terms_acceptance_details/loan_terms_acceptance_page.dart';
import 'package:salarycredits/utility/custom_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/document/document_model.dart';
import '../../models/loan/loan_model.dart';
import '../../models/login/login_response_model.dart';
import '../../services/file_handler.dart';
import '../../utility/global.dart';
import '../../values/colors.dart';
import '../../values/styles.dart';

class LoanDocumentsFormPage extends StatefulWidget {
  final LoanModel loanModel;

  const LoanDocumentsFormPage({required this.loanModel, super.key});

  @override
  State<LoanDocumentsFormPage> createState() => _LoanDocumentsFormPageState();
}

class _LoanDocumentsFormPageState extends State<LoanDocumentsFormPage> {
  TextEditingController passwordController = TextEditingController();
  final FileHandler fileHandler = FileHandler();
  Documents documents = Documents();
  LoginResponseModel user = LoginResponseModel();
  LoanModel loanApplicationModel = LoanModel();

  LoanDocumentsModel loanDocumentsModel = LoanDocumentsModel();
  late Future<LoanDocumentsModel> futureLoanDocuments = Future(() => LoanDocumentsModel());

  bool isLoading = false, passwordVisible = false, mPdfOnly = false, isFileSelected = false;
  String errorMessage = "", error = "";

  final ImagePicker picker = ImagePicker();
  String imagePath = "";
  late File imageFile, kycFile = File("");
  String fileTypeId = "1";
  double aniMaValue = 0;
  late BuildContext dContext; //variable for dialog context

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        user = LoginResponseModel.fromJson(json.decode(prefs.getString('sessionUser').toString()));

        futureLoanDocuments = getMyDocuments(user.applicantId!, "1,2,6,7,10");
      });
    });

    loanApplicationModel = widget.loanModel;
  }

  Future<LoanDocumentsModel> getMyDocuments(int applicantId, String fileTypes) async {
    return fileHandler.getMyDocuments(applicantId, fileTypes);
  }

  callback() {
    setState(() {

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

          passwordController.text = ""; //reset

          if (documents.getFileTypeId == 3) {
            //send to next screen
            isFileSelected = false;

            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return LoanTermsAcceptancePage(loanModel: loanApplicationModel);
            }));
          } else {
            Documents itemDoc = Documents();
            itemDoc.setFileTypeId = documents.getFileTypeId;
            itemDoc.setFileName = documents.getFileName;

            loanDocumentsModel.setDocument = itemDoc;
            isFileSelected = false;
          }
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

  _imgFromGallery() async {
    List<String> allowedExt = ['jpg', 'pdf', 'jpeg', 'png'];

    //for bank statement
    if (fileTypeId == "3") {
      allowedExt = ['pdf'];
    }

    //choose file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExt,
    );

    if (result != null) {
      //PlatformFile file = result.files.first;

      final mimeType = lookupMimeType(result.files.single.path!);

      if (mimeType!.startsWith("image/")) {
        _cropImage(File(result.files.single.path!));
      } else {
        setState(() {
          kycFile = File(result.files.single.path!);
          isFileSelected = true;
          aniMaValue = 100;
          determinateIndicator();
        });
      }
    }
  }

  _imgFromCamera() async {
    await picker.pickImage(source: ImageSource.camera, imageQuality: 50).then((value) {
      if (value != null) {
        _cropImage(File(value.path));
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
            toolbarTitle: 'Picture',
            toolbarColor: AppColor.darkBlue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: "Picture"),
          WebUiSettings(
            context: context,
          ),
        ]);

    if (croppedFile != null) {
      imageCache.clear();
      setState(() async {
        kycFile = File(croppedFile.path);
        isFileSelected = true;
        aniMaValue = 100;
        determinateIndicator();

        callback(); //refresh page state
      });
      // reload();
    }
  }

  Future<void> requestCameraPermission() async {
    const permission = Permission.camera;

    if (await permission.isDenied) {
      final result = await permission.request();
      if (result.isGranted) {
        showImagePicker(); // Permission is granted
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
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        elevation: 1.0,
        toolbarHeight: 60.0,
        titleSpacing: 2.0,
        title: const Text(
          "Upload Documents",
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
          padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
          child: FutureBuilder<LoanDocumentsModel>(
            future: futureLoanDocuments,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    loanDocumentsModel = snapshot.data!;
                  }
                }
                return bindMyDocuments();
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
      ),
    );
  }

  Column bindMyDocuments() {
    List<LoanDocumentsModel> uploadedDocumentsTemp = [];
    List<LoanDocumentsModel> uploadedDocuments = [];

    String lFileTitle = "Upload Documents";
    String lFileDescription = "A clear photo of KYC";

    LoanDocumentsModel model1 = LoanDocumentsModel();
    model1.setFileTypeId = 1;
    model1.setUploaded = false;
    uploadedDocumentsTemp.add(model1);

    LoanDocumentsModel model2 = LoanDocumentsModel();
    model2.setFileTypeId = 2;
    model2.setUploaded = false;
    uploadedDocumentsTemp.add(model2);

    LoanDocumentsModel model21 = LoanDocumentsModel();
    model21.setFileTypeId = 21;
    model21.setUploaded = false;
    uploadedDocumentsTemp.add(model21);

    //in case rented house ask to upload current address proof
    if (loanApplicationModel.getApplicant.getResidenceTypeId == 1) {
      LoanDocumentsModel model4 = LoanDocumentsModel();
      model4.setFileTypeId = 10;
      model4.setUploaded = false;
      uploadedDocumentsTemp.add(model4);
    } else {
      //in case owned house ask to upload permanent address proof
      LoanDocumentsModel model3 = LoanDocumentsModel();
      model3.setFileTypeId = 6;
      model3.setUploaded = false;
      uploadedDocumentsTemp.add(model3);
    }

    LoanDocumentsModel model6 = LoanDocumentsModel();
    model6.setFileTypeId = 7;
    model6.setUploaded = false;
    uploadedDocumentsTemp.add(model6);

    LoanDocumentsModel model5 = LoanDocumentsModel();
    model5.setFileTypeId = 3;
    model5.setUploaded = false;
    uploadedDocumentsTemp.add(model5);

    //fetched from server
    if (loanDocumentsModel.getDocuments.isNotEmpty) {
      LoanDocumentsModel doc;
      int lAadhaarCount = 1;

      for (int i = 0; i < loanDocumentsModel.getDocuments.length; i++) {
        Documents itemDoc = loanDocumentsModel.getDocuments[i];

        doc = LoanDocumentsModel();
        doc.setFileName = itemDoc.getFileName;
        doc.setFileTypeId = itemDoc.getFileTypeId;
        doc.setUploaded = true;

        if (itemDoc.getFileTypeId == 2) {
          if (lAadhaarCount == 1) {
            uploadedDocuments.add(doc);
          } else if (lAadhaarCount == 2) {
            doc.setFileTypeId = 21;
            uploadedDocuments.add(doc);
          }

          lAadhaarCount++;
        } else {
          uploadedDocuments.add(doc);
        }
      }
    }

    if (uploadedDocuments.isNotEmpty) {
      for (int i = 0; i < uploadedDocuments.length; i++) {
        LoanDocumentsModel objServer = uploadedDocuments[i];
        for (int k = 0; k < uploadedDocumentsTemp.length; k++) {
          LoanDocumentsModel objLocal = uploadedDocumentsTemp[k];
          if (objServer.getFileTypeId == objLocal.getFileTypeId) {
            uploadedDocumentsTemp[k].setUploaded = true;
          } else {
            if (loanApplicationModel.getTenure == 1) {
              //for fast pay and EWA
              if (uploadedDocumentsTemp[k].getFileTypeId == 3) {
                //for STMT
                uploadedDocumentsTemp[k].setUploaded = false;
              }
            }
          }
        }
      }
    }

    for (int k = 0; k < uploadedDocumentsTemp.length; k++) {
      LoanDocumentsModel objLocal = uploadedDocumentsTemp[k];

      if (!objLocal.getUploaded) {
        if (objLocal.getFileTypeId == 1) {
          lFileTitle = "PAN Card";
          lFileDescription = "A clear photo of PAN Card.";
          fileTypeId = "1";
          break;
        } else if (objLocal.getFileTypeId == 2) {
          lFileTitle = "Aadhaar Card (Front)";
          lFileDescription = "A clear photo of Aadhaar Card Front.";
          fileTypeId = "2";
          break;
        } else if (objLocal.getFileTypeId == 21) {
          lFileTitle = "Aadhaar Card (Back)";
          lFileDescription = "A clear photo of Aadhaar Card Back.";
          fileTypeId = "2";
          break;
        } else if (objLocal.getFileTypeId == 6) {
          lFileTitle = "Permanent Address Proof";
          lFileDescription = "A copy of Electricity bill/Gas bill/Water tax/House tax/Registry documents";
          fileTypeId = "6";
          break;
        } else if (objLocal.getFileTypeId == 7) {
          lFileTitle = "Cheque Leaf";
          lFileDescription = "A copy of Salary Account cheque leaf";
          fileTypeId = "7";
          break;
        } else if (objLocal.getFileTypeId == 10) {
          lFileTitle = "Current Address Proof";
          lFileDescription = "A copy of Rent Agreement/Electricity bill/Gas bill/Mobile bill on your name";
          fileTypeId = "10";
          break;
        } else if (objLocal.getFileTypeId == 3) {
          lFileTitle = "Bank Statement";
          lFileDescription = "Upload recent 3 months Salary Account Statement in PDF format";
          fileTypeId = "3";
          mPdfOnly = true;
          break;
        }
      }
    }

    //do not take bank statement in case loan tenure is 1 month or EWA
    if (fileTypeId == "3") {
      if (loanApplicationModel.getApplicationTypeId == 13) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return LoanTermsAcceptancePage(loanModel: loanApplicationModel);
          }));
        });
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text("4/4", style: AppStyle.linkLightBlue2, textAlign: TextAlign.end)]),
        Container(
          height: MediaQuery.of(context).size.height,
          width: double.maxFinite,
          decoration: const BoxDecoration(
            color: AppColor.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(lFileTitle, style: AppStyle.pageTitle),
                  const SizedBox(height: 6),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(height: 6),
                  Text(lFileDescription, style: AppStyle.textLabel2),
                  const SizedBox(height: 32),
                  InkWell(
                    onTap: () async {
                      if (!isFileSelected) {
                        const permission = Permission.camera;
                        final status = await permission.status.isGranted;
                        if (status) {
                          showImagePicker(); //Open the camera
                        } else {
                          //open popup for prominent disclose of permission
                          showAlertDialogForCamera();
                        }
                      } else {
                        Global.showAlertDialog(context, "File already selected");
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
                          Text(
                            isFileSelected ? "File Selected" : "Select File",
                            style: AppStyle.textLabel2,
                          ),
                          const SizedBox(height: 8),
                          isFileSelected
                              ? const Icon(Icons.done_all, size: 42, color: AppColor.green)
                              : const Icon(Icons.cloud_upload_outlined, size: 42, color: AppColor.grey),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isFileSelected,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 26.0, left: 16.0, right: 16.0),
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
                                            lFileTitle,
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 26, left: 16.0, right: 16.0),
                    child: Text("Supported File Formats".toUpperCase(), style: AppStyle.heading16),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 26, left: 16.0, right: 16.0),
                    child: Column(
                      children: [
                        Visibility(
                          visible: mPdfOnly,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset("assets/pdf_icon.png", color: AppColor.bgScreen4, width: 48.0, height: 48.0),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: !mPdfOnly,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset("assets/pdf_icon.png", color: AppColor.bgScreen4, width: 48.0, height: 48.0),
                              Image.asset("assets/jpg_icon.png", color: AppColor.loanBox3, width: 48.0, height: 48.0),
                              Image.asset("assets/png_icon.png", color: AppColor.yellowLight, width: 48.0, height: 48.0),
                            ],
                          ),
                        )
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
                  Visibility(
                    visible: isFileSelected,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
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
                              await uploadKyc(DocumentRequestModel(user.applicantId, passwordController.text.toString(),
                                  loanApplicationModel.getApplicationId.toString(), "", fileTypeId, kycFile.path));
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
}
