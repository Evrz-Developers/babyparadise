import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class Env {
  static String apiUrl = "https://marginpoint.pythonanywhere.com/api/v1/shop/";
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Margin-Point',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Margin-Point'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('${Env.apiUrl}product/'));

      if (response.statusCode == 200) {
        List<dynamic> products = json.decode(response.body);
        setState(() {
          _products = List<Map<String, dynamic>>.from(products);
        });
      } else {
        showCustomDialog(
          context,
          'Failed to load products',
          'Status code: ${response.statusCode}',
        );
      }
    } catch (error) {
      showCustomDialog(
        context,
        'No internet',
        'Check your internet connection and try again.',
      );
    }
  }

  Future<void> _refreshData() async {
    await _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                'Products',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                          title: Text(_products[index]['name']),
                          subtitle: Text(
                              'Price: ${_products[index]['retail_price']}'),
                          onTap: () {
                            String productName = _products[index]['name'];
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.blueGrey,
                                content: Text(
                                    'Product: "$productName", but detail page: 404!'),
                              ),
                            );
                            print('tapped $productName');
                          }
                          // You can customize this further based on your UI requirements
                          ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showCustomDialog(BuildContext context, String title, String content) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
