import 'package:agroscan/Model/plant_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agroscan/screens/storing_screen.dart';
import 'package:agroscan/screens/signin_screen.dart';
import 'package:agroscan/widgets/navbar.dart';

class LogScreenPage extends StatefulWidget {
  final String message;
  final String plantType;
  final int moistureLevel;
  final int nutrientLevel;
  final int pesticideVolume;
  final Plantdata plantdata;

  const LogScreenPage({
    Key? key,
    required this.message,
    required this.plantType,
    required this.moistureLevel,
    required this.nutrientLevel,
    required this.pesticideVolume, required this.plantdata,
  }) : super(key: key);


  toJson(){
    return {
      "plantType": plantType,
      "moistureLevel": moistureLevel,
      "nutrientLevel": nutrientLevel,
      "pesticideVolume": pesticideVolume,


    };
  }
  @override
  LogScreenPageState createState() => LogScreenPageState();
}

class LogScreenPageState extends State<LogScreenPage> {
  List<dynamic> logEntries = [];
  List <Plantdata> plantdatalist = [];

  @override
  void initState() {
    super.initState();
    //_updateFirestore();
    fetchlogs();
    getfirestore();
  }

  Future<void> getfirestore() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final logs = db.collection("Logs").doc(await getUserId());
      DocumentSnapshot documentSnapshot = await logs.get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;
        Plantdata plantdata = Plantdata.fromJson(data);
        if (kDebugMode) {
          print(plantdata.toString());
        }
      }
    } catch (e) {
      // Handle any errors
      if (kDebugMode) {
        print("Error fetching Firestore data: $e");
      }
    }
  }

// Retrieving log entires from firestore
  void fetchlogs() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final logs = db.collection("Logs").doc(await getUserId());
      DocumentSnapshot documentSnapshot = await logs.get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data =
        documentSnapshot.data() as Map<String, dynamic>?;


        // Update logEntries here
        setState(() {
          logEntries = data?['log'] ?? [];
        });
        // Iterate over each log entry
        for (var logEntry in logEntries) {

          try{
            plantdatalist.add (Plantdata.fromJson(logEntry));
          }
          catch(e){
            if (kDebugMode) {
              print (e);
            }
          }
          // Print or process each log entry
          if (kDebugMode) {
            print(logEntry);
          }
        }

      } else {
        if (kDebugMode) {
          print("No logs found in Firestore");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching logs from Firestore: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/logscreenimage.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const SizedBox(height: 30),
                    const SizedBox(height: 10),
                    // Display log entries
                    Expanded(
                      child: Scrollbar(
                        child: ListView.builder(
                          itemCount: logEntries.length,
                          itemBuilder: (context, index) {
                            final logEntry = logEntries[index];
                            return ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Plant Type: ${logEntry['plantType']}',style: const TextStyle(color: Colors.black)),
                                  Text('Moisture Levels: ${logEntry['moistureLevel']}',style: const TextStyle(color: Colors.black)),
                                  Text('Nutrient Levels: ${logEntry['nutrientLevel']}',style: const TextStyle(color: Colors.black)),
                                  Text('Pesticide Volume: ${logEntry['pesticideVolume']}',style: const TextStyle(color: Colors.black)),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NavBarRoots()));
                      },
                      child: const Text('Go Back'),
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
                  // Add functionality to close the page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StoringPage()));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

}