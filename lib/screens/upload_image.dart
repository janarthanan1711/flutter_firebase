import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageStorage extends StatefulWidget {
  const UploadImageStorage({super.key});

  @override
  State<UploadImageStorage> createState() => _UploadImageStorageState();
}

class _UploadImageStorageState extends State<UploadImageStorage> {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  bool loading = false;

  Future<void> uploadImage(String imageSource) async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
        source:
            imageSource == "camera" ? ImageSource.camera : ImageSource.gallery);
    if (pickedImage == null) {
      return null;
    }
    String fileName = pickedImage.name;
    File imageFile = File(pickedImage.path);
    try {
      setState(() {
        loading = true;
      });
      await firebaseStorage.ref(fileName).putFile(imageFile);
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Successfully Uploaded")));
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List> loadFiles() async {
    List<Map> files = [];
    final ListResult result = await firebaseStorage.ref().listAll();
    final List<Reference> allfiles = result.items;
    await Future.forEach(allfiles, (Reference file) async {
      final String fileUrl = await file.getDownloadURL();
      files.add({"url": fileUrl, "path": file.fullPath});
    });
    return files;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload to firebase storage"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.camera),
                          label: Text("Camera")),
                      ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.library_add),
                          label: Text("Gallery"))
                    ],
                  ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: FutureBuilder(
                future: loadFiles(),
                builder: (context,AsyncSnapshot snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(),);
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.length ?? 0,
                    itemBuilder: (context,index){
                       final Map image = snapshot.data[index];
                       return Row(
                         children: [
                           Expanded(child: Card(
                             child: Container(
                               height: 200,
                               child: Image.network(image['url']),
                             ),
                           ),),

                         ],
                       );
                    },
                      );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
