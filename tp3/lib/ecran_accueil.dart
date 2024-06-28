import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tp3/ecran_creation.dart';
import 'package:tp3/service.dart';
import 'package:tp3/transfert.dart';

import 'ecran_consultation.dart';
import 'tirroir_navigation.dart';

class EcranAccueil extends StatefulWidget {

  const EcranAccueil({super.key});

  @override
  State<EcranAccueil> createState() => _EcranAccueilState();
}

class _EcranAccueilState extends State<EcranAccueil> {

  List<Task> _tasks = [];

  Future<void> getTaskList() async {
    _tasks = await FireDB.getTaskList();
    setState(() {
    });
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(date);
    return formatted.toString();
  }

  String pourcentage (DateTime deadline, DateTime dateCrea) {

    int daysBetween(DateTime from, DateTime to) {
      from = DateTime(from.year, from.month, from.day);
      to = DateTime(to.year, to.month, to.day);
      return (to.difference(from).inHours / 24).round();
    }

    int diffCreaDealine = daysBetween(dateCrea, deadline);
    int diffNowAndDeadline = daysBetween(DateTime.now(), deadline);

    double result = (diffNowAndDeadline / diffCreaDealine * 100).truncateToDouble();

    result = 100 - result;

    return result.toString();
  }

  @override
  initState() {
    super.initState();
    getTaskList();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: TirroirNavigation(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Accueil'),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(18),
              child: Text(
                'Accueil',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 35,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(18),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EcranCreation(),
                    ),
                  );
                },
                child: Text(
                  "Création d'une tâche",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            //thebool == true ?
            Expanded(
              child: Container(
                margin: EdgeInsets.all(18),
                child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {

                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.deepPurpleAccent)
                      ),
                      margin: EdgeInsets.all(18),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape:
                                const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EcranConsultation(
                                      id: _tasks[index].id,
                                      pourcentage: pourcentage(DateTime.parse(_tasks[index].deadline), DateTime.parse(_tasks[index].creationDate)),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 80.0,
                                child: Row(
                                  children: [
                                    (_tasks[index].photoId != '')?
                                    Expanded(
                                      child:CachedNetworkImage(
                                        imageUrl: _tasks[index].photoId,
                                        width: 20,
                                        fit: BoxFit.fill,
                                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                                            CircularProgressIndicator(value: downloadProgress.progress),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      )
                                    ):
                                    Container(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Nom de la tâche : ${_tasks[index].name}'),
                                        Text('Date limite : ${_tasks[index].deadline}'),
                                        Text('Pourcentage complété : ${_tasks[index].percentageDone}'),
                                        Text('Pourcentage de temps écoulé: ${pourcentage(DateTime.parse(_tasks[index].deadline), DateTime.parse(_tasks[index].creationDate))}'),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}