import 'package:flutter/material.dart';
import 'image_capture_screen.dart';
import 'view_images_screen.dart';

class MainScreen extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    ImageCaptureScreen(),
    ViewImagesScreen(),
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('MelaLens')),
      body:  _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Capture/Upload',
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album),
            label: 'View Images',
            ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        ),
    );
  }

}