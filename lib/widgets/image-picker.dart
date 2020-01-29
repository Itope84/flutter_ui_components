import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function(File) onChanged;
  final String placeholderText;

  /// This depends on flutter image_picker. For iOS don't forget to configure the plist settings according to https://pub.dev/packages/image_picker#-readme-tab-
  ImageInput({this.onChanged, this.placeholderText});

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _image;

  Future getImage() async {
    final ImageSource imageSource = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Select the image source",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.camera,
                            size: 40.0,
                            color: Colors.grey[600],
                          ),
                          Text(
                            "Camera",
                            style: Theme.of(context).textTheme.body2,
                          )
                        ],
                      ),
                    ),
                    onTap: () => Navigator.pop(context, ImageSource.camera),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.folder,
                            size: 40.0,
                            color: Colors.grey[600],
                          ),
                          Text(
                            "Gallery",
                            style: Theme.of(context).textTheme.body2,
                          )
                        ],
                      ),
                    ),
                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );

    if (imageSource != null) {
      var image = await ImagePicker.pickImage(source: imageSource);

      setState(() {
        _image = image;
      });

      widget.onChanged(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        border: Border.all(color: Color(0xFFF9FAFB)),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: InkWell(
        onTap: () {
          getImage();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? FloatingActionButton(
                    onPressed: () {
                      getImage();
                    },
                    backgroundColor: Color(0xFF3D8962),
                    elevation: 0.0,
                    child: Icon(Icons.add),
                    mini: true,
                  )
                : Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      image: DecorationImage(
                        image: FileImage(
                          _image,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              widget.placeholderText ?? "Upload picture",
              style: Theme.of(context)
                  .textTheme
                  .body2
                  .copyWith(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
