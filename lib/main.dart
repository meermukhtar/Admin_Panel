import 'package:admin_panel/screens/HomeScreen.dart';
import 'package:admin_panel/screens/ManageItems.dart';
import 'package:admin_panel/screens/Manage_Categories.dart';
import 'package:admin_panel/web_connection/firebaseOption.dart';
import 'package:admin_panel/widgets/ManageTopList.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admil Panel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        HomeScreen.id:(context)=>HomeScreen(),
        ManageItemsScreen.id:(context)=>const ManageItemsScreen(),
        ManageCategoriesScreen.id:(context)=> ManageCategoriesScreen(),
        TopList.id:(context)=>TopList(),
      },
      builder: EasyLoading.init(),
       home: HomeScreen(),
    );
  }
}
