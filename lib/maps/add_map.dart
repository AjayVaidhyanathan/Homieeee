import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homieeee/maps/style/map_style.dart';


class CustomMaps extends StatefulWidget {
  const CustomMaps({super.key});

  @override
  State<CustomMaps> createState() => _CustomMapsState();
}

class _CustomMapsState extends State<CustomMaps> {
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(51.1657, 10.4515),
    zoom: 5,
  );
  // ignore: unused_field
  GoogleMapController? _mapController;
  final Set<Circle> _circles = <Circle>{};
  final Map<String, Marker> _markers = {};
  late LatLng currentLatLng;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Add Position')),
        body: Stack(
          children: [
            _buildGoogleMap(),
            _buildAddLocationButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      myLocationButtonEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: _initialCameraPosition,
      zoomControlsEnabled: true,
      markers: _markers.values.toSet(),
      circles: _circles,
      onTap: _onTap,
      onCameraMove: (_) {},
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        _mapController?.setMapStyle(Maptheme().mapThemes[0]['style']);
        setState(() => _circles.clear());
      },
    );
  }

  void _onTap(LatLng? latLng) async {
    if (latLng == null) return;
    final BitmapDescriptor? customIcon = await _getAssetIcon(context);
    if (customIcon == null) return;

    final marker = _buildMarker(customIcon, latLng);
    final circle = _buildCircle(latLng);

    setState(() {
      _markers.clear();
      _markers[marker.markerId.value] = marker;
      currentLatLng = latLng;
      _circles.clear();
      _circles.add(circle);
    });
  }

  Marker _buildMarker(BitmapDescriptor icon, LatLng position) {
    return Marker(
      draggable: true,
      icon: icon,
      markerId: MarkerId(position.toString()),
      position: position,
    );
  }

  Circle _buildCircle(LatLng position) {
    return Circle(
      consumeTapEvents: true,
      circleId: CircleId(position.toString()),
      center: position,
      radius: 300.0,
      fillColor: Colors.green.shade500.withOpacity(.5),
      strokeColor: Colors.green.shade700.withOpacity(.7),
      strokeWidth: 5,
    );
  }

  Widget _buildAddLocationButton(BuildContext context) {
    return Positioned(
      top: 16.0,
      right: 16.0,
      child: ElevatedButton(
        onPressed: () async => _navigateWithLocation(context),
        child: const Text('Add Location'),
      ),
    );
  }

  Future<void> _navigateWithLocation(BuildContext context) async {
    final Placemark placemark =
        await _getPlacemarkFromCoordinates(currentLatLng);
    final String address = _buildAddress(placemark);
    Navigator.pop(
        context, ValueFromNavigator(address: address, location: currentLatLng));
  }

  Future<Placemark> _getPlacemarkFromCoordinates(LatLng coordinates) async {
    return (await placemarkFromCoordinates(
            coordinates.latitude, coordinates.longitude))
        .first;
  }

  String _buildAddress(Placemark placemark) =>
      '${placemark.postalCode}, ${placemark.locality}';
}

// This function asynchronously loads a marker icon from an asset
// This is done by first creating a Completer to be used for returning the result
// An ImageConfiguration is created, this is used to configure how the image is loaded
// An AssetImage is created, this is used to specify the path to the asset
// The asset image is then resolved, this starts the loading process of the image
// An ImageStreamListener is added to the image stream, this is used to listen for
// when the image is finished loading
// When the image is finished loading, the ByteData of the image is loaded
// A BitmapDescriptor is created from the byte data
// The Completer is completed with the BitmapDescriptor
// The Completer's future is returned

Future<BitmapDescriptor> _getAssetIcon(BuildContext context) async {
  // Create a Completer for returning the result
  final Completer<BitmapDescriptor> bitmapIcon = Completer<BitmapDescriptor>();

  // Create an ImageConfiguration, used to configure how the image is loaded
  final ImageConfiguration config =
      createLocalImageConfiguration(context, size: const Size(5, 5));

  // Create an AssetImage, used to specify the path to the asset
  const AssetImage('assets/icons/marker.png')
      .resolve(config)
      // Add an ImageStreamListener to listen for when the image is finished loading
      .addListener(ImageStreamListener((ImageInfo image, bool sync) async {
    // Load the ByteData of the image
    final ByteData? bytes =
        await image.image.toByteData(format: ImageByteFormat.png);

    // Create a BitmapDescriptor from the byte data
    final BitmapDescriptor bitmap =
        BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());

    // Complete the Completer with the BitmapDescriptor
    bitmapIcon.complete(bitmap);
  }));

  // Return the Completer's future
  return await bitmapIcon.future;
}

class ValueFromNavigator {
  String? address;
  LatLng location;

  ValueFromNavigator({
    required this.address,
    required this.location,
  });
}
