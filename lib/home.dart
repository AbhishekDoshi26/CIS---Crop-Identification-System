import 'package:cis/crop_details.dart';
import 'package:cis/selecteditem.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';

class BackendService {
  static final List<String> crops = [
    'Wheat',
    'Rice',
    'Bajra',
    'Maize',
    'Cotton',
    'Sugarcane',
    'Coffee',
    'Coconut',
    'Groundnut',
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = List();
    matches.addAll(crops);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController search = TextEditingController();
  final db = Firestore.instance;
  File _imageFile;
  String fileName;
  List _outputs;
  bool _loading = false;
  final sciname = "";
  final leafsize = "";
  final soiltype = "";
  final treq = "";
  final wreq = "";

  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Text('Take a picture'),
                    onTap: openCamera,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    child: new Text('Select from gallery'),
                    onTap: openGallery,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future openGallery() async {
    Navigator.of(context).pop();
    var image;
    image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _imageFile = image;
    });
    classifyImage(image);
  }

  Future openCamera() async {
    Navigator.of(context).pop();
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      _imageFile = image;
    });
    classifyImage(image);
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    print(output[0]['label']);
    setState(() {
      _loading = false;
      _outputs = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          //shape: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(icon: Icon(Icons.refresh,size: 32,), tooltip: 'Refresh', onPressed: () {
                setState(() {
                  _imageFile=null;  
                });
              }),
              IconButton(icon: Icon(Icons.power_settings_new,size: 32,), tooltip: 'Exit', onPressed: () {exit(1);}),
            ],
          ),
        ),),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          height: 50.0,
          child: RawMaterialButton(
            elevation: 10,
            fillColor: Colors.deepPurpleAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            onPressed: _optionsDialogBox,
            child: Icon(
              Icons.camera,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        body: Stack(
          //fit: StackFit.loose,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomRight,
                    colors: [Colors.black, Colors.deepPurple]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.70,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0)),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.indigo[400], Colors.purple[200]]),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(10)),
                        SizedBox(
                          height: 50,
                        ),
                        _imageFile == null
                            ? Container(
                              child: Image.asset('assets/images/CIS.png', scale: 1.35,),
                            )
                            : Padding(
                                padding: const EdgeInsets.all(
                                  10.0,
                                ),
                                child: Image.file(
                                  _imageFile,
                                  height: 300.0,
                                  width: 300.0,
                                ),
                              ),
                      ],
                    ),
                  ),
                  _imageFile == null
                      ? Container(
                        height: 100,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Crop Identification System',style: TextStyle(fontSize: 28, color: Colors.white,fontWeight: FontWeight.bold),),
                        ],
                      ))
                      : Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: InkWell(
                            splashColor: Colors.black87,
                            onTap: () {
                              print("${_outputs[0]["label"]}");
                              DocumentReference documentReference = db
                                  .collection("Crops")
                                  .document("${_outputs[0]["label"]}");
                              documentReference.get().then((datasnapshot) {
                                if (datasnapshot.exists) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CropDetails(
                                          title: "${_outputs[0]["label"]}",
                                          sciname: datasnapshot
                                              .data['Scientific Name']
                                              .toString(),
                                          leafsize: datasnapshot
                                              .data['Leaf Size']
                                              .toString(),
                                          soiltype: datasnapshot
                                              .data['Soil Type']
                                              .toString(),
                                          treq: datasnapshot
                                              .data['Time Required']
                                              .toString(),
                                          wreq: datasnapshot
                                              .data['Water Required']
                                              .toString(),
                                        ),
                                      ));
                                }
                              });
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                height: 60,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _outputs != null
                                        ? Text(
                                            "${_outputs[0]["label"]}",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          )
                                        : Text(
                                            'No Data',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(top: 10.0, left: 10, right: 80),
                  //   child: TextField(
                  //     style: TextStyle(
                  //       fontSize: 22.0,
                  //     ),
                  //     keyboardType: TextInputType.text,
                  //     decoration: InputDecoration(
                  //       prefixIcon: Icon(Icons.search),
                  //       fillColor: Colors.white,
                  //       filled: true,
                  //       hintText: 'search',
                  //       border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(100.0)),
                  //       contentPadding:
                  //           EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  //     ),
                  //     controller: search,
                  //     onChanged: getSuggestion,
                  //   ),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'search',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0)),
                    contentPadding:
                        EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  return await BackendService.getSuggestions(pattern);
                },
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent),
                itemBuilder: (context, suggestion) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(suggestion),
                        ],
                      ),
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  DocumentReference documentReference =
                      db.collection("Crops").document(suggestion);
                  documentReference.get().then((datasnapshot) {
                    if (datasnapshot.exists) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CropDetails(
                              title: suggestion,
                              sciname: datasnapshot.data['Scientific Name']
                                  .toString(),
                              leafsize:
                                  datasnapshot.data['Leaf Size'].toString(),
                              soiltype:
                                  datasnapshot.data['Soil Type'].toString(),
                              treq: datasnapshot.data['Time Required']
                                  .toString(),
                              wreq: datasnapshot.data['Water Required']
                                  .toString(),
                            ),
                          ));
                    }
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
