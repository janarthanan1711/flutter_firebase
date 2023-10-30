import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/note_model.dart';
import 'package:flutter_firebase/services/firestore_service.dart';

class EditNoteScreen extends StatefulWidget {
  NoteModel notes;

  EditNoteScreen(this.notes);

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    titleController.text = widget.notes.title;
    descriptionController.text = widget.notes.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [IconButton(onPressed: () async{
          await showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              title: Text("Please Confirm"),
              content: Text("Are you sure to delete?"),
              actions: [
                TextButton(onPressed: ()async{
                  await FireStoreServices().deleteNote(widget.notes.id);
                  //CLOSE DIALOG
                  Navigator.pop(context);
                  //CLOSE EDIT SCREEN
                  Navigator.pop(context);
                }, child: Text("Yes")),
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text("No"))
              ],
            );
          });
        }, icon: Icon(Icons.delete,color: Colors.red,))],
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
                    child: Text(
                      "Update Note",
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
                      isLoading = true;
                    });
                    await FireStoreServices().updateNote(widget.notes.id, titleController.text, descriptionController.text);
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
