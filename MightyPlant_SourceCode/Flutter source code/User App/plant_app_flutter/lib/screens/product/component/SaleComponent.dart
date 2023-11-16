import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/product/ProductDetailResponse.dart';
import 'package:plant_flutter/utils/widgets/count_down.dart';

class SaleComponent extends StatefulWidget {
  final ProductDetailResponse data;

  SaleComponent({required this.data});

  @override
  _SaleComponentState createState() => _SaleComponentState();
}

class _SaleComponentState extends State<SaleComponent> {
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: boxDecorationDefault(color: Colors.green.shade50, boxShadow: defaultBoxShadow(spreadRadius: 0, blurRadius: 0), borderRadius: radius()),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(language.deal_ends_in+" ", style: primaryTextStyle(color: Colors.green, size: 16)),
          CountDownTimer(
            secondsRemaining: (DateTime.parse(widget.data.date_on_sale_to!).difference(DateTime.parse(widget.data.date_on_sale_from!))).inSeconds,
            whenTimeExpires: () {
              setState(() {
                // hasTimerStopped = true;
              });
            },
            countDownTimerStyle: boldTextStyle(color: Colors.green, size: 16),
          )
        ],
      ),
    );
  }
}
