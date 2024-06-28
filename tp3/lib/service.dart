
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tp3/transfert.dart';

import 'ecran_accueil.dart';


class FireDB {

  static CollectionReference<Task> getTasks() {
    User? user = FirebaseAuth.instance.currentUser;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('tasks')
        .withConverter<Task>(
      fromFirestore: (doc, _) => Task.fromJson(doc.data()!),
      toFirestore: (task, _) => task.toJson(),
    );
  }

  static Future<List<Task>> getTaskList() async {
    CollectionReference<Task> tasksCollection = getTasks();
    QuerySnapshot<Task> taskscollection = await tasksCollection.get();
    List<Task> taskslist = taskscollection.docs.map((taskdoc) {
      Task t = taskdoc.data();
      t.id = taskdoc.id;
      return t;
    }).toList();
    return taskslist;
  }


  static Future<void> modifyTask(Task task)async {
    CollectionReference<Task> tasksCollection = getTasks();
    DocumentReference<Task> taskDoc = tasksCollection.doc(task.id);
    await taskDoc.set(task);
  }

  static Future<void> addTask(Task task, BuildContext context) async {
    CollectionReference<Task> tasksCollection = getTasks();
    bool same = false;
    var tasks = await tasksCollection.get();

    if (!task.name.isEmpty) {
      if (!DateTime.parse(task.deadline).isBefore(DateTime.now())) {
        for (int i = 0; i < tasks.docs.length; i++) {
          if (tasks.docs[i]
              .data()
              .name == task.name) {
            same = true;
          }
        }

        if (same == false) {
          await tasksCollection.add(task);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const EcranAccueil(),
            ),
          );
        }
        else {
          ScaffoldMessenger.of(context)
              .showSnackBar(
              const SnackBar(content: Text('Le nom est deja utilisé')));
          print('empty string');
          print('same name');
        }
      }
      else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(
            content: Text("La date choisi n'est pas dans le future")));
        print('empty string');
      }
    }
    else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Le nom est vide')));
      print('empty string');
    }
  }
}