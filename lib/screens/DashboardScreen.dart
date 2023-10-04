import 'package:admin_panel/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  static const String id = "dashboard-screeen";
  FirebaseServices _services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    Widget analyticwidget({required String title, required String value}) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          height: 100,
          width: 200,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(value, style: const TextStyle(color: Colors.white)),
                    const Icon(
                      Icons.show_chart,
                      color: Colors.white,
                      size: 25,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _services.users.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container( height: 100,
                        width: 200,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue),child: Center(
                          child: CircularProgressIndicator(color: Colors.green.shade900,),
                        )),
                  );
                }
                if (snapshot.hasData) {
                  return analyticwidget(
                    title: 'total user',
                    value: snapshot.data!.size.toString(),
                  );
                }

                return const SizedBox();
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _services.categories.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return  Text('Something went wrong ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container( height: 100,
                        width: 200,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue),child: Center(
                          child: CircularProgressIndicator(color: Colors.green.shade900,),
                        )),
                  );
                }
                if (snapshot.hasData) {
                  return analyticwidget(
                    title: 'Total categories',
                    value: snapshot.data!.size.toString(),
                  );
                }

                return const SizedBox();
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _services.Polygon_Cliper.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container( height: 100,
                        width: 200,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue),child: Center(
                          child: CircularProgressIndicator(color: Colors.green.shade900,),
                        )),
                  );
                }
                if (snapshot.hasData) {
                  return analyticwidget(
                    title: 'New items added',
                    value: snapshot.data!.size.toString(),
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        )
      ],
    );
  }
}
