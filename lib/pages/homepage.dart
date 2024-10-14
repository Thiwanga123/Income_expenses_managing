import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: 287,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xff2A7C76),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top:35,
                    left: 340,
                  child:ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child:Container(
                      height: 40,
                      width: 40,
                      color:const Color.fromRGBO(250, 250, 250, 0.1),
                      child:  const Icon(Icons.notification_add_outlined, color: Colors.white,),
                    )
                  ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(top:35, left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Good afternoon", 
                        style: 
                        TextStyle(
                          color: Colors.white, 
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                          ),
                        Text("Thiwanga", 
                        style:
                        TextStyle(
                          color: Colors.white, 
                          fontWeight: FontWeight.w600, 
                          fontSize: 20),
                          ),
                      ],
                    ),
                  )
                  
                ],
              )
            ),
        
          ]
          ,
        ),
      ),
    );
  }
}