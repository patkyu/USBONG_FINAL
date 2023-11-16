import 'package:flutter/material.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';

class ZoomImageScreen extends StatefulWidget {
  final mProductImage;

  ZoomImageScreen({Key? key, this.mProductImage}) : super(key: key);

  @override
  _ZoomImageScreenState createState() => _ZoomImageScreenState();
}

class _ZoomImageScreenState extends State<ZoomImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('', showBack: true, color: primaryColor,textColor: Colors.white),
      body: PhotoView(backgroundDecoration: BoxDecoration(color: appStore.scaffoldBackground),
        imageProvider: NetworkImage(widget.mProductImage),
      ),
    );
  }
}
