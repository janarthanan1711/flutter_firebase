import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/note_model.dart';
import 'package:flutter_firebase/screens/add_note.dart';
import 'package:flutter_firebase/screens/edit_note.dart';
import 'package:flutter_firebase/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  User user;
  HomeScreen(this.user);
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: Colors.pink,
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () async {
              await AuthService().signOut();
            },
            icon: const Icon(Icons.logout),
            label: const Text("Sign out"),
            style: TextButton.styleFrom(primary: Colors.white),
          )
        ],
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection("notes").where("userId",isEqualTo: user.uid).snapshots(),
        builder: (context,AsyncSnapshot snapshot){
          if(snapshot.hasData){
            if(snapshot.data.docs.length >0){
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                  itemBuilder: (context,index){
                    NoteModel notes = NoteModel.fromJson(snapshot.data.docs[index]);
                    return Card(
                      color: Colors.teal,
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        title: Text(
                          notes.title,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          notes.description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => EditNoteScreen(notes)));
                        },
                      ),
                    );
                  });
            }else{
              return Center(
                child: Text("No Notes"),
              );
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddNoteScreen(user)));
        },
        backgroundColor: Colors.orangeAccent,
        child: Icon(Icons.add),
      ),
      // body: Container(
      //   width: MediaQuery.of(context).size.width,
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       ElevatedButton(
      //         onPressed: () async {
      //           CollectionReference users =
      //               firebaseFirestore.collection("users");
      //           // await users.add({
      //           //   "name":"Jana"
      //           // });
      //           await users.doc("FlutterUsers1").set({"name": "Manoj"});
      //         },
      //         child: Text("Add data to firestore"),
      //       ),
      //       SizedBox(height: 10,),
      //       ElevatedButton(
      //         onPressed: () async{
      //           CollectionReference users = firebaseFirestore.collection("users");
      //           // QuerySnapshot allResults = await users.get();
      //           // allResults.docs.forEach((DocumentSnapshot result) {
      //           //   print(result.data());
      //           // });
      //           DocumentSnapshot result = await users.doc("FlutterUsers1").get();
      //           print(result.data());
      //           // users.doc("FlutterUsers1").snapshots().listen((event) {
      //           //   print(event.data());
      //           // });
      //         },
      //         child: Text("Read data from firebase"),
      //       ),
      //       SizedBox(
      //         height: 10,
      //       ),
      //       ElevatedButton(onPressed: ()async{
      //         await firebaseFirestore.collection('users').doc("FlutterUsers1").update({
      //           "name":"Manoj bhaiyya"
      //         });
      //       }, child: Text("Update Data"),),
      //       SizedBox(height: 10,),
      //       ElevatedButton(onPressed: ()async{
      //         await firebaseFirestore.collection("users").doc("FlutterUsers1").delete();
      //       }, child: Text("Delete Data"),)
      //     ],
      //   ),
      // ),
    );
  }
}
