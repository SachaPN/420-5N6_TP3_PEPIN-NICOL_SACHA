import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tp3/service.dart';
import 'package:tp3/transfert.dart' as t;
import 'tirroir_navigation.dart';

class EcranConsultation extends StatefulWidget {

  final String id;
  final String pourcentage;

  const EcranConsultation({Key? key, required this.id, required this.pourcentage}) : super(key: key);

  @override
  State<EcranConsultation> createState() => _EcranConsultationState();
}

class _EcranConsultationState extends State<EcranConsultation> {

  final TextEditingController textController = TextEditingController();

  List<t.Task> _tasks = [];
  t.Task _task = t.Task();

  final picker = ImagePicker();
  var _imageFile;
  String imageURL = '';

  Future postImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);

      DocumentReference imageDoc = await FirebaseFirestore.instance.collection('images').add({
        'url' : ''
      });

      Reference imageRef = await FirebaseStorage.instance.ref(imageDoc.id);
      await imageRef.putFile(_imageFile);
      imageURL = await imageRef.getDownloadURL();

      imageDoc.update({
        'url' : imageURL
      });

      _task.photoId = imageURL;
      await FireDB.modifyTask(_task);

      setState(() {

      });
    }
    else {
      print('Pas de choix effectue.');
    }
  }

  Future<void> getTaskList() async {
    _tasks = await FireDB.getTaskList();
    setState(() {
    });
  }

  Future<void> getTask() async {
    await getTaskList();
    _task = _tasks.where((x) => x.id == widget.id).single;
  }

  @override
  initState() {
    super.initState();
    getTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: TirroirNavigation(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Consultation'),
        leading: Builder(
          builder: (context){
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(18),
                child: Text(
                  'Consultation',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 35,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.deepPurpleAccent)
                ),
                margin: EdgeInsets.all(18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 56.0,
                      child: Row(
                        children: [
                          Text(
                              '${_task.name}'
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.deepPurpleAccent)
                ),
                margin: EdgeInsets.all(18),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          height: 56.0,
                          margin: EdgeInsets.fromLTRB(18, 0, 0, 0),
                          child: Row(
                            children: [
                              Text("${_task.percentageDone} % d'avancement")
                            ],
                          ),
                        )
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        shape:
                        const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      onPressed: () {
                        openDialogue();
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Icon(Icons.edit),
                            Text("Modifier %")
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.deepPurpleAccent)
                ),
                margin: EdgeInsets.all(18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 56.0,
                      child: Row(
                        children: [
                          Text(
                              'Échéance pour le ${_task.deadline}'
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.deepPurpleAccent)
                ),
                margin: EdgeInsets.all(18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 56.0,
                      child: Row(
                        children: [
                          Text(
                              '${widget.pourcentage} % du temps écoulé depuis le début'
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              (_task.photoId != '')?
              CachedNetworkImage(
                imageUrl: _task.photoId,
                width: 200,
                fit: BoxFit.fill,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ) : Container(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    postImage();
                  });
                },
                child: Text('Choisir une image'),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  Future openDialogue() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Nouveau pourcentage d'avancement"),
        content: TextField(
          controller: textController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
              hintText: "Entrer le pourcentage"
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              _task.percentageDone = int.parse(textController.text);
              await FireDB.modifyTask(_task);
              setState(() {
              });
              Navigator.of(context).pop();
            },
            child: Text("Mettre à jour"),
          ),
        ],
      )
  );
}