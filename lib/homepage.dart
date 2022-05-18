// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'dart:async';

import 'package:budget_tracker/google_sheets_api.dart';
import 'package:budget_tracker/loading_circle.dart';
import 'package:budget_tracker/top_new_card.dart';
import 'package:budget_tracker/transactions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  void _enterTransactions() {
    GoogleSheetsAPI.insert(
        _titleController.text, _amountController.text, _isIncome);
  }

  void _newTransaction() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: Text("N E W  T R A N S A C T I O N", style: TextStyle(fontSize: 15),),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Expense"),
                            CupertinoSwitch(
                                value: _isIncome,
                                thumbColor: Colors.white,
                                trackColor: Colors.red,
                                activeColor: Colors.green,
                                onChanged: (newValue) {
                                  setState(() {
                                    _isIncome = newValue;
                                  });
                                }),
                            Text("Income"),
                          ]),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Transaction Title?',
                            ),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money_outlined,
                            color: Colors.grey[500],
                          ),
                          Text("Amount"),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: Form(
                            key: _formKey,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _amountController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '0.0',
                              ),
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Enter an Amount";
                                }
                                return null;
                              },
                            ),
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                      color: Colors.grey[600],
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  MaterialButton(
                      color: Colors.grey[600],
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _enterTransactions();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        }
                      }),
                ],
              );
            },
          );
        });
  }

  late Timer _timer;

  bool timerHasStarted = false;
  void startLoading() {
    timerHasStarted = true;

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (GoogleSheetsAPI.loading == false) {
        setState(() {
          timer.cancel();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GoogleSheetsAPI.loading == true && timerHasStarted == false) {
      startLoading();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _newTransaction();
        },
        backgroundColor: Colors.grey[600],
        child: Center(
            child: Text(
          "+",
          style: TextStyle(fontSize: 30),
        )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            TopNewCard(
              balance: (GoogleSheetsAPI.calculateIncome() -
                      GoogleSheetsAPI.calculateExpense())
                  .toString(),
              income: GoogleSheetsAPI.calculateIncome().toString(),
              expense: GoogleSheetsAPI.calculateExpense().toString(),
            ),
            Expanded(
                child: Container(
              child: Center(
                  child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                      child: GoogleSheetsAPI.loading == true
                          ? LoadingCircle()
                          : ListView.builder(
                              itemCount:
                                  GoogleSheetsAPI.currentTransactions.length,
                              itemBuilder: (context, index) {
                                return MyTransactions(
                                    transactionName: GoogleSheetsAPI
                                        .currentTransactions[index][0],
                                    money: GoogleSheetsAPI
                                        .currentTransactions[index][1],
                                    expenseOrIncome: GoogleSheetsAPI
                                        .currentTransactions[index][2]);
                              })),
                ],
              )),
            )),
          ],
        ),
      ),
    );
  }
}
