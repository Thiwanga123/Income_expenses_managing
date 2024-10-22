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
            Column(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Good afternoon", 
                            style: 
                            TextStyle(
                              color: Colors.white, 
                              fontWeight: FontWeight.w300,
                              fontSize: 14),
                              ),
                             Text("Thiwanga", 
                              style:
                              TextStyle(
                                color: Colors.white, 
                                fontWeight: FontWeight.w500, 
                                fontSize: 20),
                                ),
                            
                          ],
                        ),
                      )
                      
                    ],
                  )
                ),
              ],
            ),
        
            Positioned(
            top: 155,
            left: 20,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: 201,
                width: 374,
                decoration: BoxDecoration(
                color: const Color.fromRGBO(47, 126, 121, 1.0),
                borderRadius: BorderRadius.circular(20),
                ),
              
                child:  const Column(
                  children: [
                    
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:15 ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Balance",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              ),                    
                              Icon( Icons.more_horiz, color: Colors.white, size: 20,)
                            ],
                          ),
              
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("LKR 100,000.00",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                              ),
                              
                            ],
                          ),
              
                          SizedBox(height: 30),
              
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Row(
                              children: [
                                 CircleAvatar(
                                  radius: 13,
                                  backgroundColor: Color.fromARGB(255, 85, 145, 141),
                                  child: Icon(
                                    Icons.arrow_upward, 
                                    color: Colors.white,
                                    size: 19,
                                  ),
                                ),
              
                                SizedBox(width: 10),
                                Text("Income",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                ),
                              ],
                            ),
              
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 13,
                                  backgroundColor: Color.fromARGB(255, 85, 145, 141),
                                  child: Icon(
                                    Icons.arrow_downward, 
                                    color: Colors.white,
                                    size: 19,
                                  ),
                                ),
                                SizedBox( width:10),
                                Text("Expenses",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                ),
                              ],
                            ),
              
              
                          ],),
              
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "LKR.1840.00",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
              
                              Text(
                                "LKR.1840.00",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                    
                  ],
                )
              ),
            ),
            ),
          ],
          ),
      ),
    );
  }
}