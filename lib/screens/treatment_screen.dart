import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agroscan/screens/tfmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class TreatmentPage extends StatelessWidget {
  final PredictionData predictionData;// created constructor with predictionData

  const TreatmentPage({Key? key, required this.predictionData}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/treatment.png"), // Your image path here
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8), // Opacity set to 70%
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Treatment Diagnosis:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,

                      ),

                    ),
                    const SizedBox(height: 20),
                    Text( predictionData.label,//outputs the predicted label
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                    Expanded(
                      child: FutureBuilder<List<String>>(
                        future: fetchTreatmentData(predictionData.label),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            // Display fetched treatments
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Treatment Methods",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 20,),
                                for (final treatment in snapshot.data!)
                                  Text(treatment,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic
                                    ),
                                  ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            // Handle errors
                            return const Center(
                              child: Text('Error fetching treatments'),
                            );
                          } else {
                            // Show loading indicator
                            return const Center(
                              child: CircularProgressIndicator(),
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
                color: Colors.black,
              ),
              onPressed: () {
                // Add functionality for settings button
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TfModel()));
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

Future<List<String>> fetchTreatmentData(String diseaseName) async {
  final CollectionReference diseases = FirebaseFirestore.instance.collection('Diseases');
  try {
    final docSnapshot = await diseases.doc(diseaseName).get();

    if (docSnapshot.exists) {
      final Map<String, dynamic>? data = docSnapshot.data() as Map<
          String,
          dynamic>?;
      final String? treatment1 = data?['Cultural Practices'] as String?;
      final String? treatment2 = data?['Chemical Control'] as String?;


      // Ensure a non-null list of treatments is returned
      final treatments = [
        if (treatment1 != null) treatment1,
        if (treatment2 != null) treatment2,
      ];

      if (kDebugMode) {
        print('Treatments: $treatments');
      }

      return treatments; // Always returning a list, even if empty

    } else {
      // Handle the case where the disease document is not found
      throw Exception(
          'Disease not found '); // Or return a default list
    }
  }catch (e){
    if (kDebugMode) {
      print("error fetching treatments: $e");
    }
    throw Exception("error fetching treatments");
  }
}
