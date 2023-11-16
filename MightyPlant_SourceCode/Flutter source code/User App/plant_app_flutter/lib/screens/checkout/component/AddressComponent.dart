import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/model/auth/UserResponse.dart';

class AddressComponent extends StatelessWidget {
  final Billing address;
  final String name;
  final double? width;
  final bool? isCheckOut;

  AddressComponent({required this.address, required this.name, this.width,this.isCheckOut});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? context.width() * 0.443,
      decoration: boxDecorationDefault(color: context.cardColor, border: Border.all(color: context.dividerColor)),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: boldTextStyle()).center(),
          Divider(),
          6.width,
          Text('${address.first_name.validate()} ${address.last_name.validate()}', style: boldTextStyle(size: 14)),
          address.address_1.validate().isNotEmpty || address.address_2.validate().isNotEmpty
              ? Text(
                  '${address.company.validate()},'
                  '\n${address.address_1.validate()},'
                  '\n${address.address_2.validate()},'
                  '\n${address.city.validate()},'
                  ' ${address.state.validate()} '
                  '- ${address.postcode.validate()},'
                  '\n${address.country.validate()}',
                  style: primaryTextStyle(size: 12))
              : Text('NA', style: primaryTextStyle(size: 12)),
        ],
      ),
    );
  }
}
