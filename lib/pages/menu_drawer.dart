import 'package:doctorapp/pages/dashboard/home.dart';
import 'package:flutter/material.dart';

class MySideDrawer extends StatefulWidget {
  const MySideDrawer({Key? key}) : super(key: key);

  @override
  State<MySideDrawer> createState() => _MySideDrawerState();
}

class _MySideDrawerState extends State<MySideDrawer> {
  late int selectedMenuItemId;

  @override
  void initState() {
    super.initState();
    selectedMenuItemId = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        child: const Home(),
      ),
    );
  }
}
