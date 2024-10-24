import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseDropdownMenuItem extends StatefulWidget {
  const FirebaseDropdownMenuItem({super.key});

  @override
  _FirebaseDropdownMenuItemState createState() => _FirebaseDropdownMenuItemState();
}

class _FirebaseDropdownMenuItemState extends State<FirebaseDropdownMenuItem> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Firestore Dropdown"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("reason").snapshots(), // Use the 'reason' collection
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          // Create an empty list for DropdownMenuItems
          List<DropdownMenuItem> reasonItems = [];

          // Handle loading state
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final reasons = snapshot.data?.docs.reversed.toList(); // Get the docs
            if (reasons != null) {
              // Loop through the docs and add items to the dropdown
              for (var reason in reasons) {
                reasonItems.add(
                  DropdownMenuItem(
                    value: reason.id, // Set the document ID as the value
                    child: Row(
                      children: [
                        // Display the image field (assuming it's a URL)
                        Image.network(
                          reason['image'], // Image URL from Firestore
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 10),
                        // Display the name field
                        Text(
                          reason['name'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }

            // Return the DropdownButton
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: const EdgeInsets.only(right: 15, left: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButton(
                  underline: const SizedBox(),
                  isExpanded: true,
                  hint: const Text(
                    "Select a Reason",
                    style: TextStyle(fontSize: 20),
                  ),
                  value: selectedValue,
                  items: reasonItems, // Use the items from Firestore
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
