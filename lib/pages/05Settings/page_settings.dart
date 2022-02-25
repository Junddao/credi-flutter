import 'package:crediApp/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:crediApp/global/util.dart';

class PageSettings extends StatefulWidget {
  @override
  _PageSettingsState createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  @override
  void initState() {
    super.initState();
    // Add code after super
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: CDColors.nav_title),
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          title: Text('Settings'),
          actions: [IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)],
        ),
        body: Text("Settings"));
  }

  void _pushSaved() {
    logger.i("push_saved");
  }
}
