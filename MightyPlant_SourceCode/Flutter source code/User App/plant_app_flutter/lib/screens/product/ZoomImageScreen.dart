import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/model/product/ProductDetailResponse.dart';
import 'package:plant_flutter/screens/product/component/ImageSlider.dart';


class ZoomImageScreen extends StatefulWidget {
  final imageIndex;
  final ProductDetailResponse previousData;
  final int id;
  final String name;

  ZoomImageScreen(this.imageIndex,this.previousData,this.id,this.name);

  @override
  ZoomImageScreenState createState() => ZoomImageScreenState();
}

class ZoomImageScreenState extends State<ZoomImageScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          alignment: Alignment.topLeft,
          children: [
            ImageSlider(index: widget.imageIndex, id: widget.id,name: widget.name, imageList: widget.previousData.imagess!),
            SafeArea(child: IconButton(iconSize: 20, padding: EdgeInsets.zero, icon: Icon(Icons.arrow_back_ios,color: Colors.white), onPressed: () => finish(context))),

          ],
        ),
    );
  }
}
