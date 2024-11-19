import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maps_app/models/place_model.dart';
import 'package:maps_app/utils/location_service.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;
  late LocationService locationService;

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
      zoom: 9,
      target: LatLng(
        30.04579301491868,
        31.235801953442753,
      ),
    );
    locationService = LocationService();
    updateMyLocation();
    super.initState();
  }

  bool isFirstCall = true;
  Set<Marker> markers = {};
  late GoogleMapController? googleMapController;
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: markers,
      onMapCreated: (controller) {
        googleMapController = controller;
        initMapStyle();
      },
      initialCameraPosition: initialCameraPosition,
      //zoomControlsEnabled: false,
    );
  }

  void initMapStyle() async {
    var nightMapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/night_map_style.json');
    googleMapController!.setMapStyle(nightMapStyle);
  }

  void initMarker() async {
    // var customMarkerIcon = BitmapDescriptor.fromBytes(
    //   await getImageFromRawData(
    //     'assets/images/kindpng_235716.png',
    //     60,
    //   ),
    // );

    var customMarkerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/images/marker.png');

    var myMarkers = places
        .map(
          (placeModel) => Marker(
            infoWindow: InfoWindow(
              title: placeModel.name,
            ),
            icon: customMarkerIcon,
            position: placeModel.latLng,
            markerId: MarkerId(
              placeModel.id.toString(),
            ),
          ),
        )
        .toSet();
    markers.addAll(myMarkers);
    setState(() {});
  }

  void updateMyLocation() async {
    await locationService.checkAndRequestLocationService();
    var hasPermission =
        await locationService.checkAndRequestLocationPermission();
    if (hasPermission) {
      locationService.getRealTimeLocationData((locationData) {
        setMyLocationMarker(locationData);
        updateCamera(locationData);
      });
    } else {}
  }

  void updateCamera(LocationData locationData) {
    if (isFirstCall) {
      var cameraPosition = CameraPosition(
        target: LatLng(locationData.latitude!, locationData.longitude!),
        zoom: 17,
      );
      googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );
      isFirstCall = false;
    } else {
      googleMapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(locationData.latitude!, locationData.longitude!),
        ),
      );
    }
  }

  void setMyLocationMarker(LocationData locationData) {
    var myLocationMarker = Marker(
      markerId: const MarkerId('my location'),
      position: LatLng(locationData.latitude!, locationData.longitude!),
    );
    markers.add(myLocationMarker);
    setState(() {});
  }
}
