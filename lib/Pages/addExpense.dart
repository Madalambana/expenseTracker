import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddExpense extends StatefulWidget {
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpense> {
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String selectedCategory = "Food"; // Default category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
        centerTitle: true,
        backgroundColor: Color(0xFF1B4569),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              items: getDropdownItems(),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save the expense details
                saveExpense();
                // Navigate back
                Navigator.pop(context);
              },
              child: Text('Save Expense'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to get dropdown items
  List<DropdownMenuItem<String>> getDropdownItems() {
    return <String>[
      "Food",
      "Communication",
      "Savings",
      "Investment",
      "Entertainment",
      // Add more categories as needed
    ].map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  // Function to save the expense and increment category count
  void saveExpense() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get a reference to the expenses collection for the user
        CollectionReference expensesCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('expenses');

        // Create a map with the expense details
        Map<String, dynamic> expenseData = {
          'date': DateTime.now(),
          'category': selectedCategory,
          'amount': double.parse(amountController.text),
          'description': descriptionController.text,
          'userEmail': user.email,
        };

        // Add the expense to the expenses collection
        await expensesCollection.add(expenseData);

        // Increment the category count
        await incrementCategoryCount(user.email!, selectedCategory);

        // Display a SnackBar to indicate successful addition
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Expense added successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('User not logged in.');
      }
    } catch (e) {
      print('Error saving expense: $e');
      // Handle expense saving failure
    }
  }

  // Function to increment the category count
  Future<void> incrementCategoryCount(String userEmail, String category) async {
    try {
      DocumentReference categoryRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('categories')
          .doc(category);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(categoryRef);

        if (snapshot.exists) {
          // If the category exists, increment the count
          int currentCount = snapshot['count'] ?? 0;
          transaction.update(categoryRef, {'count': currentCount + 1});
        } else {
          // If the category doesn't exist, create it with count 1
          transaction.set(categoryRef, {'count': 1});
        }
      });
    } catch (e) {
      print('Error incrementing category count: $e');
    }
  }
}
