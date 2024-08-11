class ImageModel {
  final int? id;
  final String path;
  

  ImageModel({this.id, required this.path,});

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'path' : path,
    };
  }

  //COnverting map into Imagemodel
  factory ImageModel.fromMap(Map<String, dynamic> map){
    return ImageModel(
      id: map['id'], 
      path: map['path'],
      );
  }
}