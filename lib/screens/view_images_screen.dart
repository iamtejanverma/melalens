import 'package:flutter/material.dart';
import 'dart:io';
import '../services/database_service.dart';

class ViewImagesScreen extends StatefulWidget {

@override
_ViewImagesScreenState createState() => _ViewImagesScreenState();

}

class _ViewImagesScreenState extends State<ViewImagesScreen> {

  late Future<List<Map<String, dynamic>>> _images;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _images = _loadImage();
  }


   Future<List<Map<String, dynamic>>> _loadImage() async {
    final database = await ImageDatabase.instance.database;
    return await database!.query('Images');
    
  }

  Future<void> _deleteImage(int id) async {
    await ImageDatabase.instance.deleteImage(id);
    setState(() {
      _images = _loadImage();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image deleted successfully!')),
      );
  }

  void _confirmDeleteImage(BuildContext content, int id){
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Delete Image'),
          content: Text('Are you sure you want to delete this image?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteImage(id);
                }, 
                child: Text('Delete'),
                ),
          ],
        );
      },
      );
  }
  
@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Manage Images')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
      future: _images, 
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }else if (snapshot.hasError) {
          return Center(child: Text('Error loading images'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty){
          return Center(child: Text('No images available.'));
        }else {
          final images = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              ), 
              itemCount: images.length,
              itemBuilder: (context, index){
                final imagePath = images[index]['path'];
                final imageId = images[index]['id'];
                return Stack(
                  children: [
                    Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDeleteImage(context, imageId),
                      ),
                      ),
                      
                  ],
                );
                return Image.file(File(imagePath));
              },
              );
        }
      },
      )
      );
  }



}