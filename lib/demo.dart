import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  List<String> items = ['Flutter', 'Dart', 'React', 'Vu', 'Angular'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home Screen'),
          backgroundColor: Colors.amber,
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            String item = items[index];
            return ListTile(
              title: Text('$index) $item'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(name: item),
                  ),
                );
              },
            );
          },
          itemCount: items.length,
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String name;
  const DetailScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name), backgroundColor: Colors.amber),
      body: Center(child: Text(name, style: TextStyle(fontSize: 60))),
    );
  }
}
