import 'package:expanse_tracker/models/data.dart';
import 'package:expanse_tracker/models/transaction_data_bank.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String _title = "";
  double _amount = 0.0;
  String dateString = "No Date Chosen";
  DateTime selectedDate = DateTime.now();

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
              // setState(() {
              //   _title = "";
              //   _amount = 0.0;
              //   dateString = "No Date Chosen";
              // });
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
                if (_title == "" ||
                    _amount == 0.0 ||
                    dateString == "No Date Chosen") {
                  print("box");
                  await alertbox();
                } else {
                  print(
                      "submit => title = $_title amt = $_amount date = $dateString");
                  Provider.of<TransactionDataBank>(context, listen: false)
                      .addItem(
                          data: Data(
                              title: _title,
                              amount: _amount,
                              date: dateString));
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
