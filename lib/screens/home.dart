// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mausam/models/imgs.dart';
import 'package:mausam/models/weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var cityName = "";
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 24.0,
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter Your City Name Here',
                    hintText: 'City Name',
                    focusColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(
                      () {
                        isClicked = false;
                        cityName = value;
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isClicked = true;
                  });
                },
                child: Text(
                  'Submit!',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              FutureBuilder(
                future: isClicked ? getData(cityName) : null,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    num temp = double.parse('${snapshot.data!.main.temp}');
                    String temperature = (temp - 273.15).toStringAsFixed(2);
                    temp = double.parse(temperature);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'CITY NAME: ${snapshot.data!.name.toString().toUpperCase()}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                letterSpacing: 1,
                                wordSpacing: 1,
                              )),
                          SizedBox(height: 10),
                          Text('TEMPERATURE: $temperature \'C',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                letterSpacing: 1,
                                wordSpacing: 1,
                              )),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.all(8),
                            height: _size.height * .5,
                            width: _size.width * .5,
                            child: (double.parse(temperature) > 16)
                                ? (double.parse(temperature) < 27
                                    ? Image.asset(Images().cloudyImage)
                                    : Image.asset(Images().heatImage))
                                : Image.asset(Images().coldImage),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: _size.height * .2,
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                          strokeWidth: 2,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Weather> getData(var name) async {
  String url =
      'https://api.openweathermap.org/data/2.5/weather?q=$name&appid=5cd6413f5dce458ed0173c481488d44b';
  Response response = await http.get(Uri.parse(url));
  Map data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return Weather.fromJson(data);
  } else {
    throw Exception('No Found City!');
  }
}
