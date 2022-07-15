import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expanse_tracker/models/data.dart';
import 'package:expanse_tracker/models/transaction_data_bank.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'package:intl/intl.dart';

final _fireStore = FirebaseFirestore.instance.collection("Transaction");

class AddTaskScreen extends StatefulWidget {
  String? id;
  AddTaskScreen({this.id});
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  bool flagUpdate = false;
  String _title = "";
  double _amount = 0.0;
  String dateString = "No date chosen";
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    if (widget.id != null) {
      setState(() {
        flagUpdate = true;
      });
      setData(widget.id!);
    }
  }

  void setData(String id) {
    _fireStore.doc(id).get().then((DocumentSnapshot snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      print("add_set map = ${data['title']}");
      setState(() {
        _title = data['title'];
        _amount = data['amount'];
        selectedDate = data['timestamp'].toDate();
        dateString = DateFormat.yMd().format(data['timestamp'].toDate());
      });
      print("ti ${_title} ${_amount} ${selectedDate.toString()} ${dateString}");
    }, onError: (e) => print("Error getting document: $e"));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateString = DateFormat.yMd().format(selectedDate);
      });
    }
  }

  Future<String?> alertbox() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Alert ! Missing Field'),
        content: const Text('Don\'t want to add current transaction?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: const Text('No'),
          ), //cancel
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'OK');
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ), //yes
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(
        "from widget ${_title} ${_amount} ${selectedDate.toString()} ${dateString}");

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            "Add Transaction",
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            textAlign: TextAlign.center,
            onChanged: (value) {
              setState(() {
                _title = value;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Title",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              print("value = $value");
              setState(() {
                if (value == null || value == "") {
                  _amount = 0.0;
                  print("amt from text field = $_amount");
                  return;
                }
                _amount = double.parse(value);
                print("amt without error from text field = $_amount");
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Amount",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$dateString",
                style: kTextButtonFontStyle,
              ),
              TextButton(
                  onPressed: () => _selectDate(context),
                  child: Container(
                    child: Text(
                      "Choose Date",
                      style: kTextButtonFontStyle,
                    ),
                  ))
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                print(
                    "add ${_title} ${_amount} ${dateString} cond = ${_title == "" || _amount == 0.0 || dateString == "No date chosen"}");
                if (_title == "" ||
                    _amount == 0.0 ||
                    dateString == "No date chosen") {
                  print("box");
                  await alertbox();
                } else {
                  print(
                      "submit => title = $_title amt = $_amount date = $dateString");
                  // Provider.of<TransactionDataBank>(context, listen: false)
                  //     .addItem(
                  //         data: Data(
                  //             title: _title,
                  //             amount: _amount,
                  //             date: selectedDate));
                  if (flagUpdate) {
                    _fireStore
                        .doc(widget.id)
                        .update({
                          "amount": _amount,
                          "title": _title,
                          "timestamp": selectedDate
                        })
                        .then((value) => print("User Updated"))
                        .catchError(
                            (error) => print("Failed to update user: $error"));
                  } else {
                    _fireStore.add({
                      "title": _title,
                      "amount": _amount,
                      "timestamp": selectedDate
                    });
                  }

                  Navigator.pop(context);
                }
              },
              child: Container(
                child: Text(
                  "Add Transaction",
                  style: kTextButtonFontStyle,
                ),
              ))
        ],
      ),
    );
  }
}
