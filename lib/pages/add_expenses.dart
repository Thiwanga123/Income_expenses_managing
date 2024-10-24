import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddExpenses extends StatefulWidget {
  const AddExpenses({super.key});

  @override
  State<AddExpenses> createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  List<DocumentSnapshot> _documents = []; // This will hold the fetched documents
  String? selectedItem;
  String? selectedType; // For income/expense
  TextEditingController amountController = TextEditingController(); // Controller for amount input
  DateTime? selectedDate; // For storing the selected date

  @override
  void initState() {
    super.initState();
    fetchFirestoreItems(); // Fetch items when the screen is loaded
  }

  // Fetch the items from Firestore
  Future<void> fetchFirestoreItems() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('reason').get();
      setState(() {
        _documents = snapshot.docs; // Store the fetched documents
      });
    } catch (e) {
      print('Error fetching data: $e'); // Log the error for debugging
    }
  }

  // Function to select the date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked; // Update the selected date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            backgroundContainer(context),
            Positioned(
              top: 120,
              child: mainContainer(),
            ),
          ],
        ),
      ),
    );
  }

  Container mainContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      height: 550, // Increased height to accommodate the date selection
      width: 340,
      child: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2, color: const Color(0xffC5C5C5)),
              ),
              child: DropdownButton<String>(
                value: selectedItem,
                onChanged: (value) {
                  setState(() {
                    selectedItem = value;
                  });
                },
                items: _documents.map((doc) {
                  var docData = doc.data() as Map<String, dynamic>;
                  String image = docData['image'] ?? '';
                  String title = docData['name'] ?? '';

                  return DropdownMenuItem<String>(
                    value: title, // Use title as the value
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 40,
                          child: Image.network(image), // Display the image
                        ),
                        const SizedBox(width: 10),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                hint: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Select Item',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                dropdownColor: Colors.white,
                isExpanded: true,
                underline: Container(),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Dropdown for selecting Income or Expense
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2, color: const Color(0xffC5C5C5)),
              ),
              child: DropdownButton<String>(
                value: selectedType,
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                },
                items: ['Income', 'Expense'].map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        type,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                hint: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Select Type',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                dropdownColor: Colors.white,
                isExpanded: true,
                underline: Container(),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Input field for amount
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: 60, // Set fixed height to match dropdown height
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // Same radius as dropdown
                border: Border.all(width: 2, color: const Color(0xffC5C5C5)), // Optional: add a border
              ),
              child: TextField(
                controller: amountController, // Set the controller
                decoration: InputDecoration(
                  border: InputBorder.none, // Remove the default border
                  labelText: 'Enter Amount',
                  contentPadding: const EdgeInsets.all(10), // Padding inside the text field
                ),
                keyboardType: TextInputType.number, // To allow only numbers
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Input field for date selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap: () => _selectDate(context), // Open date picker on tap
              child: Container(
                height: 60, // Set fixed height to match dropdown height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // Same radius as dropdown
                  border: Border.all(width: 2, color: const Color(0xffC5C5C5)), // Optional: add a border
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:[
                    Text('Select the Date',
                    style: TextStyle(
                      color:Colors.grey,
                      fontSize: 16,
                    ),),
                    
                   
                    Text(
                    selectedDate == null
                        ? 'Select Date'
                        : '${selectedDate!.toLocal()}'.split(' ')[0], // Display selected date or hint
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  
                  ] 
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column backgroundContainer(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 240,
          decoration: const BoxDecoration(
            color: Color(0xff368983),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Adding',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Icon(
                      Icons.attach_file_outlined,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
