// import 'package:file_picker/file_picker.dart';
//categories
import 'dart:html';
import 'package:admin_panel/services.dart';
import 'package:admin_panel/widgets/categories_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ManageCategoriesScreen extends StatefulWidget {
  static const String id = "Manage-Categories-screeen";

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name_Items = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController description = TextEditingController();
  FirebaseServices _services = FirebaseServices();
  dynamic image;

  String filename = '';

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

  clear() {
    setState(() {
      name_Items.clear();
      description.clear();
      price.clear();
      image = null;
    });
  }

  uploadFile() async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('gs://transparetncard.appspot.com/CategoriesImages/$filename');

    EasyLoading.show(status: "Loading");
    try {
      await ref.putData(image);
      String getdownloadUrl = await ref.getDownloadURL().then((getdownloadUrl) {
        if (getdownloadUrl.isNotEmpty) {
          _services.savedata(data: {
            'image': getdownloadUrl,
            'description': description.text,
            'item_name': name_Items.text,
            'price': price.text
          }, ref: _services.categories, docName: name_Items.text).then((value) {
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
              "add categories",
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
                              controller: name_Items,
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
                            TextFormField(
                              controller: price,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter Description";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  label: Text("Enter price\$"),
                                  contentPadding: EdgeInsets.zero),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: description,
                              minLines: 1,
                              maxLines: 4,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter Description";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  label: Text("Enter category name"),
                                  contentPadding: EdgeInsets.zero),
                            ),
                            const SizedBox(
                              height: 5,
                            )
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
              "All categories",
              style: TextStyle(color: Colors.black),
            ),
            const CategoriesList(),
          ],
        ),
      ),
    );
  }
  //
  // Future<void> getSelectedItemID(String name_Items) async {
  //   var collection = FirebaseFirestore.instance.collection('categories');
  //   var querySnapshot =
  //       await collection.where('item_name', isEqualTo: name_Items).get();
  //
  //   if (querySnapshot.docs.isNotEmpty) {
  //     var selectedDocument = querySnapshot.docs.first;
  //     var documentID = selectedDocument.id; // <-- Document ID
  //     String image = selectedDocument.get('image');
  //     String item_name = selectedDocument.get('item_name');
  //     String price = selectedDocument.get('price');
  //     String description = selectedDocument.get('description');
  //     //from there we can pass the id
  //     print('The ID of the selected item $name_Items :: $documentID');
  //   } else {
  //     print('No item with name $name_Items found.');
  //   }
  // }
}
