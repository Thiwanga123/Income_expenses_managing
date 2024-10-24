import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Add_data {
  String name;
  String subtitle; // Assuming this is your date field
  String amount;
  String IN; // Income or Expense
  DateTime datetime; // You can add datetime field as needed

  Add_data({
    required this.name,
    required this.subtitle,
    required this.amount,
    required this.IN,
    required this.datetime,
  });

  // Factory constructor to create an instance from Firestore data
  factory Add_data.fromMap(Map<String, dynamic> data) {
    return Add_data(
      name: data['name'] ?? '',
      subtitle: data['subtitle'] ?? '',
      amount: data['amount'] ?? '0', // Default value if not found
      IN: data['income'] ?? 'Expense', // Default value if not found
      datetime: DateTime.parse(data['subtitle']), // Assuming subtitle is a date string
    );
  }
}

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

ValueNotifier<int> kj = ValueNotifier<int>(0); // Specify type

class _StatisticsState extends State<Statistics> {
  List<String> day = ['Day', 'Week', 'Month', 'Year'];
  List<List<Add_data>> f = [];
  List<Add_data> a = [];
  int index_color = 0;

  @override
  void initState() {
    super.initState();
    loadData(); // Load data on initialization
  }

  Future<void> loadData() async {
    // Fetch data from Firestore
    List<Add_data> allData = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Transaction history').get();
    
    for (var doc in snapshot.docs) {
      // Create Add_data instance from Firestore data
      Add_data data = Add_data.fromMap(doc.data() as Map<String, dynamic>);
      allData.add(data);
    }

    // Group data by time frames
    f = [
      allData.where((data) => isToday(data)).toList(),
      allData.where((data) => isThisWeek(data)).toList(),
      allData.where((data) => isThisMonth(data)).toList(),
      allData.where((data) => isThisYear(data)).toList(),
    ];

    kj.value = 0; // Reset to the default
  }

  bool isToday(Add_data data) {
    // Convert subtitle string to DateTime and check if it's today
    DateTime date = DateTime.parse(data.subtitle);
    return date.isAtSameMomentAs(DateTime.now());
  }

  bool isThisWeek(Add_data data) {
    DateTime date = DateTime.parse(data.subtitle);
    DateTime now = DateTime.now();
    // Check if the date falls within the current week
    return date.isAfter(now.subtract(Duration(days: now.weekday - 1))) &&
           date.isBefore(now.add(Duration(days: 7 - now.weekday)));
  }

  bool isThisMonth(Add_data data) {
    DateTime date = DateTime.parse(data.subtitle);
    DateTime now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  bool isThisYear(Add_data data) {
    DateTime date = DateTime.parse(data.subtitle);
    DateTime now = DateTime.now();
    return date.year == now.year;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<int>(
          valueListenable: kj,
          builder: (BuildContext context, value, Widget? child) {
            a = f[value]; // Update based on the selected timeframe
            return custom();
          },
        ),
      ),
    );
  }

  CustomScrollView custom() {
    return CustomScrollView(
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
                      4,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              index_color = index;
                              kj.value = index; // Update ValueNotifier
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index_color == index
                                  ? Color.fromARGB(255, 47, 125, 121)
                                  : Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              day[index],
                              style: TextStyle(
                                color: index_color == index
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
              // Chart(
              //   indexx: index_color,
              // ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Spending',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.swap_vert,
                      size: 25,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    'images/${a[index].name}.png',
                    height: 40,
                  ),
                ),
                title: Text(
                  a[index].name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${a[index].subtitle}', // Using the subtitle directly
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Text(
                  a[index].amount,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                    color: a[index].IN == 'Income' ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
            childCount: a.length,
          ),
        ),
      ],
    );
  }
}
