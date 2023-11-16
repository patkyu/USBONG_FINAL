import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class IncrementComponent extends StatefulWidget {
  final Function(int count) onValueChanged;
  final int? initialValue;

  IncrementComponent({required this.onValueChanged, this.initialValue});

  @override
  _IncrementComponentState createState() => _IncrementComponentState();
}

class _IncrementComponentState extends State<IncrementComponent> {
  int count = 1;

  TextEditingController countCont = TextEditingController(text: "1");

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.initialValue != null) {
      count = widget.initialValue!;
      setState(() {});
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void getCount(bool isMinus) {
    if (isMinus) {
      if (count <= 1) {
        widget.onValueChanged.call(0);
      } else {
        count--;
      }
    } else {
      count++;
    }
    widget.onValueChanged.call(count);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationDefault(color: context.cardColor),
      padding: EdgeInsets.symmetric(horizontal: 1),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: boxDecorationDefault(color: context.cardColor, border: Border.all(color: context.dividerColor)),
            child: Icon(LineIcons.minus, size: 14),
          ).onTap(() {
            getCount(true);
          }),
          Text('$count', style: boldTextStyle()).paddingSymmetric(horizontal: 8),
          Container(
            padding: EdgeInsets.all(4),
            decoration: boxDecorationDefault(color: context.cardColor, border: Border.all(color: context.dividerColor)),
            child: Icon(Icons.add, size: 14),
          ).onTap(() {
            getCount(false);
          }),
        ],
      ),
    );
  }
}
