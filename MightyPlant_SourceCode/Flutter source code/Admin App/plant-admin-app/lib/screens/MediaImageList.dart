import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_plant_admin/models/ProductDetailResponse.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppConstants.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class MediaImageList extends StatefulWidget {
  static String tag = '/MediaImageListWidget';
  final bool isSingleSelection;

  MediaImageList({this.isSingleSelection = false});

  @override
  MediaImageListState createState() => MediaImageListState();
}

class MediaImageListState extends State<MediaImageList> {
  List<Images1> mediaImgList = [];
  List<Images1> selectedImageList = [];
  Images1? selectedImage;

  ScrollController scrollController = ScrollController();

  int? selectedIndex;
  int page = 1;

  bool mIsLastPage = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() => init());
  }

  Future<void> init() async {
    await getMediaImages();
    scrollController.addListener(() {
      if ((scrollController.position.pixels - 100) == (scrollController.position.maxScrollExtent - 100)) {
        if (!mIsLastPage) {
          page++;
          appStore.setLoading(true);
          getMediaImages();
          setState(() {});
        }
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> getMediaImages() async {
    appStore.setLoading(true);

    await getMediaImage(page).then((res) async {
      if (page == 1) mediaImgList.clear();

      mediaImgList.addAll(res);
      mIsLastPage = res.length != ImgPerPage;

      setState(() {});
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget("lbl_Media".translate, showBack: true, color: primaryColor, textColor: white, actions: [
          IconButton(
              icon: Icon(Icons.check, color: white),
              onPressed: () {
                finish(context, widget.isSingleSelection ? selectedImage : selectedImageList);
              }),
        ]),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              child: Wrap(
                runSpacing: 0,
                spacing: 0,
                children: mediaImgList.map(
                  (e) {
                    return Stack(
                      children: [
                        cachedImage(
                          e.src.validate(),
                          height: 160,
                          width: context.width() * 0.333,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          color: black.withOpacity(0.52),
                          height: 160,
                          width: context.width() * 0.333,
                          child: Icon(Icons.check_circle, size: 35, color: white),
                        ).visible(widget.isSingleSelection && selectedImage!=null ? selectedImage!.src.validate() == e.src.validate() : selectedImageList.contains(e)),
                      ],
                    ).onTap(() {
                      if (widget.isSingleSelection) {
                        selectedImage = e;
                      } else {
                        if (selectedImageList.contains(e)) {
                          selectedImageList.remove(e);
                        } else {
                          selectedImageList.add(e);
                        }
                      }
                      setState(() {});
                    });
                  },
                ).toList(),
              ),
            ),
            Observer(builder: (_) => loading().center().visible(appStore.isLoading))
          ],
        ),
      ),
    );
  }
}
