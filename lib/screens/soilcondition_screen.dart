import 'package:agroscan/widgets/navbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SoilConditionPage extends StatefulWidget {
  const SoilConditionPage({super.key});

  @override
  SoilConditionPageState createState() => SoilConditionPageState();
}

class SoilConditionPageState extends State<SoilConditionPage> {

  TextEditingController plantNameController = TextEditingController(); // Create a TextEditingController
  String userInput = '';

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/soilimage.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Container(
                width: 300,
                height: 600,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Soil Condition:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Changed color to black
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Text field for entering plant name
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: plantNameController, // Assign the TextEditingController
                        style: const TextStyle(color: Colors.black), // Changed text color to black
                        decoration: InputDecoration(
                            hintText: 'Enter Plant Name',
                            hintStyle: const TextStyle(color: Colors.black), // Changed hint color to black
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              onPressed: (){
                                plantNameController.clear();
                              },
                              icon: const Icon(Icons.clear),
                            )
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: (){
                        setState((){
                          userInput = plantNameController.text;
                        });
                      },
                      color: Colors.blue,
                      child: const Text("Find", style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: userInput.isEmpty? Container()
                          :FutureBuilder<List<String>>(
                        future: fetchSoilConditionData(userInput), // Pass the text field value to the function
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            // Display fetched soil condition
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                const Text(
                                  'Soil Condition Details:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // Changed color to black
                                  ),
                                ),
                                const SizedBox(height: 5),
                                // Text field to display soil condition
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: TextField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text: snapshot.data!.join('\n')),
                                    maxLines: null,
                                    style: const TextStyle(color: Colors.black), // Changed text color to black
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            // Handle errors
                            return const Center(
                              child: Text('Plant not found',
                                  style: TextStyle(color: Colors.black)), // Changed color to black
                            );
                          } else {
                            // Handle no data case
                            return const Center(
                              child: Text('No data available',
                                  style: TextStyle(color: Colors.black)), // Changed color to black
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                // Add functionality for settings button
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NavBarRoots()));
              },
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                  // Add functionality to close the page
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<String>> fetchSoilConditionData(String plantName) async {
  final CollectionReference plants =
  FirebaseFirestore.instance.collection('Soil Condition');
  try {
    final docSnapshot = await plants.doc(plantName).get();

    if (docSnapshot.exists) {
      final Map<String, dynamic>? data =
      docSnapshot.data() as Map<String, dynamic>?;
      final String? soilCondition =
      data?['condition'] as String?; // Assuming field name is 'Soil Condition'

      if (soilCondition != null) {
        // Return soil condition if available
        return [soilCondition];
      } else {
        // Return an empty list if soil condition is not available
        throw Exception('Plant not found');
      }
    } else {
      // Handle the case where the plant document is not found
      throw Exception('Plant not found');
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error fetching soil condition: $e");
    }
    throw Exception("Error fetching soil condition");
  }
}
