import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homieeee/auth/auth_service.dart';
import 'package:homieeee/maps/add_map.dart';
import 'package:homieeee/utils/constants/constants.dart';
import 'package:homieeee/widgets/auth_textfield.dart';
import 'package:homieeee/widgets/curved_edges.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  File? _selectedImage;
  final _nameController = TextEditingController();
  final _msgController = TextEditingController();
  final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  final String _uid = AuthService().getCurrentUser()!.uid;
  final String? _email = AuthService().getCurrentUser()!.email;
  final String? _name = AuthService().getCurrentUser()!.displayName;
  String imageURL = '';
  LatLng getUserLocation = const LatLng(0, 0);
  String location = '';
  DateTime selectedDate = DateTime.now();
  String date = '';

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2024),
            lastDate: DateTime(2027))
        .then((value) {
      setState(() {
        selectedDate = value!;
        date =
            '${selectedDate.day.toString()},${selectedDate.month.toString()}';
      });
    });
  }

  void uploadToFirebase() async {
    Reference reference = FirebaseStorage.instance.ref();
    Reference referenceDir = reference.child('image');
    Reference referenceUpload = referenceDir.child(fileName);

    try {
      await referenceUpload.putFile(_selectedImage!);
      imageURL = await referenceUpload.getDownloadURL();
    } catch (e) {
      throw e.toString();
    }
  }

  bool value = false;
  void changeData() {
    setState(() {
      value = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Add Product'),
          ),
          body: Center(
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              children: [
                AppCurvedEdgeWidget(
                  child: Container(
                    color: Colors.grey,
                    child: Stack(
                      children: [
                        // Main Large Image
                        SizedBox(
                          height: 400,
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Center(
                                child: _selectedImage != null
                                    ? Image.file(_selectedImage!)
                                    : const Center(
                                        child: Text('No image is selected.'))),
                          ),
                        ),
                        Positioned(
                            bottom: 30,
                            right: 15,
                            child: ElevatedButton(
                                onPressed: () {
                                  showImagePickerOption(context);
                                },
                                child: const Icon(Icons.camera_enhance)))
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(36),
                          topRight: Radius.circular(36),
                        )),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          heightSpace25,
                          Text('Dish Name', style: color8ARegular15),
                          heightSpace8,
                          AuthTextField(
                            hintText: 'Enter the name of your dish',
                            controller: _nameController,
                          ),
                          heightSpace25,
                          Text('Additional Information',
                              style: color8ARegular15),
                          heightSpace8,
                          AuthTextField(
                            controller: _msgController,
                            hintText:
                                'Write here some description about the food, when did you cook and any other information...',
                            maxLines: 5,
                            textInputAction: TextInputAction.done,
                          ),
                          heightSpace25,
                          Text('Cooked date:', style: color8ARegular15),
                          const SizedBox(width: 10),
                          Text(
                              '${selectedDate.day.toString()}, ${selectedDate.month.toString()}'),
                          ElevatedButton(
                              onPressed: () {
                                _showDatePicker();
                              },
                              child: const Text('Select date')),
                          heightSpace25,
                          Text('Location', style: color8ARegular15),
                          heightSpace8,
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 237, 237, 239),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.grey.shade100, width: 2),
                            ),
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 50,
                            child: Center(
                                child: getUserLocation == const LatLng(0, 0)
                                    ? const Text('No location selected',
                                        style: TextStyle(
                                          color: Color(0xff8A9CBF),
                                          fontSize: 12,
                                        ))
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: Colors.red,
                                          ),
                                          Text(location),
                                        ],
                                      )),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CustomMaps()),
                                );
                                if (result != null &&
                                    result is ValueFromNavigator) {
                                  changeData();
                                  // Access the data from the result object
                                  getUserLocation = result.location;
                                  location = result.address!;
                                  print('Address: ${result.address}');
                                  print('Location: ${result.location}');
                                }
                              },
                              child: const Text('Add location')),
                          heightSpace30,
                          ElevatedButton(
                            child: const Text('Add product'),
                            onPressed: () async {
                              if (_msgController.text.isNotEmpty &&
                                  _nameController.text.isNotEmpty &&
                                  imageURL != '' &&
                                  getUserLocation != const LatLng(0, 0) &&
                                  location != '') {
                                await FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(_uid)
                                    .collection('active')
                                    .add({
                                  'title': _nameController.text,
                                  'description': _msgController.text,
                                  'name': _name,
                                  'email': _email,
                                  'lat': getUserLocation.latitude.toString(),
                                  'lng': getUserLocation.longitude.toString(),
                                  'location': location,
                                  'uid': _uid,
                                  'img': imageURL,
                                  'cooked_date': date,
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Success'),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please fill all required fields and select an image.'),
                                  ),
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
      uploadToFirebase();
      Navigator.pop(context);
    });
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
      uploadToFirebase();
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
