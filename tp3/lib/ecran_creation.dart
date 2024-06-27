import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tp3/service.dart';

import 'package:tp3/transfert.dart';
import 'ecran_accueil.dart';
import 'tirroir_navigation.dart';

class EcranCreation extends StatefulWidget {

  const EcranCreation({super.key});

  @override
  State<EcranCreation> createState() => _EcranCreationState();
}

class _EcranCreationState extends State<EcranCreation> {

  final TextEditingController textControllerTaskName = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: TirroirNavigation(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Création'),
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
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Text(
                  'Création',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 35,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(18),
                child: TextField(
                  controller: textControllerTaskName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Nom de la tâche",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(18),
                child: TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    filled: false,
                    prefixIcon: Icon(Icons.calendar_today),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurpleAccent)
                    ),
                  ),
                  readOnly: true,
                  onTap: (){
                    _selectDate();
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(18),
                child: ElevatedButton(
                  onPressed: () async {
                    User? user = FirebaseAuth.instance.currentUser;
                    Task task = Task();

                    task.creationDate = DateTime.now().toString();
                    task.userid = user!.uid;
                    task.name = textControllerTaskName.text;
                    task.deadline = _dateController.text.toString();
                    task.percentageDone = 0;
                    task.percentageTimeSpent = 0;
                    task.photoId = 0;

                    await FireDB.addTask(task, context);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EcranAccueil(),
                      ),
                    );
                  },
                  child: Text(
                    'Ajout de la tâche',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if(_picked != null){
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }
}