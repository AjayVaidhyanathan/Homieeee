import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homieeee/maps/style/map_style.dart';
import 'package:homieeee/widgets/product_details.dart';

class FirebaseMarkersMap extends StatefulWidget {
  const FirebaseMarkersMap({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FirebaseMarkersMapState createState() => _FirebaseMarkersMapState();
}

class _FirebaseMarkersMapState extends State<FirebaseMarkersMap> {
  late GoogleMapController _controller;
  final Set<Marker> _markers = {};
  late BitmapDescriptor customIcon;
  final Set<Circle> _circles = <Circle>{};
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapToolbarEnabled: false,
            initialCameraPosition: const CameraPosition(
              target: LatLng(51.1657, 10.4515), // Center of Germany
              zoom: 6.0, // Zoom level to show the whole country
            ),
            onMapCreated: (GoogleMapController controller) async {
              customIcon = await _getAssetIcon(context);
              _controller = controller;
              _controller.setMapStyle(Maptheme().mapThemes[0]['style']);
              _customInfoWindowController.googleMapController = controller;
              // Call a method to fetch markers from Firestore and add them to the map
              fetchMarkersFromFirestore();
            },
            onTap: (LatLng latLng) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            markers: _markers,
            circles: _circles,
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width * 0.8,
            offset: 50,
          ),
        ],
      ),
    );
  }

  // Method to fetch markers from Firestore and add them to the map
  Future<void> fetchMarkersFromFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore.collectionGroup('active').get();

    for (var doc in querySnapshot.docs) {
      final latitude = double.parse(doc.get('lat'));
      final longitude = double.parse(doc.get('lng'));
      final title = doc.get('title');
      final imageUrl = doc.get('img');
      final description = doc.get('description');
      final address = doc.get('location');
      final name = doc.get('name');
      final uid = doc.get('uid');
      final productID = doc.id;

      final userDoc = await firestore.collection('Users').doc(uid).get();
      final photoUrl = userDoc.get('img');

      final details = MarkerDetails(
        title: title,
        imageUrl: imageUrl,
        description: description,
        location: '($latitude, $longitude)',
        name: name,
        uid: uid,
        productID: productID,
        photoURL: photoUrl,
        address: address,
      );

      addMarkerToMap(LatLng(latitude, longitude), details);
      addCircleToMap(LatLng(latitude, longitude));
    }
  }

  // Method to add a marker to the map
  void addMarkerToMap(LatLng position, MarkerDetails details) {
    setState(() {
      // Add a marker to the set of markers
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          icon: customIcon,
          onTap: () {
            _zoomInOnMarker(position);
            _customInfoWindowController.addInfoWindow!(
                CustomInfoWindows(
                  title: details.title,
                  imageUrl: details.imageUrl,
                  description: details.description,
                  location: details.location,
                  name: details.name,
                  uid: details.uid,
                  productID: details.productID,
                  address: details.address,
                  photoURL: details.photoURL,
                ),
                position);
          },
          // You can customize other properties of the marker here
          // For example, icon, infoWindow, etc.
        ),
      );
    });
  }

  void addCircleToMap(LatLng position) {
    setState(() {
      _circles.add(
        Circle(
          circleId: CircleId(position.toString()),
          center: position,
          radius: 300.0,
          fillColor: Colors.green.shade500.withOpacity(.5),
          strokeColor: Colors.green.shade700.withOpacity(.7),
          strokeWidth: 5,
        ),
      );
    });
  }

  void _zoomInOnMarker(LatLng position) {
    // Zoom in on the tapped marker
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 14.0, // Adjust the zoom level as needed
        ),
      ),
    );
  }
}

Future<BitmapDescriptor> _getAssetIcon(BuildContext context) async {
  final Completer<BitmapDescriptor> bitmapIcon = Completer<BitmapDescriptor>();
  final ImageConfiguration config =
      createLocalImageConfiguration(context, size: const Size(5, 5));

  const AssetImage('assets/icons/marker.png')
      .resolve(config)
      .addListener(ImageStreamListener((ImageInfo image, bool sync) async {
    final ByteData? bytes =
        await image.image.toByteData(format: ImageByteFormat.png);
    final BitmapDescriptor bitmap =
        BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
    bitmapIcon.complete(bitmap);
  }));

  return await bitmapIcon.future;
}

class CustomInfoWindows extends StatelessWidget {
  const CustomInfoWindows(
      {super.key,
      required this.title,
      required this.productID,
      required this.imageUrl,
      required this.description,
      required this.location,
      required this.name,
      required this.uid,
      required this.address,
      required this.photoURL});

  final String title;
  final String imageUrl;
  final String description;
  final String location;
  final String name;
  final String uid;
  final String productID;
  final String address;
  final String photoURL;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(13.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                title,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                title,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(
                height: 8,
              ),
              MaterialButton(
                onPressed: () {
                  Get.to(() => ProductDetails(
                        title: title,
                        photoURL: photoURL,
                        address: address,
                        img: imageUrl,
                        description: description,
                        location: location,
                        name: name,
                        uid: uid,
                        productID: productID,
                      ));
                },
                elevation: 0,
                height: 40,
                minWidth: double.infinity,
                color: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text(
                  "See details",
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class MarkerDetails {
  final String title;
  final String imageUrl;
  final String description;
  final String location;
  final String name;
  final String uid;
  final String productID;
  final String address;
  final String photoURL;

  MarkerDetails({
    required this.productID,
    required this.description,
    required this.name,
    required this.location,
    required this.uid,
    required this.title,
    required this.imageUrl,
    required this.address,
    required this.photoURL,
  });
}
