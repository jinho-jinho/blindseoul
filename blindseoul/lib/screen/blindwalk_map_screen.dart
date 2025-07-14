import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../api/blindwalk_api.dart';
import '../model/blindwalk_dto.dart';

class BlindwalkMapScreen extends StatefulWidget {
  @override
  _BlindwalkMapScreenState createState() => _BlindwalkMapScreenState();
}

class _BlindwalkMapScreenState extends State<BlindwalkMapScreen> {
  final Set<Polyline> _polylines = {};
  late GoogleMapController _mapController;
  final BlindwalkApi _api = BlindwalkApi();

  @override
  void initState() {
    super.initState();
    loadPolylines();
  }

  void loadPolylines() async {
    List<BlindwalkDto> locations = await _api.fetchNearbyBlindwalkLocations(
      userLat: 37.5665,   // 서울시청 임의 좌표
      userLon: 126.9780,
      radiusKm: 0.5,
    );

    Set<Polyline> newPolylines = {};

    for (var location in locations) {
      newPolylines.add(Polyline(
        polylineId: PolylineId('${location.sidewalkId}_${location.subId}'),
        color: Colors.blue,
        width: 4,
        points: [
          LatLng(location.latMin, location.lonMin),
          LatLng(location.latMax, location.lonMax),
        ],
      ));
    }

    setState(() {
      _polylines.clear();
      _polylines.addAll(newPolylines);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.5665, 126.9780), // 서울시청
          zoom: 14,
        ),
        markers: {}, // 마커 없이 빈 Set
        polylines: _polylines,
      ),
    );
  }
}
