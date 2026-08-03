import 'package:agroscan/Model/plant_data.dart';
import 'package:agroscan/screens/signin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widgets/navbar.dart';
import 'log_screen.dart';

// ignore: must_be_immutable
class StoringPage extends StatelessWidget {
  StoringPage({Key? key}) : super(key: key);

  final TextEditingController plantTypeController = TextEditingController();
  final TextEditingController moistureLevelController = TextEditingController();
  final TextEditingController nutrientLevelController = TextEditingController();
  final TextEditingController pesticideVolumeController = TextEditingController();
  Plantdata? plantname;

  Future<void> _updateFirestore() async {

    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final logs = db.collection("Logs").doc(await getUserId());
      if (await logs.get().then((snapshot) => snapshot.exists)) {
        //logs.update(widget.plantdata.toJson());
        logs.update(
            {"log": FieldValue.arrayUnion([plantname?.toJson()])});
      } else {
        logs.set( {"log": FieldValue.arrayUnion([plantname?.toJson()])});
      }
    } catch (e) {
      // Handle any errors
      if (kDebugMode) {
        print("Error updating Firestore: $e");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    String plantType = "";
    late int moistureLevel;
    late int nutrientLevel;
    late int pesticideVolume;


    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/cinammon.jpg"), // Your image path here
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Container(
                width: 300,
                height: 450,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7), // Opacity set to 70%
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // TextField for selecting plant type
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 13, horizontal: 19),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 195, 253, 114)
                            .withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        style: const TextStyle(color: Colors.black),
                        controller: plantTypeController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter plant type',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        onChanged: (value) => plantType = value,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 13, horizontal: 19),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 195, 253, 114)
                            .withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:  TextField(
                          style: const TextStyle(color: Colors.black),
                          controller: moistureLevelController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter moisture level',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          onChanged: (value) {
                            moistureLevel = int.tryParse(value) ?? 0;



                          }
                      ),
                    ),

                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 13, horizontal: 19),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 195, 253, 114)
                            .withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:  TextField(
                          style: const TextStyle(color: Colors.black),
                          controller: nutrientLevelController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter nutrient level',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          onChanged: (value) {
                            nutrientLevel = int.tryParse(value) ?? 0;
                          }
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 13, horizontal: 19),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 195, 253, 114)
                            .withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                          style: const TextStyle(color: Colors.black),
                          controller: pesticideVolumeController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter pesticide volume',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          onChanged: (value) {
                            pesticideVolume = int.tryParse(value) ?? 0;
                          }
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
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
                          builder: (context) => const NavBarRoots()));
                },
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: ElevatedButton(
              onPressed: () async {
                if (plantTypeController.text.isNotEmpty&& moistureLevelController.text.isNotEmpty&&nutrientLevelController.text.isNotEmpty&&pesticideVolumeController.text.isNotEmpty){
                  plantname = Plantdata(plantType: plantType, moistureLevel: moistureLevel, nutrientLevel: nutrientLevel, pesticideVolume: pesticideVolume);
                  await _updateFirestore();
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LogScreenPage(
                                plantType: plantType,
                                moistureLevel: moistureLevel,
                                nutrientLevel: nutrientLevel,
                                pesticideVolume: pesticideVolume,
                                message: 'Log of the Plants',
                                plantdata: Plantdata(plantType: plantType,
                                    moistureLevel: moistureLevel,
                                    nutrientLevel: nutrientLevel,
                                    pesticideVolume: pesticideVolume)
                            ),
                      ),
                    );
                  }
                }
                else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogScreenPage(
                          plantType:"",
                          moistureLevel:0,
                          nutrientLevel: 0,
                          pesticideVolume: 0,
                          message: 'Log of the Plants',
                          plantdata: Plantdata(plantType: "", moistureLevel: 0, nutrientLevel: 0, pesticideVolume: 0)
                      ),
                    ),
                  );
                }

              },
              child: const Text('LOG'),
            ),
          ),
        ],
      ),
    );
  }

  void setState(String Function() param0) {}

  void getUid() {}
}

class Get {
  static find() {}

  static snackbar(String s, String t) {}
}
