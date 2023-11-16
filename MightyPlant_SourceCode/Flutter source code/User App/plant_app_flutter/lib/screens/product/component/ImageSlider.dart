import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/model/product/ProductResponse.dart';
import 'package:plant_flutter/utils/CachedNetworkImage.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:photo_view/photo_view.dart';

class ImageSlider extends StatefulWidget {
  final int index;
  final List<Images> imageList;
  final int id;
  final name;

  ImageSlider({required this.index,required this.imageList, required this.id, this.name});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  PageController? pageController;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    pageController = PageController(initialPage: widget.index);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Hero(
          tag: "${widget.id}${widget.name}",
          child: Container(
            color: context.cardColor,
            child: PageView.builder(
              controller: pageController,
              itemCount: widget.imageList.length,
              itemBuilder: (context, index) {
                return PhotoView(
                  imageProvider: Image.network(widget.imageList[index].src!,loadingBuilder: (context, child, loadingProgress) {
                   return cachedImage('');
                  },).image,
                );
              },
            ),
          ),
        ),
        if (widget.imageList.length > 1)
          DotIndicator(
            pageController: pageController!,
            dotSize: 6,
            currentDotWidth: 8,
            currentDotSize: 8,
            pages: widget.imageList,
            indicatorColor: primaryColor,
            unselectedIndicatorColor: Colors.grey,
          ).paddingBottom(70)
      ],
    );
  }
}
