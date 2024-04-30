import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homieeee/auth/auth_service.dart';
import 'package:homieeee/screens/authentication/login_page.dart';
import 'package:homieeee/screens/authentication/widgets/primary_button.dart';
import 'package:homieeee/utils/constants/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class AboutMe extends StatefulWidget {
  AboutMe({super.key});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

final List<String> ageList =
    List.generate(83, (index) => '${index + 18} Years');

List<String> genderList = ['Male', 'Female', 'Other'];
bool _termsAccepted = false;

class _AboutMeState extends State<AboutMe> {
  final _nameController = TextEditingController();
  final _msgController = TextEditingController();
  String? _selectedAge; // Use nullable String
  String? _selectedGender;
  File? img;
  String imageURL = '';
  final fileName = DateTime.now().millisecondsSinceEpoch.toString();

  void uploadProfilePicToFirebase() async {
    Reference reference = FirebaseStorage.instance.ref();
    Reference referenceDir = reference.child('profile_pics');
    Reference referenceUpload = referenceDir.child(fileName);

    try {
      await referenceUpload.putFile(img!);
      imageURL = await referenceUpload.getDownloadURL();
    } catch (e) {
      throw e.toString();
    }
  }

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(30).copyWith(top: 30, bottom: 100),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Complete your profile',
                  style: blackBold24,
                ),
                Text('2/2', style: blackBold18)
              ],
            ),
            heightSpace10,
            Text(
              'Continue to create your profile',
              style: color8ARegular15,
            ),
            heightSpace25,
            threeImages(),
            heightSpace30,
            Text('Full Name', style: color8ARegular15),
            heightSpace8,
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 2.5),
              decoration: BoxDecoration(
                color: colorF9,
                borderRadius: borderRadius10,
              ),
              child: TextFormField(
                style: blackRegular16,
                controller: _nameController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your name',
                ),
              ),
            ),
            heightSpace15,
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Age', style: color8ARegular15),
                      heightSpace8,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: colorF9,
                          borderRadius: borderRadius10,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            dropdownColor: white,
                            value: _selectedAge,
                            isExpanded: true,
                            icon: RotatedBox(
                                quarterTurns: 1,
                                child: Icon(
                                  Icons.chevron_right,
                                  color: primaryColor,
                                )),
                            elevation: 16,
                            style: blackRegular16,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedAge = value!;
                              });
                            },
                            items: ageList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                widthSpace20,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gender', style: color8ARegular15),
                      heightSpace8,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: colorF9,
                          borderRadius: borderRadius10,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            dropdownColor: white,
                            value: _selectedGender,
                            isExpanded: true,
                            icon: RotatedBox(
                                quarterTurns: 1,
                                child: Icon(
                                  Icons.chevron_right,
                                  color: primaryColor,
                                )),
                            elevation: 16,
                            style: blackRegular16,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                            items: genderList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            heightSpace15,
            Text('About me', style: color8ARegular15),
            heightSpace8,
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 2.5),
              decoration: BoxDecoration(
                color: colorF9,
                borderRadius: borderRadius10,
              ),
              child: TextField(
                style: blackRegular16,
                controller: _msgController,
                maxLines: 4,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Enter your message'),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _termsAccepted = !_termsAccepted),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(2)),
                    child: _termsAccepted ? Image.asset(checkIcon) : null,
                  ),
                ),
                widthSpace12,
                Expanded(
                  child: Text.rich(TextSpan(
                      text: 'By creating an account, you agree to our ',
                      style: color8ARegular15,
                      children: [
                        TextSpan(
                            text: 'Terms and Condition', style: primaryMedium15)
                      ])),
                )
              ],
            ),
            heightSpace15,
            PrimaryButton(
                title: 'Complete Profile',
                onTap: () async {
                  if (validateFields()) {
                    await AuthService().updateUserProfile(
                      imageURL,
                      _nameController.text,
                      _selectedAge!,
                      _msgController.text,
                      _selectedGender!,
                    );
                    await AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      autoHide: Duration(seconds: 3),
                      animType: AnimType.topSlide,
                      title: 'Success',
                      desc: 'You have Completed your profile. Please login again to continue',
                    ).show();
                    print('Inside the Validate function');
                  }
                  LoginPage();
                })
          ],
        ),
      ),
    );
  }

  threeImages() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              width: (100.w - 60) / 3,
              height: (100.w - 60) / 3,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(.25),
                borderRadius: borderRadius10,
                image: img != null
                    ? DecorationImage(
                        image: Image.file(img!).image, fit: BoxFit.cover)
                    : DecorationImage(
                        image: Image.asset('assets/icons/username.png').image,
                        fit: BoxFit.cover),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  showImagePickerOption(context);
                },
                child: Container(
                  width: (100.w - 80) / 10.5,
                  height: (100.w - 80) / 10.5,
                  decoration: BoxDecoration(
                    color: const Color(0xff000000).withOpacity(.50),
                    borderRadius: borderRadius10,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.edit_outlined,
                      color: white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  bool validateFields() {
    List<String> missingFields = [];

    if (_nameController.text.isEmpty) {
      missingFields.add('Please enter your name.');
    }
    if (_msgController.text.isEmpty) {
      missingFields.add('Please enter information about yourself.');
    }
    if (_selectedGender == null) {
      missingFields.add('Please select your gender.');
    }
    if (imageURL == '') {
      missingFields.add('Please select profile picture');
    }
    if (_selectedAge == null) {
      missingFields.add('Please select your age.');
    }
    if (!_termsAccepted) {
      missingFields.add('Please accept the terms and conditions.');
    }

    if (missingFields.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Missing Information'),
            content: SingleChildScrollView(
              child: ListBody(
                children: missingFields.map((field) => Text(field)).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }

    return true;
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    setState(() {
      img = File(returnedImage.path);
      uploadProfilePicToFirebase();
      Navigator.pop(context);
    });
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    setState(() {
      img = File(returnedImage.path);
      uploadProfilePicToFirebase();
      Navigator.pop(context);
    });
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      _pickImageFromGallery();
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.image, size: 60), Text('Gallery')],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      _pickImageFromCamera();
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera,
                          size: 60,
                        ),
                        Text('Camera')
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
