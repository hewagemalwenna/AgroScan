import "package:agroscan/screens/treatment_screen.dart";
import "package:tflite_v2/tflite_v2.dart";
import "package:image_picker/image_picker.dart";
import "package:flutter/material.dart";
import "dart:io";

import "../widgets/navbar.dart";

class TfModel extends StatefulWidget {
  const TfModel({super.key});

  @override
  State<TfModel> createState() => _TfModelState();
}

class _TfModelState extends State<TfModel> {

  //initializing variables
  late File _image;
  late List<dynamic> _output = [];
  bool _loading = true;
  final picker = ImagePicker();

  //initState method to load the model
  @override
  void initState(){
    super.initState();
    loadModel().then((value){
      setState(() {

      });

    });
  }

  //dispose method to close the model for inference and memory management
  @override
  void dispose(){
    super.dispose();
    Tflite.close();

  }

  //method to load the model
  loadModel()async{
    await Tflite.loadModel(model: "assets/model4.tflite", labels: "assets/labels2.txt");

  }

  //running inference on the image captured
  classfyingImage(File image) async{
    var output = await Tflite.runModelOnImage(path: image.path,
      numResults: 46,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd:  127.5,

    );
    setState(() {
      _output = output!;
      _loading = false;
    });
  }

  //getting the image from camera method
  pickImageFromCamera()async{
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image=File(image.path);

    });
    classfyingImage(_image);
  }

  //getting the image from gallery method
  pickImageFromGallery()async{
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);

    });
    classfyingImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/TfModel_back_image.jpg"),//adding background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height:150),// to add more space to display the contents
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: _loading?
                  SizedBox(
                    width: 280,
                    child: Column(
                      children: [
                        Image.asset("assets/images/modelpic.jpg"),// added image before prediction
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  )
                      :Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        SizedBox(
                          height: 250,
                          child: Image.file(_image),// adding image which is scanned and chosen from gallery or camera
                        ),
                          const SizedBox(
                        height: 20,
                        ),
                        //_output!=null
                          _output.isNotEmpty && _output[0].containsKey("label")// checking if output from model is not empty
                          ? Text("Predicted leaf type: ${_output[0]["label"]}",
                        style: const TextStyle(
                            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                        )
                          :const Text("Plant leaf not recognized, try again",// displaying if model does not recognize an output
                        style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                        ),

                        const SizedBox(
                        height: 30,
                      )
                        ],
                  ),

                ),

                //// making the open camera button
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: pickImageFromCamera,
                        child: Container(
                          width: MediaQuery.of(context).size.width-150,
                          alignment: Alignment.center,
                          padding:
                          const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),

                          ),



                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Open camera",
                              ),
                            ],
                          ),

                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      //making the open gallery button
                      ElevatedButton(
                        onPressed: pickImageFromGallery,
                        child: Container(
                          width: MediaQuery.of(context).size.width-150,
                          alignment: Alignment.center,
                          padding:
                          const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),

                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Icon(
                            Icons.photo_library,
                          ),
                            SizedBox(width: 10),

                            Text(
                            "Open gallery",
                          ),
                          ],

                        ),

                      ),
                      ),
                    ],
                  ),
                )

              ],
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
                          builder: (context) => const NavBarRoots()));
                },
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 80, // Adjusted bottom value to move the button up
            child: Center(
              child: Visibility(
                visible: _output.isNotEmpty && _output[0].containsKey("label")
              && !healthyLabels.contains(_output[0]["label"]),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                             TreatmentPage(predictionData: PredictionData(_output[0]["label"]))
                    ), // Navigate to TreatmentPage
                  );
                },
                child: const Text('Show treatment to disease'),
              ),
              )
            ),
          ),
        ],
      ),
    );
  }
}

//created a class to get the label prediction
class PredictionData{
  late final String label;

  PredictionData(this.label);
}

//list of healthy types of plants and gets stored in healthyLables array
List<String> healthyLabels = ["Apple healthy","Blueberry healthy","Cherry(including_sour)healthy","Cinnamon healthy","Corn (maize)healthy","Grape healthy"
"Peach healthy","Pepper bell healthy","Potato healthy","Raspberry healthy","Soybean healthy",
"Strawberry healthy","Tea healthy","Tomato healthy",];
