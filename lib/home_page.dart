import 'package:flutter/material.dart';
import 'package:weather_forecast/search_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = 'Ankara';
  double temperature = 25.0;
  final String key = '0f67d81607184f302913efa856997820';
  var weatherLocationData;

  Future<void> getWeatherLocationData() async {
    weatherLocationData = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q={$location}&appid={$key}',
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
              ElevatedButton(
                onPressed: () async {
                  print(
                    'getWeatherLocationData çağırılmadan önce $weatherLocationData',
                  );
                 await getWeatherLocationData();
                  // Future.delayed(
                  //   Duration(seconds: 3),
                  //   () => print(
                  //     'getWeatherLocationData çağırıldıktan sonra $weatherLocationData',
                  //   ),
                  // );
                },
                child: Text('getWeatherLocationData'),
              ),
              Text(
                '$temperature°C',
                style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(location, style: TextStyle(fontSize: 30)),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage()),
                      );
                    },
                    icon: Icon(Icons.search),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
