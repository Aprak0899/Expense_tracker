import 'package:expanse_tracker/add_transaction_screen.dart';
import 'package:expanse_tracker/models/trasactionstream.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'bargraphscreen.dart';
import 'models/bardata.dart';
import 'models/data.dart';
import 'models/transaction_data_bank.dart';
import 'package:fl_chart/fl_chart.dart';

List<BarData> barData = [
  BarData(id: 0, name: "a", y: 10.0),
  BarData(id: 1, name: "b", y: 15.0)
];

class ExpenseScreen extends StatelessWidget {
  List<BarChartGroupData> bars = [BarChartGroupData(x: 0)];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9C5),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: AddTaskScreen(),
                  ),
                )),
        child: Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              child: BarChartSample1(),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TransactionsStream(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class TransactionListTile extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Container(
//         height: 100,
//         child: Center(
//           child: ListTile(
//             title: Text(
//                 "${Provider.of<TransactionDataBank>(context).getItemAtIndex(index: index).title}"),
//             //leading: Text("${Provider.of<TransactionDataBank>(context).getItemAtIndex(index: index).amount}"),
//             leading: CircleAvatar(
//               radius: 70,
//               child: Text(
//                   "${Provider.of<TransactionDataBank>(context).getItemAtIndex(index: index).amount}"),
//             ),
//             //trailing: Text("${Provider.of<TransactionDataBank>(context).getItemAtIndex(index: index).date}"),
//             trailing: GestureDetector(
//                 onTap: () {
//                   print("bin me $index");
//                 },
//                 child: Icon(Icons.delete)),
//           ),
//         ),
//       ),
//     );
//   }
// }

//==============================================

// BarChart(
// BarChartData(
// maxY: 10,
// minY: 0,
// alignment: BarChartAlignment.center,
// groupsSpace: 3,
// barTouchData: BarTouchData(enabled: true),
// barGroups: [
// BarChartGroupData(x: 1, barRods: [
// BarChartRodData(toY: 5, color: Colors.red, width: 3)
// ]),
// BarChartGroupData(x: 2, barRods: [
// BarChartRodData(toY: 7, color: Colors.green, width: 3)
// ])
// ]),
// swapAnimationDuration: Duration(milliseconds: 150), // Optional
// swapAnimationCurve: Curves.linear,
// ),

//==========listviewbuilder that uses provider for data ======================
//
// ListView.builder(
// itemCount:
// Provider.of<TransactionDataBank>(context).getSize(),
// itemBuilder: (context, index) {
// return Container(
// margin: EdgeInsets.symmetric(vertical: 5),
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.circular(12),
// boxShadow: [
// BoxShadow(
// color: Colors.grey,
// offset: Offset(0.0, 5.0), //(x,y)
// blurRadius: 5.0,
// ),
// ],
// ),
// padding:
// EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// child: Row(
// //mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// CircleAvatar(
// radius: 30,
// child: Text(
// "Rs.${Provider.of<TransactionDataBank>(context).getItemAtIndex(index: index).amount}",
// textAlign: TextAlign.center,
// style: TextStyle(
// fontSize: 14,
// fontWeight: FontWeight.normal),
// ),
// ),
// Expanded(
// child: Container(
// padding: EdgeInsets.symmetric(horizontal: 20),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// "${Provider.of<TransactionDataBank>(context).getItemAtIndex(index: index).title}",
// style: TextStyle(
// fontSize: 18,
// fontWeight: FontWeight.w700),
// ),
// SizedBox(height: 5),
// Text(
// "${Provider.of<TransactionDataBank>(context).getItemAtIndex(index: index).date}",
// style: TextStyle(
// fontSize: 12,
// fontWeight: FontWeight.w400),
// ),
// ],
// ),
// ),
// ),
// GestureDetector(
// onTap: () {
// print("bin me $index");
// Provider.of<TransactionDataBank>(context,
// listen: false)
//     .deleteItemAtIndex(index: index);
// },
// child: Icon(Icons.delete)),
// ],
// ),
// );
// })
