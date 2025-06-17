import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:weather_forecast/daily_weather_card.dart';
import 'package:weather_forecast/daily_weather_data.dart';
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
  }

  String? location;
  final String key = '0f67d81607184f302913efa856997820';
  String unit = "metric";
  WeatherDataResponseModel? weatherLocationData;
  DailyWeatherDataResponse? dailyWeatherDataResponse;

  Future<void> getDevicePosition() async {
    devicePosition = await _determinePosition();
  }

  Future<Response?> getLocationDataFromApi() async {
    return get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$key&units=$unit',
      ),
    );
  }

  Future<Response?> getLocationDataFromApiByLatLon() async {
    if (devicePosition != null) {
      return await get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${devicePosition!.latitude}&lon=${devicePosition!.longitude}&appid=$key&units=$unit',
        ),
      );
    } else {
      return null;
    }
  }
  Future<Response?> getSelectedLocationWeatherData(
    double lat,
    double long,
  ) async {
    final response = await get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=$key&units=$unit',
      ),
    );
    return response;
  }

  Future<void> getInitialData() async {
    await getDevicePosition();
    await getLocationDataFromApiByLatLon().then((value) {
      if (value != null) {
        weatherLocationData = WeatherDataResponseModel.fromJson(
          json.decode(value.body),
        );
        setState(() {});
      }
    });
    if (devicePosition != null) {
      await getSelectedLocationWeatherData(
        devicePosition!.latitude,
        devicePosition!.longitude,
      ).then((value) {
        if (value != null) {
          dailyWeatherDataResponse = DailyWeatherDataResponse.fromJson(
            json.decode(value.body),
          );
          setState(() {});
        } else {
          return null;
        }
      });
    }
  }

  List<ForecastItem> getDailyForecasts(List<ForecastItem> fullList) {
    List<ForecastItem> dailyList = [];
    for (int i = 0; i < fullList.length; i += 8) {
      dailyList.add(fullList[i]);
    }
    return dailyList;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final dailyList =
        dailyWeatherDataResponse?.list != null
            ? getDailyForecasts(dailyWeatherDataResponse!.list!)
            : [];

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
                            child: Image.network(
                              'https://openweathermap.org/img/wn/${weatherLocationData?.weather?.firstOrNull?.icon}@2x.png',
                            ),
                          ),
                          Text(
                            "${(weatherLocationData!.main?.temp?.toStringAsFixed(0)) ?? ""}°C",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                weatherLocationData!.name ?? "",
                                style: TextStyle(
                                  color: Colors.white,
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
                                  await getLocationDataFromApi().then((value) {
                                    if (value != null) {
                                      weatherLocationData =
                                          WeatherDataResponseModel.fromJson(
                                            json.decode(value.body),
                                          );
                                    }
                                  });
                                  await getSelectedLocationWeatherData(
                                    weatherLocationData!.coord!.lat!,
                                    weatherLocationData!.coord!.lon!,
                                  ).then((value) {
                                    if (value != null) {
                                      dailyWeatherDataResponse =
                                          DailyWeatherDataResponse.fromJson(
                                            json.decode(value.body),
                                          );
                                    }
                                  });
                                  setState(() {});
                                },
                                icon: Icon(Icons.search, color: Colors.white,),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.15),
                          if (dailyWeatherDataResponse != null)
                            SizedBox(
                              height: size.height * 0.23,
                              width: size.width * 0.9,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: dailyList.length,
                                itemBuilder: (context, index) {
                                  return DailyWeatherCard(
                                    forecastItem: dailyList[index],
                                  );
                                },
                              ),
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
