import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock App',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<double> prices = [];
  List<double> forecast = [];
  String symbol = "RELIANCE.NS";

  Future<void> fetchStock() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/stock?symbol=$symbol'),
    );

    final data = json.decode(response.body);
    setState(() {
      prices = List<double>.from(data['prices']);
    });
  }

  Future<void> fetchPrediction() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/predict?symbol=$symbol'),
    );

    final data = json.decode(response.body);
    setState(() {
      forecast = List<double>.from(data['forecast']);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchStock();
    fetchPrediction();
  }

  List<FlSpot> getSpots(List<double> data) {
    return data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stock Analysis")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),

            Text("Stock: $symbol", style: TextStyle(fontSize: 18)),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Enter Stock (e.g. TCS.NS)",
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  symbol = value;
                  fetchStock();
                  fetchPrediction();
                },
              ),
            ),

            SizedBox(height: 20),

            Text("Price Chart"),
            Container(
              height: 200,
              padding: EdgeInsets.all(10),
              child: prices.isEmpty
                  ? CircularProgressIndicator()
                  : LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: getSpots(prices),
                          )
                        ],
                      ),
                    ),
            ),

            SizedBox(height: 20),

            Text("7-Day Prediction"),
            Container(
              height: 200,
              padding: EdgeInsets.all(10),
              child: forecast.isEmpty
                  ? CircularProgressIndicator()
                  : LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: getSpots(forecast),
                          )
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}