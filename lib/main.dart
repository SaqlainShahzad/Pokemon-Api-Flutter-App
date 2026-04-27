import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon_api/container_ui.dart';
import 'package:pokemon_api/demo.dart';
import 'package:pokemon_api/model.dart';

void main() {
  runApp(HomeScreen());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController numberController = TextEditingController();
  Future<Welcome>? pokemonData;

  Future<Welcome> getPokemonApi(String number) async {
    final response = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon/${numberController.text}'),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      return Welcome.fromJson(data);
    } else {
      throw Exception('Pokemon not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.light(),
      home: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          title: Text('Pokemon API', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 236, 182, 18),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: TextFormField(
                  controller: numberController,
                  enabled: true,
                  cursorColor: Colors.black,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: const Color.fromARGB(255, 41, 41, 41),
                    ),
                    hintText: 'Enter a number to see pokemon!',
                    filled: true,
                    fillColor: const Color.fromARGB(255, 245, 244, 244),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 236, 182, 18),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 236, 182, 18),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    pokemonData = getPokemonApi(numberController.text);
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    const Color.fromARGB(255, 236, 182, 18),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              pokemonData == null
                  ? Text('')
                  : FutureBuilder(
                    future: pokemonData,
                    builder: (context, snapshot) {
                      SizedBox(height: 10);
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final poke = snapshot.data!;
                        return Column(
                          children: [
                            Image.network(
                              poke.sprites.frontDefault ?? '',
                              height: 200,
                              width: 150,
                              fit: BoxFit.none,
                            ),
                            SizedBox(height: 10),
                            Text(
                              poke.name.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(poke.species.url.toString()),
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
