import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:weather_forecast/search_page.dart';
import 'package:weather_forecast/weather_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
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

  String location = 'Hakkari';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/home.jfif'),
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
                            "${(weatherLocationData!.main?.temp.toString())  ?? ""}°C",
                            style: TextStyle(
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                weatherLocationData!.name ?? "",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchPage(),
                                    ),
                                  );
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
}
