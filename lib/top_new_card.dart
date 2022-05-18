// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_this, sort_child_properties_last

import 'package:flutter/material.dart';

class TopNewCard extends StatelessWidget {
  late final String balance;
  late final String income;
  late final String expense;

  TopNewCard({required this.balance, required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50,left: 2, right: 2),
      child: Container(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              
              Text(
                "B A L A N C E",
                style: TextStyle(color: Colors.grey[500], fontSize: 16),
              ),
              Text(
                balance,
                style: TextStyle(color: Colors.grey[800], fontSize: 40),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child: Icon(Icons.arrow_upward_rounded, color: Colors.green,)),

                          SizedBox(width: 10,),
                        Column(
                          children: [
                            Text("INCOME", style: TextStyle(color: Colors.grey, fontSize: 15),),
                            SizedBox(height: 5,),
                            Text("\$"+income),
                          ],
                        ),
                      ],
                    ),
                    
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child: Icon(Icons.arrow_downward_rounded, color: Colors.red,)),

                          SizedBox(width: 10,),
                        Column(
                          children: [
                            Text("EXPENSE", style: TextStyle(color: Colors.grey, fontSize: 15),),
                            SizedBox(height: 5,),
                            Text("\$"+expense),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[300],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              offset: Offset(4.0, 4.0),
              blurRadius: 15.0,
              spreadRadius: 1.0
            ),

            BoxShadow(
              color: Colors.white,
              offset: Offset(-4.0, -4.0),
              blurRadius: 15.0,
              spreadRadius: 1.0
            ),
          ]
        ),
      ),
    );
  }
}
