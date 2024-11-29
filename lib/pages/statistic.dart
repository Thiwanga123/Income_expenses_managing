import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pie_chart/pie_chart.dart';

class StatisticsExpense extends StatefulWidget {
  @override
  _StatisticsExpenseState createState() => _StatisticsExpenseState();
}

class _StatisticsExpenseState extends State<StatisticsExpense> {
  late List<Expense> _expense = [];
  late List<Expense> _income = [];

  // Function to calculate category data for expenses and income
  Map<String, double> getCategoryData(List<Expense> transactions) {
    Map<String, double> catMap = {};
    for (var item in transactions) {
      if (!catMap.containsKey(item.title)) {
        catMap[item.title] = 1;
      } else {
        catMap.update(item.title, (_) => catMap[item.title]! + 1);
      }
    }
    return catMap;
  }

  List<Color> colorList = [
    Color.fromRGBO(82, 98, 255, 1),
    Color.fromRGBO(46, 198, 255, 1),
    Color.fromRGBO(123, 201, 82, 1),
    Color.fromRGBO(255, 171, 67, 1),
    Color.fromRGBO(252, 91, 57, 1),
    Color.fromRGBO(139, 135, 130, 1),
  ];

  // Function to display a pie chart with a unique key
  Widget buildPieChart(String centerText, List<Expense> transactions, Key chartKey) {
    return PieChart(
      key: chartKey, // Pass the unique key here
      dataMap: getCategoryData(transactions),
      initialAngleInDegree: 0,
      animationDuration: Duration(milliseconds: 2000),
      chartType: ChartType.ring,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      ringStrokeWidth: 32,
      colorList: colorList,
      chartLegendSpacing: 32,
      chartValuesOptions: ChartValuesOptions(
        showChartValuesOutside: true,
        showChartValuesInPercentage: true,
        showChartValueBackground: true,
        showChartValues: true,
        chartValueStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      centerText: centerText,
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        showLegends: true,
        legendShape: BoxShape.rectangle,
        legendPosition: LegendPosition.right,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> expStream = FirebaseFirestore.instance.collection('Transaction history').snapshots();

    // Function to categorize expenses and income from Firestore snapshot
    void getExpAndIncomeFromSnapshot(AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
        _expense = [];
        _income = [];
        for (var doc in snapshot.data!.docs) {
          Expense exp = Expense.fromJson(doc.data() as Map<String, dynamic>);
          if (exp.type == "expense") {
            _expense.add(exp);
          } else if (exp.type == "income") {
            _income.add(exp);
          }
        }
      }
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            StreamBuilder<QuerySnapshot>(
              stream: expStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                getExpAndIncomeFromSnapshot(snapshot);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Income and Expence Statistic",
                    style:TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.blue)
                    ),
                    SizedBox( height: 20),
                    Text(
                      "Expense Breakdown",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400,color:Colors.blue),
                    ),
                    buildPieChart("Expenses", _expense, ValueKey("expense_chart")),
                    SizedBox(height: 20),
                    Text(
                      "Income Breakdown",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400,color: Colors.blue),
                    ),
                    SizedBox(height: 30),
                    buildPieChart("Income", _income, ValueKey("income_chart")),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Expense {
  String amount;
  String subtitle;
  String title;
  String type;

  Expense({
    required this.amount,
    required this.subtitle,
    required this.title,
    required this.type,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      amount: json['amount'],
      subtitle: json['subtitle'],
      title: json['title'],
      type: json['type'],
    );
  }
}
