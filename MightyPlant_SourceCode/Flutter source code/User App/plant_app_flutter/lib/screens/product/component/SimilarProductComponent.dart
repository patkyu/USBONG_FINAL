import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/model/dashboard/ProductListResponse.dart';
import 'package:plant_flutter/model/product/ProductDetailResponse.dart';
import 'package:plant_flutter/screens/dashboard/component/ProductComponent.dart';

class SimilarProductComponent extends StatelessWidget {
  final List<UpSells> upSells;

  SimilarProductComponent({required this.upSells});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Text("You may also like", style: boldTextStyle(size: 20)),
        8.height,
        HorizontalList(
          itemCount: upSells.length,
          spacing: 16,
          itemBuilder: (context, index) {
            UpSells data = upSells[index];
            return ProductComponent(
                itemData: ProductListResponse(
                  id: data.id.validate(),
                  images: data.images.validate(),
                  name: data.name.validate(),
                  price: data.price.validate(),
                  regular_price: data.regular_price.validate(),
                  sale_price: data.sale_price.validate(),
                ),
                index: index);
          },
        ),
      ],
    );
  }
}
