import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../services.dart';
import 'Toplistcategories.dart';

class TopList extends StatefulWidget {
  static const String id = "Manage-topList-screeen";
  const TopList({super.key});

  @override
  State<TopList> createState() => _TopListState();
}

class _TopListState extends State<TopList> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController label = TextEditingController();
  FirebaseServices _services = FirebaseServices();
  String filename = '';
  dynamic image;
  //here we can pick some image from the systems
  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        image = result.files.first.bytes;
        filename = result.files.first.name;
      });
    } else {
      print("No image found");
    }
  }
  //after upload we can clear the text field and the container which holds the images for next text and image
  clear() {
    setState(() {
      label.clear();
      image = null;
    });
  }
  //here we can upload the image and save it then we can also add the fields we want to save into our firebase
  uploadFile() async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('gs://transparetncard.appspot.com/PolygonImages/$filename');

    EasyLoading.show(status: "Loading");
    try {
      await ref.putData(image);
      String getdownloadUrl = await ref.getDownloadURL().then((getdownloadUrl) {
        if (getdownloadUrl.isNotEmpty) {
          _services.savedata(data: {
            'image': getdownloadUrl,
            'label': label.text
          }, ref: _services.Polygon_Cliper, docName: label.text).then((value) {
            EasyLoading.dismiss(); //after saving dismiss
            clear();
          });
        }
        return getdownloadUrl;
      });
    } catch (err) {
      print('$err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add new arrivals for the users",
              style: TextStyle(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.teal.shade300,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue, width: 2)),
                      child: InkWell(
                          onTap: () {
                            pickImage();
                            print("Pick");
                          },
                          child: image == null
                              ? const Center(
                            child: Icon(
                              Icons.upload_file,
                              color: Colors.white,
                            ),
                          )
                              : Image.memory(
                            image,
                            fit: BoxFit.fill,
                          ))),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 200,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: label,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter category name";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  label: Text("Enter category name"),
                                  contentPadding: EdgeInsets.zero),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          image == null
                              ? Container()
                              : TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                uploadFile();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.green.shade900),
                            ),
                            child: const Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.green.shade900),
                              ),
                              child: const Text("cancel",
                                  style: TextStyle(color: Colors.white))),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            const Divider(
              thickness: 3,
              color: Colors.redAccent,
            ),
            const Text(
              "All new arrivals",
              style: TextStyle(color: Colors.black),
            ),
            const toplistcategories(),
          ],
        ),
      ),
    );
  }
}
