import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

void birFonksiyon(){
  print('çalıştı');
}

@override 
  void initState() {
print('initState çalıştı ve gps verisi isteniyor');
    super.initState();
  }

  @override
  void dispose() {
    // sayfa kaldırılırken run edilecek metotlar
    print('dispose metodu çalıştı ve logout istendi ');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
birFonksiyon();

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/search.jfif'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent,),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(decoration: InputDecoration(hintText: 'Şehir Seçiniz', border: OutlineInputBorder(borderSide: BorderSide.none)),
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {setState(() {
          
        });
          
        },),
      ),
    );
  }
}
