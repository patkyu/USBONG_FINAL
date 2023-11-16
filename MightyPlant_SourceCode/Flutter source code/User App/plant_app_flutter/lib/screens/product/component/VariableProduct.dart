import 'package:flutter/material.dart';

class VariableProduct extends StatefulWidget {
  @override
  _VariableProductState createState() => _VariableProductState();
}

class _VariableProductState extends State<VariableProduct> {

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
    return Scaffold();
  }
}
