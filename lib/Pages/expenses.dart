import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Expenses extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        centerTitle: true,
        backgroundColor: Color(0xFF1B4569),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Category',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Amount',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.black,
            ),
            StreamBuilder(
              stream: getExpensesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<QueryDocumentSnapshot>? expenses =
                      snapshot.data?.docs.cast<QueryDocumentSnapshot>();

                  if (expenses == null || expenses.isEmpty) {
                    return Text('No expenses found.');
                  }

                  // Iterate through each expense and display its details
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot expense = expenses[index];
                      return buildExpenseRow(expense);
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getExpensesStream() {
    User? user = _auth.currentUser;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user?.email)
        .collection('expenses')
        .snapshots();
  }

  Widget buildExpenseRow(QueryDocumentSnapshot expense) {
    String date = expense['date'].toDate().toString();
    String category = expense['category'];
    double amount = expense['amount'];
    String description = expense['description'];

    return Row(
      children: <Widget>[
        Expanded(child: Text(date)),
        Expanded(child: Text(category)),
        Expanded(child: Text('\R$amount')),
        Expanded(child: Text(description)),
      ],
    );
  }
}
