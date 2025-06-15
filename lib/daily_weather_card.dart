import 'package:flutter/material.dart';
import 'package:weather_forecast/weather_data.dart';

class DailyWeatherCard extends StatelessWidget {
  const DailyWeatherCard({super.key, this.weatherLocationData});

  final WeatherDataResponseModel? weatherLocationData;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      child: SizedBox(
        width: 70,
        child: Column(
          children: [
            Image.network(
              'https://openweathermap.org/img/wn/${weatherLocationData?.weather?.firstOrNull?.icon}@2x.png',
            ),
            Text(
              "${(weatherLocationData?.main?.temp.toString()) ?? ""}°C",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Cuma',style: TextStyle(color: Colors.black87,fontSize: 15,
                fontWeight: FontWeight.bold,))
          ],
        ),
      ),
    );
  }
}
