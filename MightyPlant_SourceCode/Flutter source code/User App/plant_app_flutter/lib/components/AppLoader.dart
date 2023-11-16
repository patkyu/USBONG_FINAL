import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/utils/images.dart';

class AppLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(appImages.icGif, height: 100).center();
  }
}
