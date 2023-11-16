import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/dashboard/ProductListResponse.dart';
import 'package:plant_flutter/screens/dashboard/component/ProductComponent.dart';
import 'package:plant_flutter/screens/dashboard/ViewAllScreenCustom.dart';
import 'package:plant_flutter/screens/dashboard/ViewAllScreen.dart';
import 'package:plant_flutter/utils/colors.dart';
import 'package:plant_flutter/utils/constants.dart';

class ListScreen extends StatelessWidget {
  final List<ProductListResponse> data;
  final String heroAnimationUniqueValue;
  final String name;
  final int? currentIndex;

  ListScreen({required this.data, required this.heroAnimationUniqueValue, required this.name, this.currentIndex});

  @override
  Widget build(BuildContext context) {
    if (data.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: List.generate(data.length >= DASHBOARD_ITEMS ? DASHBOARD_ITEMS : data.length, (index) {
              return ProductComponent(itemData: data[index], index: index, heroAnimationUniqueValue: heroAnimationUniqueValue);
            }),
          ),
          16.height,
          AppButton(
            color: primaryColor,
            width: context.width(),
            text: language.view_All + " $name",
            onTap: () {
              if (userStore.enableCustomDashboard) {
                push(ViewAllScreenCustom(valueType: name, index: currentIndex!));
              } else {
                push(
                  ViewAllScreen(type: '${getName(name)}', valueType: name, test: "${getParameter(name)}"),
                );
              }
            },
          )
        ],
      );
    }
    return NoDataWidget().center();
  }

  String getName(data) {
    if (data == "Best Selling Products") {
      return "best_selling_product";
    } else if (data == "Sale Product") {
      return "sale_product";
    } else if (data == "Featured") {
      return "featured";
    } else if (data == "Newest") {
      return "newest";
    } else if (data == "Highest Rating") {
      return "highest_rating";
    } else if (data == "Discount") {
      return "discount";
    } else {
      return "";
    }
  }

  String getParameter(data) {
    if (data == "Best Selling Products") {
      return "total_sales";
    } else if (data == "Sale Product") {
      return "_sale_price";
    } else if (data == "Featured") {
      return "product_visibility";
    } else if (data == "Newest") {
      return "newest";
    } else if (data == "Highest Rating") {
      return "highest_rating";
    } else if (data == "Discount") {
      return "discount";
    } else {
      return "";
    }
  }
}
