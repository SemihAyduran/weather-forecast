import 'package:flutter/material.dart';
import 'package:weather_forecast/daily_weather_data.dart';

class DailyWeatherCard extends StatelessWidget {
  const DailyWeatherCard({super.key, required this.forecastItem});

  final ForecastItem forecastItem;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    List<String> weekDays = [
      'Pazartesi',
      'Salı',
      'Çarşamba',
      'Perşembe',
      'Cuma',
      'Cumartesi',
      'Pazar',
    ];
    final DateTime ts = DateTime.fromMillisecondsSinceEpoch(
      forecastItem.dt! * 1000,
    );
    String weekday = weekDays[ts.weekday - 1];
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
                shadows: <Shadow>[
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 3,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  '$weekday',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    shadows: <Shadow>[
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 3,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                // Text(
                //   '${ts.hour}:${ts.minute.toString().padLeft(2, '0')}',
                //   style: TextStyle(color: Colors.white, fontSize: 15),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
