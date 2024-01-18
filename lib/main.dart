import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<Vacancy> vacancies = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/api/search'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)["data"];

      setState(() {
        vacancies = data.map((item) => Vacancy.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vacancies List'),
      ),
      body: vacancies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: vacancies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.flight),
                  title: Text(vacancies[index].title),
                  subtitle: Text('Company: ${vacancies[index].companyId}'),
                  trailing: const Icon(Icons.more_vert),
                  visualDensity:
                      const VisualDensity(horizontal: 4, vertical: 4),
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Color(0xFFECECEC), width: 1),
                      borderRadius: BorderRadius.circular(4)),
                  onTap: () {
                    // Handle tap event if needed
                  },
                );
              },
            ),
    );
  }
}

class Vacancy {
  final String publicId;
  final String title;
  final String originalUrl;
  final String expiresAt;
  final int companyId;

  Vacancy({
    required this.publicId,
    required this.title,
    required this.originalUrl,
    required this.expiresAt,
    required this.companyId,
  });

  factory Vacancy.fromJson(Map<String, dynamic> json) {
    return Vacancy(
      publicId: json['public_id'],
      title: json['title'],
      originalUrl: json['original_url'],
      expiresAt: json['expires_at'],
      companyId: json['company_id'],
    );
  }
}
