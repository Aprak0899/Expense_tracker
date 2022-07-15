import 'package:flutter/material.dart';
import 'data.dart';

class MapData {
  List<Data>? TransactionList;
  double? total;
  MapData({required List<Data> TransactionList}) {
    setTotal(tlist: TransactionList);
  }
  void setTotal({required List<Data> tlist}) {
    this.total =
        tlist.fold<double>(0, (double sum, Data item) => sum + item.amount);
    print("total = ${total}");
  }
}
