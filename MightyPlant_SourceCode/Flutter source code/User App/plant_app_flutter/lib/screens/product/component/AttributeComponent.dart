import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/model/product/ProductDetailResponse.dart';

class AttributeComponent extends StatefulWidget {
  final ProductDetailResponse? product;

  AttributeComponent(this.product);

  @override
  _AttributeComponentState createState() => _AttributeComponentState();
}

class _AttributeComponentState extends State<AttributeComponent> {
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

  String getAllAttribute(Attributes attribute) {
    String attributes = "";
    for (var i = 0; i < attribute.options!.length; i++) {
      attributes = attributes + attribute.options![i];
      if (i < attribute.options!.length - 1) {
        attributes = attributes + ", ";
      }
    }
    return attributes;
  }

  @override
  Widget build(BuildContext context) {
    return widget.product!.attributes != null
        ? ListView.builder(
            itemCount: widget.product!.attributes!.length,
            padding: EdgeInsets.only(left: 8, right: 8),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, i) {
              return widget.product!.attributes![i].options != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.product!.attributes![i].name.validate() + " : ", style: boldTextStyle(size: 14)).visible(widget.product!.attributes![i].options!.isNotEmpty),
                        4.height,
                        Text(getAllAttribute(widget.product!.attributes![i]), maxLines: 4, style: secondaryTextStyle()).expand(),
                      ],
                    )
                  : SizedBox();
            },
          )
        : SizedBox();
  }
}
