import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/database_service.dart';
import 'dart:io';

class ImageCaptureScreen extends StatefulWidget{
  @override
  _ImageCaptureScreenState createState() => _ImageCaptureScreenState();

}

class _ImageCaptureScreenState extends State<ImageCaptureScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  void _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null){
      setState(() {
        _image = File(pickedFile.path);
        //_saveImage(_image!.path);
      });
      //_showConfirmationDialog();  // or 
      _showConfirmationBottomSheet();
    }
  }

  Future<void> _showConfirmationDialog() async{
    if (_image == null) return;

    bool? confirmed = await showDialog(
      context: context, 
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.file(
                  _image!,
                  fit: BoxFit.contain,
                  height: 200,
                ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Are you sure you want to use this image?'),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).pop(false);
                        },
                        child: Text('No'),
                        ),
                        TextButton(
                          onPressed: (){
                            Navigator.of(context).pop(true);

                          }, 
                          child: Text('Yes'),
                          ),
                    ],
                  ),
                  SizedBox(height: 20),            
            ],

          ),
        );
        
      },
    );
    if (confirmed == true){
      _saveImage(_image!.path);
    }else{
      setState(() {
        _image = null;
      });
    }
  }

  void _uploadImage() async {
    
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if(pickedFile != null){
      setState(() {
        
        _image = File(pickedFile.path);
        //_saveImage(_image!.path);
      });
      _showConfirmationBottomSheet();
      //_showConfirmationDialog();
    }

  }

Future<void> _showConfirmationBottomSheet() async {
  if (_image == null) return;

  bool? confirmed = await showModalBottomSheet(
    context: context, 
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (BuildContext context){
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(
              _image!,
              fit: BoxFit.contain,
              height: 200,
            ),
            SizedBox(height: 20),
            Text('Are you sure you want to use this image?'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: (){
                    Navigator.of(context).pop(false);
                  },
                  child: Text('No'),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.of(context).pop(true);
                    },
                     child: Text('Yes'),
                  ),
              ],
            ),
          ],
        ),
  );
    },
  );

  if (confirmed == true){
    _saveImage(_image!.path);
  } else{
    setState(() {
      _image = null;
    });
  }

}


                     
              
     

  
  Future<void> _saveImage(String imagePath) async {
    final database = await ImageDatabase.instance.database;
    await database?.insert('Images', {'path': imagePath});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image stored successfully!')),
      );
  }

 
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: _captureImage, 
            child: Text('Capture Image'),
            ),
            SizedBox(height: 10),
          ElevatedButton(
            onPressed: _uploadImage, 
            child: Text('Upload Image'),
            ),
            SizedBox(height: 20,),
            _image == null
            ? Text("No image selected.")
            :Image.file(_image!),
        ],
      ),
    );
  }
}