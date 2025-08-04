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
      Color polylineColor;
      if (location.brllBlkKndCode == 'BAI001') {
        polylineColor = Colors.blue; // 유도형
      } else if (location.brllBlkKndCode == 'BAI002') {
        polylineColor = Colors.red; // 경고형
      } else {
        polylineColor = Colors.grey; // 기타 (경고형으로 간주하는게 맞을 듯, 추후 필요시 수정)
      }

      newPolylines.add(Polyline(
        polylineId: PolylineId('${location.sidewalkId}_${location.subId}'),
        color: polylineColor,
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
          target: LatLng(37.5665, 126.9780),
          zoom: 14,
        ),
        markers: {}, // 마커 없음
        polylines: _polylines,
      ),
    );
  }
}
