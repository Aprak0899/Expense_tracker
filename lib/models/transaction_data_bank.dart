import 'dart:collection';
import 'package:flutter/material.dart';
import 'data.dart';

class TransactionDataBank extends ChangeNotifier {
  List<Data> _TransactionList = [
    Data(title: "abc", amount: 24.05, date: "today"),
    Data(title: "abc", amount: 24.05, date: "today"),
    Data(title: "abc", amount: 24.05, date: "today"),
    Data(title: "abc", amount: 24.05, date: "today"),
    Data(title: "abc", amount: 24.05, date: "today"),
    Data(title: "abc", amount: 24.05, date: "today"),
  ];
  final Map<int, String> planets = HashMap(); // Is a HashMap
  void addItem({required Data data}) {
    _TransactionList.add(data);
    notifyListeners();
  }

  List<Data> getList() {
    return _TransactionList;
  }

  Data getItemAtIndex({required int index}) {
    return _TransactionList[index];
  }

  int getSize() {
    return _TransactionList.length;
  }

  void deleteItemAtIndex({required int index}) {
    _TransactionList.removeAt(index);
    notifyListeners();
  }
}
