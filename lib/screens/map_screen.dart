import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const MAPBOX_ACCESS_TOKEN =
     'pk.eyJ1IjoieWFzc3Nzc21pbmkiLCJhIjoiY2xzNGljdWZrMDM2eTJxbnhkMGV4NHc5bSJ9.c5MOw_0w9H5udyE9XffaBQ';


class ParkingLocation {
  LatLng coordinates;
  int totalSpaces;
  int occupiedSpaces;
  String name;

  ParkingLocation({
    required this.coordinates,
    required this.name,
    required this.totalSpaces,
    required this.occupiedSpaces,
  });
}

class MapScreen extends StatefulWidget {
  final token;
  const MapScreen({@required this.token,Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? myPosition;
  String occupiedSpace = '5';
  bool isBoxVisible = false;
  LatLng? tappedLocation;
  int selectedDestinationIndex = -1;

  List<ParkingLocation> markerLocations = [
    ParkingLocation(
      //Clz ko location
      coordinates: LatLng(27.680818, 85.325918),
      name:'Lalitpur Engineering College',
      totalSpaces: 50,
      occupiedSpaces: 0,
    ),
    ParkingLocation(
      coordinates: LatLng(27.680127, 85.324613),
      name:'Shakya Colony',
      totalSpaces: 80,
      occupiedSpaces: 20,
    ),
    ParkingLocation(
      coordinates: LatLng(27.681699, 85.324556),
      name:'Pulchowk Hostel Parking',
      totalSpaces: 60,
      occupiedSpaces: 25,
    ),
    ParkingLocation(
      coordinates: LatLng(27.680351, 85.323623),
      name:'Pulchowk Community Parking',
      totalSpaces: 45,
      occupiedSpaces: 45,
    ),
  ];

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    try {
      Position position = await determinePosition();
      setState(() {
        myPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      setState(() {
        myPosition = LatLng(27.680819, 85.325048);
      });
    }
  }
  void getData() async {
    try {
        //replace your restFull API here.
        String url = "http://192.168.10.67:3001/getdata1";
        final response = await http.get(Uri.parse(url));
        var responseData = jsonDecode(response.body);
        occupiedSpace = responseData['occupied'];
      }

    catch (e) {}
  }
  @override
  void initState() {
    getCurrentLocation();
    getData();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('We Park'),
        backgroundColor: const Color.fromARGB(255, 17, 235, 126),
      ),
      body: Stack(
        children: [
          myPosition == null
              ? const CircularProgressIndicator()
              : FlutterMap(
                  options: MapOptions(
                    center: myPosition,
                    minZoom: 1,
                    maxZoom: 125,
                    zoom: 18,
                  ),
                  nonRotatedChildren: [
                    TileLayer(
                      urlTemplate:
                          'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                      additionalOptions: const {
                        'accessToken': MAPBOX_ACCESS_TOKEN,
                        'id': 'mapbox/streets-v12',
                      },
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: myPosition!,
                          builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  isBoxVisible = true;
                                  tappedLocation = myPosition;
                                  selectedDestinationIndex = -1;
                                });
                              },
                              child: const Icon(
                                Icons.location_pin,
                                color: Color.fromARGB(255, 189, 44, 24),
                                size: 40,
                              ),
                            );
                          },
                        ),
                        for (int i = 0; i < markerLocations.length; i++)
                          Marker(
                            point: markerLocations[i].coordinates,
                            builder: (context) {
                              return GestureDetector(
                                onTap: () {
                                  getData();
                                  setState(() {
                                    isBoxVisible = true;
                                    tappedLocation =
                                        markerLocations[i].coordinates;
                                    selectedDestinationIndex = i;
                                  });
                                },
                                child: Container(
                                  child: Icon(
                                    Icons.local_parking,
                                    color: selectedDestinationIndex == i
                                        ? Colors.redAccent
                                        : Colors.green,
                                    size: 30,
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ],
                ),
          if (isBoxVisible)
            Positioned(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isBoxVisible = false;
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Name: ${markerLocations[selectedDestinationIndex].name}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Total capacity: ${markerLocations[selectedDestinationIndex].totalSpaces}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Occupied: ${occupiedSpace}',
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          'Available: ${markerLocations[selectedDestinationIndex].totalSpaces - int.parse(occupiedSpace)}',
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.cyan,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
