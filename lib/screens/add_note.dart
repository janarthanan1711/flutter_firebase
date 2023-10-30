import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/firestore_service.dart';

class AddNoteScreen extends StatefulWidget {
  User user;

  AddNoteScreen(this.user);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isLoadintg = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Title",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Description",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: descriptionController,
                minLines: 5,
                maxLines: 10,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                  child: Container(
                    color: Colors.orange,
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: isLoadintg
                          ? CircularProgressIndicator()
                          : Text(
                              "Add Note",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                    ),
                  ),
                  onTap: () async {
                    if (titleController.text == "" ||
                        descriptionController.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("All fields are required!"),
                        backgroundColor: Colors.red,
                      ));
                    } else {
                      setState(() {
                        isLoadintg = true;
                      });
                      await FireStoreServices().insertNote(titleController.text,
                          descriptionController.text, widget.user.uid);
                      setState(() {
                        isLoadintg = false;
                      });
                      Navigator.pop(context);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
