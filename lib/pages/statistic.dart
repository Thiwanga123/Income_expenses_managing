import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:income_expenses_managing/widget/chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_core/firebase_core.dart';
 // Import your new chart widget

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final List<String> day = ['Day', 'Week', 'Month', 'Year'];
  List<QueryDocumentSnapshot> transactions = [];
  int indexColor = 0;
  List<SalesData> chartData = [];

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Transaction history')
          .get();

      setState(() {
        transactions = snapshot.docs;
        updateChartData(); // Update the chart data after fetching transactions
      });
    } catch (e) {
      print('Error fetching transactions: $e');
    }
  }

  void updateChartData() {
    chartData.clear();
    DateTime now = DateTime.now();

    for (var transaction in transactions) {
      var transactionData = transaction.data() as Map<String, dynamic>;
      DateTime transactionDate = DateTime.parse(transactionData['subtitle']);
      int amount = int.tryParse(transactionData['amount']) ?? 0;

      switch (indexColor) {
        case 0: // Day
          if (transactionDate.year == now.year &&
              transactionDate.month == now.month &&
              transactionDate.day == now.day) {
            chartData.add(SalesData(transactionDate.hour.toString(), amount));
          }
          break;
        case 1: // Week
          if (isSameWeek(transactionDate, now)) {
            chartData.add(SalesData(transactionDate.weekday.toString(), amount));
          }
          break;
        case 2: // Month
          if (transactionDate.year == now.year &&
              transactionDate.month == now.month) {
            chartData.add(SalesData(transactionDate.day.toString(), amount));
          }
          break;
        case 3: // Year
          if (transactionDate.year == now.year) {
            chartData.add(SalesData(transactionDate.month.toString(), amount));
          }
          break;
      }
    }

    chartData = groupAndSumData(chartData);
    setState(() {});
  }

  bool isSameWeek(DateTime date1, DateTime date2) {
    int week1 = (date1.year - 1970) * 52 + (date1.difference(DateTime(date1.year, 1, 1)).inDays + date1.weekday) ~/ 7;
    int week2 = (date2.year - 1970) * 52 + (date2.difference(DateTime(date2.year, 1, 1)).inDays + date2.weekday) ~/ 7;
    return week1 == week2;
  }

  List<SalesData> groupAndSumData(List<SalesData> data) {
    Map<String, int> groupedData = {};
    for (var sales in data) {
      if (groupedData.containsKey(sales.xValue)) {
        groupedData[sales.xValue] = (groupedData[sales.xValue] ?? 0) + sales.amount;
      } else {
        groupedData[sales.xValue] = sales.amount;
      }
    }

    return groupedData.entries
        .map((entry) => SalesData(entry.key, entry.value))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Statistics',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ...List.generate(
                          day.length,
                          (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  indexColor = index;
                                  updateChartData(); // Update the chart data based on the selected index
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: indexColor == index
                                      ? Color.fromARGB(255, 47, 125, 121)
                                      : Colors.white,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  day[index],
                                  style: TextStyle(
                                    color: indexColor == index
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Use the ChartWidget here
                  ChartWidget(chartData: chartData),
                  SizedBox(height: 20),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var transactionData = transactions[index].data() as Map<String, dynamic>;
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(transactionData['image']),
                    ),
                    title: Text(
                      transactionData['title'],
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      transactionData['subtitle'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Text(
                      transactionData['amount'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                        color: transactionData['type'] == 'income'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  );
                },
                childCount: transactions.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
