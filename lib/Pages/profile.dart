import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController incomeController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  // Function to fetch and set placeholders from Firestore
  Future<void> setPlaceholders() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.email).get();

        Map<String, dynamic> profileData =
            (userDoc.data() as Map<String, dynamic>?)?['profile'] ?? {};

        setState(() {
          nameController.text = profileData['name'] ?? '';
          lastNameController.text = profileData['lastName'] ?? '';
          idController.text = profileData['idNumber'] ?? '';
          incomeController.text = profileData['incomeSource'] ?? '';
          addressController.text = profileData['address'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching placeholders: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Call setPlaceholders when the widget is initialized
    setPlaceholders();
  }

  void clearTextFields() {
    nameController.clear();
    lastNameController.clear();
    idController.clear();
    incomeController.clear();
    addressController.clear();
  }

  void submitProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Create a map with the profile details
        Map<String, dynamic> profileData = {
          'name': nameController.text,
          'lastName': lastNameController.text,
          'idNumber': idController.text,
          'incomeSource': incomeController.text,
          'address': addressController.text,
        };

        // Update the user's profile in Firestore using the email as the document ID
        await _firestore
            .collection('users')
            .doc(user.email)
            .set({'profile': profileData});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('User not logged in.');
      }
    } catch (e) {
      print('Error updating profile: $e');
      // Handle profile update failure
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Profile'),
        ),
        backgroundColor: Color(0xFF1B4569),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                ),
                TextFormField(
                  controller: idController,
                  decoration: InputDecoration(labelText: 'ID Number'),
                ),
                TextFormField(
                  controller: incomeController,
                  decoration: InputDecoration(labelText: 'Source of Income'),
                ),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: clearTextFields,
                      child: Text('Clear'),
                    ),
                    ElevatedButton(
                      onPressed: submitProfile,
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFFF0F8FF),
    );
  }
}
