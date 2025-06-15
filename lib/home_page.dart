import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:weather_forecast/daily_weather_card.dart';
import 'package:weather_forecast/weather_image_path.dart';
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
    getInitialData();
    super.initState();

    // getLocationDataFromApi().then((value) {
    //   if (value != null) {
    //     weatherLocationData = WeatherDataResponseModel.fromJson(
    //       json.decode(value.body),
    //     );
    //     print(weatherLocationData);
    //     setState(() {});
    //   }
    // });
    // super.initState();
  }

  String location = 'Hatay';
  final String key = '0f67d81607184f302913efa856997820';
  String unit = "metric";
  WeatherDataResponseModel? weatherLocationData;

  Future<Response?> getLocationDataFromApi() async {
    return get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$key&units=$unit',
      ),
    );
  }

  Future<Response?> getLocationDataFromApiByLatLon() async {
    if (devicePosition != null) {
      return get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${devicePosition!.latitude}&lon=${devicePosition!.longitude}&appid=$key&units=$unit',
        ),
      );
    } else {
      return get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$key&units=$unit',
        ),
      );
    }
  }

  Future<void> getDevicePosition() async {
    devicePosition = await _determinePosition();
    print('$devicePosition');
  }

  void getInitialData() async {
    await getDevicePosition();
    getLocationDataFromApiByLatLon().then((value) {
      if (value != null) {
        weatherLocationData = WeatherDataResponseModel.fromJson(
          json.decode(value.body),
        );
        print(weatherLocationData);
        setState(() {});
      }
    });
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
                          SizedBox(
                            height: 100,
                            child: Image.network('https://openweathermap.org/img/wn/${weatherLocationData?.weather?.firstOrNull?.icon}@2x.png'),),
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
                                  getLocationDataFromApi().then((value) {
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
                          SizedBox(height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.9,
                            child: ListView(
                              
                              scrollDirection: Axis.horizontal,
                              children: [
                              DailyWeatherCard(weatherLocationData: weatherLocationData,),
                              DailyWeatherCard(weatherLocationData: weatherLocationData,),
                              DailyWeatherCard(weatherLocationData: weatherLocationData,),
                              DailyWeatherCard(weatherLocationData: weatherLocationData,),
                              DailyWeatherCard(weatherLocationData: weatherLocationData,),
                            ],),
                          )
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
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    return await Geolocator.getCurrentPosition();
  }
}
