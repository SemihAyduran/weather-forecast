import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String selectedCity = '';

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
        appBar: AppBar(backgroundColor: Colors.transparent),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(
                  onChanged: (value) {
                    selectedCity = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Şehir Seçiniz',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  style: TextStyle(color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,shadows: <Shadow>[Shadow(color: Colors.black54,blurRadius: 3,offset: Offset(2, 2))]
                              ),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  selectedCity = selectedCity.trim();
                  var response = await get(
                    Uri.parse(
                      'https://api.openweathermap.org/data/2.5/weather?q=$selectedCity&appid=0f67d81607184f302913efa856997820',
                    ),
                  );
                  
                  print(response.body);
                  if (response.statusCode == 200) {
                    
                    Navigator.pop(context, selectedCity);
                  } else {
                    _showMyDialog();
                  }
                },
                child:     Text('Select',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location not Found'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text('Pleas select a valid location')],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
