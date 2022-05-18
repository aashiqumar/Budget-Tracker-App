// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'package:flutter/material.dart';

class MyTransactions extends StatelessWidget {
  late final String transactionName;
  late final String money;
  late final String expenseOrIncome;

  MyTransactions({required this.transactionName, required this.money, required this.expenseOrIncome});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(12),
          color: Colors.white,
          height: 50,
          child: Center(
         
            child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            
                            borderRadius: BorderRadius.circular(40)
                          ),

                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Icon(
                                Icons.attach_money_outlined,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ),

                        Text(transactionName),
                      ],
                    ),
                   
                    
                    
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text((expenseOrIncome == 'expense' ? '-' : '+') + '\$' + money,
                        style: TextStyle(
                          color: (expenseOrIncome == 'expense' ? Colors.red : Colors.green)
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            
          ),
        ),
        
      ),
    );
  }
}