
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tp3/transfert.dart';

CollectionReference<Task> getTasks(){
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

void addTask(Task task) async {

  CollectionReference<Task> tasksCollection = getTasks();

  //var gg = await tasksCollection.get();
  //gg.docs.length


  await tasksCollection.add(task);

}