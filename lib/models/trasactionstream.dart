import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expanse_tracker/add_transaction_screen.dart';
import 'package:expanse_tracker/models/transaction_data_bank.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data.dart';

final _fireStore = FirebaseFirestore.instance;

class TransactionsStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore
            .collection('Transaction')
            .orderBy('timestamp')
            .snapshots(),
        builder: (context, snapshot) {
          List<dynamic> transactionDocumentList = [];
          //contains task extracted from document
          List<Data> tempList = [];
          int tempListSize = 0;
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          if (snapshot.hasData) {
            print("no data");
          }
          //taskDataSnapshot contains zero or more [DocumentSnapshot] objects.
          final taskDataSnapshot = snapshot.data?.docs.reversed;
          print("last");
          if (taskDataSnapshot!.isEmpty) {
            Future.delayed(
                Duration(milliseconds: 500),
                () => Provider.of<TransactionDataBank>(context, listen: false)
                    .clearDailyTotal());
          }
          taskDataSnapshot.map((i) {
            Map<String, dynamic> data = i.data()! as Map<String, dynamic>;
            data['id'] = i.id;
            print(data);
            //adding doc one by one to the list
            transactionDocumentList.add(data);
          });
          for (var document in transactionDocumentList) {
            final taskTitle = document["title"];
            //final taskOwner = document["email"];
            final taskAmount = document["amount"];
            //final currentUser = loggedInUser.email;
            final taskTime = document["timestamp"];
            final taskId = document["id"];
            tempList.add(Data(
                title: taskTitle,
                amount: double.parse(taskAmount.toString()),
                date: taskTime.toDate(),
                id: taskId));
            //tempList = [...tempList, Data(title: task, status: taskStatus)];
          }
          Future.delayed(
              Duration(milliseconds: 500),
              () => Provider.of<TransactionDataBank>(context, listen: false)
                  .setTransactionList(tempList));
          tempListSize = tempList.length;
          print("task size =${tempListSize}");
          return ListView.builder(
              itemCount: tempListSize,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () => showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: AddTaskScreen(
                                id: tempList[index].id,
                              ),
                            ),
                          )),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 5.0), //(x,y)
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          child: Text(
                            "Rs.${tempList[index].amount}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                        ), //amount
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${tempList[index].title}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ), //title
                                SizedBox(height: 5),
                                Text(
                                  "${tempList[index].date}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ), //date
                              ],
                            ),
                          ),
                        ), //title + date
                        GestureDetector(
                            onTap: () {
                              _fireStore
                                  .collection('Transaction')
                                  .doc(tempList[index].id)
                                  .delete()
                                  .then((value) => print('User Deleted'))
                                  .catchError((error) =>
                                      print('Failed to Delete user: $error'));
                            },
                            child: Icon(Icons.delete)), //delete curritem
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
