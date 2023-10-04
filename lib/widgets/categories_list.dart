import 'package:admin_panel/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  @override
  Widget build(BuildContext context) {
    FirebaseServices _service = FirebaseServices();

    DeleteCategory(id) async {
      _service.categories.doc(id).delete();
    }
    showDialoge(title, message, context, id) async {
      return showDialog(
          context: context,
          barrierDismissible: false, //user must make an action
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                child: Text(title),
              ),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("cancel")),
                TextButton(
                    onPressed: () {
                      DeleteCategory(id);
                      Navigator.of(context).pop();
                    },
                    child: const Text("delete")),
              ],
            );
          });
    }

    Widget CategoryWidget(data) {
      return Container(
        height: 300,
        width: 300,
        margin: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Positioned(
                bottom: 0,
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(data['image']), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(20),
                  ),
                )),
            Positioned(
                bottom: 10,
                right: 5,
                child: IconButton(
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    showDialoge("delete category",
                        "Are you sure you want to delete", context, data.id);
                  },
                )),

          ],
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
        stream: _service.categories.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.redAccent,
            ));
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, mainAxisSpacing: 3, crossAxisSpacing: 3),
            itemCount: snapshot.data!.size,
            itemBuilder: (BuildContext context, int index) {
              var data = snapshot.data!.docs[index]; //current category
              return CategoryWidget(data); //pass data to category widget
            },
          );
        });
  }
}
