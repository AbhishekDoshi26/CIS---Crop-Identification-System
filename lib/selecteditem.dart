import 'package:flutter/material.dart';

class SelectedItem extends StatelessWidget {

  SelectedItem({
    @required this.sciname,
    this.leafsize,
    this.soiltype,
    this.treq,
    this.wreq,
  });

  final sciname;
  final leafsize;
  final soiltype;
  final treq;
  final wreq;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          //fit: StackFit.loose,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomRight,
                    colors: [Colors.black, Colors.purple]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.80,
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
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Padding(padding: const EdgeInsets.only(top: 20)),
                                Text(
                                  "Scientific Name: " + sciname,
                                  softWrap: true,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(fontSize: 20),
                                ),
                                Padding(padding: const EdgeInsets.only(top: 20)),
                                Text(
                                  "Leaf Size: " + leafsize,
                                  softWrap: true,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(fontSize: 20),
                                ),
                                Padding(padding: const EdgeInsets.only(top: 20)),
                                Text(
                                  "Soil Type: " + soiltype,
                                  softWrap: true,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(fontSize: 20),
                                ),
                                Padding(padding: const EdgeInsets.only(top: 20)),
                                Text(
                                  "Water Required: " + wreq,
                                  softWrap: true,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(fontSize: 20),
                                ),
                                Padding(padding: const EdgeInsets.only(top: 20)),
                                Text(
                                  "Time Required: " + treq,
                                  softWrap: true,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}