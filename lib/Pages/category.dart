import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Category extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Categories',
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF1B4569),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, int>>(
          future: getCategoryCounts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              Map<String, int> categoryCounts = snapshot.data ?? {};

              // Set hardcoded values for categories not available in the database
              final hardcodedCategories = [
                'Food',
                'Communication',
                'Savings',
                'Investment',
                'Entertainment'
              ];

              for (var category in hardcodedCategories) {
                categoryCounts.putIfAbsent(category, () => 0);
              }

              return Column(
                children: [
                  for (var entry in categoryCounts.entries)
                    CategoryCard(entry.key, entry.value),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/addexpense');
                    },
                    child: Text('Add New Expenses'),
                  ),
                ],
              );
            }
          },
        ),
      ),
      backgroundColor: Color(0xFFF0F8FF),
    );
  }

  Future<Map<String, int>> getCategoryCounts() async {
    User? user = _auth.currentUser;
    if (user != null) {
      CollectionReference categoriesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection('categories');

      QuerySnapshot querySnapshot = await categoriesCollection.get();

      Map<String, int> categoryCounts = {};
      querySnapshot.docs.forEach((doc) {
        categoryCounts[doc.id] = doc['count'] ?? 0;
      });

      return categoryCounts;
    } else {
      return {};
    }
  }
}

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final int itemCount;

  CategoryCard(this.categoryName, this.itemCount);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(categoryName, style: TextStyle(fontSize: 18)),
            Chip(
              label: Text(
                itemCount.toString(),
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Color(0xFF1B4569),
            ),
          ],
        ),
      ),
    );
  }
}
