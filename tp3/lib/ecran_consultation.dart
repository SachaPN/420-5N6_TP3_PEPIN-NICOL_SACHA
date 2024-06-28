import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tp3/service.dart';
import 'package:tp3/transfert.dart';
import 'tirroir_navigation.dart';

class EcranConsultation extends StatefulWidget {

  final String id;

  const EcranConsultation({Key? key, required this.id}) : super(key: key);

  @override
  State<EcranConsultation> createState() => _EcranConsultationState();
}

class _EcranConsultationState extends State<EcranConsultation> {

  final TextEditingController textController = TextEditingController();

  List<Task> _tasks = [];
  Task _task = Task();

  String pourcentage (DateTime deadline, DateTime dateCrea) {

    Duration diffDeadlineNow = deadline.difference(DateTime.now());

    Duration total = deadline.difference(dateCrea);

    double result = (diffDeadlineNow.inMinutes / total.inMinutes * 100).truncateToDouble() as double ;

    return result.toString();
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
                              '${pourcentage(DateTime.parse(_task.deadline), DateTime.parse(_task.creationDate))} % du temps écoulé depuis le début'
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
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

              //await getUpdateTask(int.parse(textController.text));
              //await getTaskDetails();

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