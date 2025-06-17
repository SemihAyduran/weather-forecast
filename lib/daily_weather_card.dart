import 'package:flutter/material.dart';
import 'package:weather_forecast/daily_weather_data.dart';

class DailyWeatherCard extends StatelessWidget {
  const DailyWeatherCard({super.key, required this.forecastItem});

  final ForecastItem forecastItem;

  @override
  Widget build(BuildContext context) {
    final DateTime ts = DateTime.fromMillisecondsSinceEpoch(
      forecastItem.dt! * 1000,
    );
    return Card(
      color: Colors.transparent,
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            Image.network(
              'https://openweathermap.org/img/wn/${forecastItem.weather?[0].icon}@2x.png',
            ),
            Text(
              "${(forecastItem.main?.temp.toStringAsFixed(0))}°C",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
            Text(
              '${ts.hour}:${ts.minute}  ${ts.day}/${ts.month}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
