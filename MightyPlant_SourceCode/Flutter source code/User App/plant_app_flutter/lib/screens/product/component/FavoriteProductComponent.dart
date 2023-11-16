import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/model/product/ProductDetailResponse.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/common.dart';

import '../../../main.dart';

class FavoriteProductComponent extends StatefulWidget {
  final ProductDetailResponse? productDetailNew;

  FavoriteProductComponent(this.productDetailNew);

  @override
  _FavoriteProductComponentState createState() => _FavoriteProductComponentState();
}

class _FavoriteProductComponentState extends State<FavoriteProductComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Container(
        decoration: boxDecorationWithRoundedCorners(borderRadius: radius(16), backgroundColor: primaryColor),
        child: IconButton(
          color: Colors.white,
          iconSize: 28,
          padding: EdgeInsets.all(0),
          icon: wishCartStore.isItemInWishlist(widget.productDetailNew!.id!) ? Icon(MaterialIcons.bookmark, color: Colors.white) : Icon(MaterialIcons.bookmark_border, color: Colors.white),
          onPressed: () {
            ifLoggedIn(() {
              if (widget.productDetailNew!.type == 'external') {
                toast(language.externalFavMsg);
              } else {
                addItemToWishlist(mDetailResponse: widget.productDetailNew);
              }
            });
          },
        ),
      );
    });
  }
}
