import 'package:flutter/material.dart';
import 'package:homieeee/auth/auth_service.dart';
import 'package:homieeee/utils/constants/constants.dart';
import 'package:sizer/sizer.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

final List<String> ageList =
    List.generate(83, (index) => '${index + 18} Years');
const List<String> genderList = ['Male', 'Female', 'Other'];

class _EditProfilePageState extends State<EditProfilePage> {
  String? userDisplayName;
  String? _userPhotoURL;

  final _nameController = TextEditingController();
  final _msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    userDisplayName = await AuthService().getUserDisplayName();
    _userPhotoURL = await AuthService().getPhotoURL();

    // Set initial values for text controllers after data is fetched
    _nameController.text = userDisplayName ?? ''; // Set empty string if null
    _msgController.text = ''; // Or set a default message if desired

    setState(() {});
  }

  String _selectedAge = ageList.first;
  String _selectedGender = genderList.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: bottomSheetMethod(context),
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20).copyWith(top: 30, bottom: 100),
        children: [
          threeImages(),
          heightSpace30,
          Text('Full Name', style: color8ARegular15),
          heightSpace8,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2.5),
            decoration: BoxDecoration(
              color: colorF9,
              borderRadius: borderRadius10,
            ),
            child: TextField(
              style: blackRegular16,
              controller: _nameController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your name',
              ),
            ),
          ),
          heightSpace25,
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
          heightSpace25,
          Text('About me', style: color8ARegular15),
          heightSpace8,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2.5),
            decoration: BoxDecoration(
              color: colorF9,
              borderRadius: borderRadius10,
            ),
            child: TextField(
              style: blackRegular16,
              controller: _msgController,
              maxLines: 5,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'Enter your message'),
            ),
          ),
        ],
      ),
    );
  }

  Container bottomSheetMethod(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            child: const Text('Update'),
            onPressed: () => _updateProfile(),
          )
        ],
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
              width: (100.w - 60) / 2,
              height: (100.w - 60) / 2,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(.25),
                borderRadius: borderRadius10,
                image: DecorationImage(
                    image: Image.network(_userPhotoURL!).image,
                    fit: BoxFit.cover),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                width: (100.w - 80) / 9.5,
                height: (100.w - 80) / 9.5,
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
            )
          ],
        ),
      ],
    );
  }

  Future<void> _updateProfile() async {
    // Get the user ID
    final userId = await AuthService().getCurrentUser()!.uid;

    // Prepare updated data
    final updatedData = {
      'displayName': _nameController.text.trim(),
      'age': _selectedAge,
      'gender': _selectedGender,
      'aboutMe': _msgController.text.trim(),
      // Add other fields as needed
    };

    // Update user data in Firestore
    try {
      await AuthService().updateUser(userId, updatedData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        AuthService.customSnackBar(
          content: 'Error updating profile. Please try again.',
        ),
      );
    }
  }
}
