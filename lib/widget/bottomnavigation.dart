import 'package:flutter/material.dart';
import 'package:income_expenses_managing/pages/add_expenses.dart';
import 'package:income_expenses_managing/pages/homepage.dart';
import 'package:income_expenses_managing/pages/statistic.dart';


class Bottom extends StatefulWidget {
  const Bottom({super.key});

@override
State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
   int index_color = 0;
   List Screen=[Home(),Statistics(),Home(),Home()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screen[index_color],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).
          push(MaterialPageRoute(builder: (context)=>const AddExpenses()));
        },
        child:Icon(Icons.add),
        backgroundColor: const Color(0xff368983),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(top:7.5, bottom: 7.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: (){
                  setState(() {
                    index_color = 0;
                  });
                },
                child: Icon(
                  Icons.home,
                  size: 30, 
                  color:index_color==0? const Color(0xff368983) :Colors.grey,
              ),
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    index_color = 1;
                  });
                },
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 30, 
                  color: index_color==1? const Color(0xff368983) :Colors.grey,
              ),
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    index_color = 2;
                  });
                },
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 30, 
                  color: index_color==2? const Color(0xff368983) :Colors.grey,
              ),
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    index_color = 3;
                  });
                },
                child: Icon(
                  Icons.person_outlined,
                  size: 30, 
                  color: index_color==3? const Color(0xff368983) :Colors.grey,
              ),
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}