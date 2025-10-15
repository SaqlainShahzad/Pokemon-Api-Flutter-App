import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyIdea extends StatelessWidget {
  const MyIdea({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PokemonListScreen(),
    );
  }
}

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  List pokemons = [];

  void fetchApi() async {
    final response = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=50'),
    );
    var data = jsonDecode(response.body);
    setState(() {
      pokemons = data['results'];
    });
  }

  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text('Pokemon Viewer', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/saqlain.jpg'),
              radius: 24,
            ),
          ),
        ],
      ),
      drawer: Drawer(),
      body:
          pokemons.isEmpty
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
                padding: EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3.7 / 4,
                ),
                itemCount: pokemons.length,
                itemBuilder: (BuildContext context, int index) {
                  String pokeName = pokemons[index]['name'];
                  String imageUrl =
                      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${index + 1}.png';
                  return Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Detail(
                                name: pokeName,
                                imageUrl: imageUrl,
                                url: pokemons[index]['url'],
                              );
                            },
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: const Color.fromARGB(255, 243, 239, 239),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Hero(
                                tag: imageUrl,
                                child: Image.network(
                                  imageUrl,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.error),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              pokeName.toString().toUpperCase(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}

class Detail extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String url;
  const Detail({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.url,
  });

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  List abilities = [];
  double? height;
  double? weight;

  void fetchDetails() async {
    final response = await http.get(Uri.parse(widget.url));
    var data = jsonDecode(response.body);
    setState(() {
      abilities = data['abilities'];
      height = data['height'];
      weight = data['weight'];
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name.toUpperCase()),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Hero(
                tag: widget.imageUrl,
                child: Image.network(
                  widget.imageUrl,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.name.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  info('Height', height.toString()),
                  info('Weight', weight .toString()),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Abilities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            Column(
              children:
                  abilities.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.flash_on),
                          SizedBox(width: 20),
                          Text(
                            item['ability']['name'].toString().toUpperCase(),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

Widget info(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text(
          '$title: ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(value, style: TextStyle(fontSize: 18)),
      ],
    ),
  );
}
