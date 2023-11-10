import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final double budget = 1000.0; // Set your budget here
  final int numRecentTransactions =
      5; // Set the number of recent transactions to display

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushNamed(context, '/login'); // Navigate to the login page
    } catch (e) {
      // Handle any signout errors
      print('Error during signout: $e');
      // Display an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out. Please try again.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Dashboard',
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF1B4569),
      ),
      drawer: Drawer(
        child: Container(
          color: Color(0xFF1B4569),
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: null, // Set accountName to null
                accountEmail: Text(user?.email ?? ""),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.black),
                ),
              ),
              ListTile(
                title: Text("Home", style: TextStyle(color: Colors.white)),
                leading: Icon(Icons.home, color: Colors.white),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Profile", style: TextStyle(color: Colors.white)),
                leading: Icon(Icons.person, color: Colors.white),
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              ListTile(
                title: Text("Categories and expenses",
                    style: TextStyle(color: Colors.white)),
                leading: Icon(Icons.category, color: Colors.white),
                onTap: () {
                  Navigator.pushNamed(context, '/category');
                },
              ),
              ListTile(
                title: Text("History", style: TextStyle(color: Colors.white)),
                leading: Icon(Icons.history, color: Colors.white),
                onTap: () {
                  Navigator.pushNamed(context, '/expenses');
                },
              ),
              ListTile(
                title: Text("Logout", style: TextStyle(color: Colors.white)),
                leading: Icon(Icons.exit_to_app, color: Colors.white),
                onTap: () {
                  _signOut(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50.0, bottom: 20.0),
                child: Text(
                  'Hello ' + (user?.email ?? ""),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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

                    double totalAmount = calculateTotalAmount(expenses);
                    double savingsAmount =
                        calculateCategoryTotalAmount(expenses, 'Savings');
                    double investmentAmount =
                        calculateCategoryTotalAmount(expenses, 'Investment');
                    double balance = savingsAmount + investmentAmount;
                    double budgetProgress = (totalAmount / budget) * 100;

                    return Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Total Expenses: \R${totalAmount.toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Budget Progress: ${budgetProgress.toStringAsFixed(2)}%',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Balance: \R${balance.toStringAsFixed(2)}',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Recent Transactions:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Column(
                                        children:
                                            getRecentTransactions(expenses),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
              SizedBox(height: 50),
              Text(
                'Tips and Strategies:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/data.jpg',
                    width: 200,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/data1.jpg',
                    width: 200,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              Text(
                'Tips and Strategies:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '1.  Budgets are a combination of Savings and Investments:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Prioritize on having nore on savings and investmengt to accumulate a positive budget progress',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '2. Track Your Spending:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Regularly monitor your expenses to identify areas where you can cut back. Use budgeting apps or spreadsheets to categorize and analyze your spending patterns.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '3. Emergency Fund:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Build an emergency fund to cover unexpected expenses. Having a financial safety net can prevent you from dipping into your planned budget in times of crisis.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '4. Prioritize Needs Over Wants:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Distinguish between essential needs and discretionary spending. Prioritize your needs first, and allocate funds to wants only if your budget allows.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '5. Review and Adjust:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Regularly review your budget and financial goals. Adjust your spending plan as needed to accommodate changes in income, expenses, or financial priorities.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFF0F8FF),
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

  double calculateTotalAmount(List<QueryDocumentSnapshot> expenses) {
    double totalAmount = 0;

    for (QueryDocumentSnapshot expense in expenses) {
      totalAmount += expense['amount'];
    }

    return totalAmount;
  }

  double calculateCategoryTotalAmount(
      List<QueryDocumentSnapshot> expenses, String category) {
    double categoryTotalAmount = 0;

    for (QueryDocumentSnapshot expense in expenses) {
      if (expense['category'] == category) {
        categoryTotalAmount += expense['amount'];
      }
    }

    return categoryTotalAmount;
  }

  List<Widget> getRecentTransactions(List<QueryDocumentSnapshot> expenses) {
    List<Widget> recentTransactions = [];

    // Sort expenses by date
    expenses.sort((a, b) {
      DateTime dateA = (a['date'] as Timestamp).toDate();
      DateTime dateB = (b['date'] as Timestamp).toDate();
      return dateB.compareTo(dateA);
    });

    // Display the latest expense for each category
    Set<String> displayedCategories = Set<String>();
    for (QueryDocumentSnapshot expense in expenses) {
      String category = expense['category'];
      if (!displayedCategories.contains(category)) {
        recentTransactions.add(
          Center(
            child: Text('$category: \R${expense['amount'].toStringAsFixed(2)}'),
          ),
        );
        displayedCategories.add(category);
      }

      if (displayedCategories.length >= numRecentTransactions) {
        break;
      }
    }

    return recentTransactions;
  }
}
