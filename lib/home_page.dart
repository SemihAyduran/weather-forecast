import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:weather_forecast/search_page.dart';
import 'package:weather_forecast/weather_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? devicePosition;
  @override
  void initState() {
    getDevicePosition();
    getWeatherLocationData().then((value) {
      if (value != null) {
        weatherLocationData = WeatherDataResponseModel.fromJson(
          json.decode(value.body),
        );
        print(weatherLocationData);
        setState(() {});
      }
    });
    super.initState();
  }

  String location = 'Hatay';
  final String key = '0f67d81607184f302913efa856997820';
  String unit = "metric";
  WeatherDataResponseModel? weatherLocationData;

  Future<Response?> getWeatherLocationData() async {
    return get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$key&units=$unit',
      ),
    );
  }

  Future<void> getDevicePosition()async{
    devicePosition= await _determinePosition();
    print('$devicePosition');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/${getWeatherImagePath(weatherLocationData?.weather?.firstOrNull?.main ?? "home")}',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  weatherLocationData != null
                      ? Column(
                        children: [
                          Text(
                            "${(weatherLocationData!.main?.temp.toString()) ?? ""}°C",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                weatherLocationData!.name ?? "",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final selectedCity = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchPage(),
                                    ),
                                  );
                                  location = selectedCity;
                                  weatherLocationData = null;
                                  getWeatherLocationData().then((value) {
                                    if (value != null) {
                                      weatherLocationData =
                                          WeatherDataResponseModel.fromJson(
                                            json.decode(value.body),
                                          );
                                      print(weatherLocationData);
                                      setState(() {});
                                    }
                                  });
                                },
                                icon: Icon(Icons.search),
                              ),
                            ],
                          ),
                        ],
                      )
                      : CircularProgressIndicator(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
}

String getWeatherImagePath(String weatherStatus) {
  switch (weatherStatus) {
    case "Clouds":
      return "clouds.jfif";
    case "Clear":
      return "sunny.jfif";
    case "Atmosphere":
      return "atmosphere.jfif";
    case "Snow":
      return "snow.jfif";
    case "Rain":
      return "rain.jfif";
    case "Drizzle":
      return "drizzle.jfif";
    case "Thunderstorm":
      return "flash.jfif";
  }
  return "home.jfif";
}
