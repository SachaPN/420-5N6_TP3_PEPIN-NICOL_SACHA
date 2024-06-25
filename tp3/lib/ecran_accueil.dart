import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'tirroir_navigation.dart';

class EcranAccueil extends StatefulWidget {

  const EcranAccueil({super.key});

  @override
  State<EcranAccueil> createState() => _EcranAccueilState();
}

class _EcranAccueilState extends State<EcranAccueil> {

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(date);
    return formatted.toString();
  }

  @override
  initState() {
    super.initState();
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
                  itemCount: 5,
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

                              },
                              child: Container(
                                height: 80.0,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child:
                                      CachedNetworkImage(
                                        imageUrl: "https://1000logos.net/wp-content/uploads/2017/05/Pepsi-logo.png",
                                        width: 20,
                                        fit: BoxFit.fill,
                                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                                            CircularProgressIndicator(value: downloadProgress.progress),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      )
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Nom de la tâche : '),
                                        Text('Date limite : '),
                                        Text('Pourcentage complété : '),
                                        Text('Pourcentage de temps '),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              shape:
                              const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
                            ),
                            onPressed: () {},
                            child: Container(
                              child: Column(
                                children: [
                                  Icon(Icons.delete_forever_outlined),
                                  Text("Supprimer")
                                ],
                              ),
                            ),
                          )
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