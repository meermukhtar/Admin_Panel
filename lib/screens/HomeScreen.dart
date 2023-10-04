import 'package:admin_panel/screens/DashboardScreen.dart';
import 'package:admin_panel/screens/ManageItems.dart';
import 'package:admin_panel/screens/Manage_Categories.dart';
import 'package:admin_panel/widgets/ManageTopList.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id="home_screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _selectedScreen=DashboardScreen();
  currentScreen (item){
    switch (item.route){
      case DashboardScreen.id:
        setState(() {
          _selectedScreen=DashboardScreen();
        });
        break;
        case ManageCategoriesScreen.id:
        setState(() {
          _selectedScreen=ManageCategoriesScreen();
        });
        break;
        case ManageItemsScreen.id:
        setState(() {
          _selectedScreen=const ManageItemsScreen();
        });
        break;
        case TopList.id:
        setState(() {
          _selectedScreen=const TopList();
        });
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
        title:const Center(child:  Text('Admin Panel',style: TextStyle(color: Colors.white),)),
      ),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: DashboardScreen.id,
            icon: Icons.dashboard,
          ),
         AdminMenuItem(
            title: 'Manage Categories',
            route: ManageCategoriesScreen.id,
            icon: Icons.dashboard,
          ),
             AdminMenuItem(
            title: 'Manage items',
            route: ManageItemsScreen.id,
            icon: Icons.pages_rounded,
          ),
          AdminMenuItem(
            title: 'Manage Top items',
            route: TopList.id,
            icon: Icons.list,
          ),

        ],
        selectedRoute:HomeScreen.id,
        onSelected: (item) {
          currentScreen(item);
          // if (item.route != null) {
          //   Navigator.of(context).pushNamed(item.route!);
         // }
        },
        // header: Container(
        //   height: 50,
        //   width: double.infinity,
        //   color: const Color(0xff444444),
        //   child: const Center(
        //     child: Text(
        //       'header',
        //       style: TextStyle(
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: Colors.green.shade900,
          child: const Center(
            child: Row(
              children: [
                CircleAvatar(backgroundImage: AssetImage('assets/Started.jpg'),),
                SizedBox(width: 10,),
                Text(
                  'Admin Panel StarBucks',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: _selectedScreen
      ),
    );
  }
}