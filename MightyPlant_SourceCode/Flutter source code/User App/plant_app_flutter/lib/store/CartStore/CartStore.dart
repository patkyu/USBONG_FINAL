import 'dart:async';
import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/model/cart/CartResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/utils/constants.dart';

part 'CartStore.g.dart';

class CartStore = _CartStore with _$CartStore;

abstract class _CartStore with Store {
  @observable
  late CartResponse cartResponse = CartResponse();

  @observable
  List<CartData> cartList = ObservableList();

  @observable
  double cartTotalAmount = 0.0;

  @observable
  double cartTotalPayableAmount = 0.0;

  @observable
  double discountedValue = 0.0;

  @observable
  double itemCalculatedPrice = 0.0;

  @observable
  double cartSavedAmount = 0.0;

  @action
  Future<CartResponse> init() async {
    cartResponse = await cartApi.getCartList().then((value) => value).catchError((e) {
      log(e.toString());
      return e;
    });

    cartList = cartResponse.cartData.validate();

    cartList.forEach((element) {
      productStore.addToCartList(prodId: element.pro_id!);
    });

    if (cartList.isEmpty) {
      LiveStream().emit(cartUpdate);
    }

    calculateTotals();
    return cartResponse;
  }

  @action
  void calculateTotals() {
    discountedValue = 0.0;
    cartTotalAmount = cartList.sumByDouble((e) => e.regular_price.toDouble() * e.quantity.validate(value: '1').toDouble());
    cartTotalPayableAmount = cartTotalAmount - cartList.sumByDouble((e) => e.discountPrice * e.quantity.validate(value: '1').toDouble());
    cartSavedAmount = cartTotalAmount - cartTotalPayableAmount;
    cartList.forEach((element) {
      discountedValue = discountedValue += element.discountPrice * element.quantity.toInt();
    });

    storeCartData();
  }

  @action
  Future<void> addToCart({required int index, required int qty}) async {
    cartList[index].quantity = qty.toString();
    calculateTotals();

    cartApi.updateCartProduct(proId: cartList[index].pro_id!.toString(), cartId: cartList[index].cart_id.toString(), qty: qty.toString()).then((value) {
      toast(value.message);

      calculateTotals();
    }).catchError((e) {
      cartList[index].quantity = (qty - 1).toString();
      toast(e.toString());
    });
  }

  @action
  Future<void> removeFromCart({required int index}) async {

    appStore.setLoading(true);
    int productId = cartList[index].pro_id!;
    cartList.removeAt(index);

    await cartApi.removeFromCart(pId: productId).then((value) {
      toast(value.message);
      LiveStream().emit(cartUpdate);
      productStore.removeFromCartList(prodId: productId);
      calculateTotals();
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  bool isItemInCart(int id) {
    return cartList.any((element) {
      return element.pro_id == id.validate();
    });
  }

  @action
  Future<void> storeCartData() async {
    if (cartList.isNotEmpty) {
      await setValue(sharedPref.cartItemList, jsonEncode(cartList));
    } else {
      await setValue(sharedPref.cartItemList, '');
    }
  }

  @action
  Future<void> clearCart() async {
    cartList.clear();

    cartApi.clearCart().then((value) {
      toast(value.message);
      calculateTotals();
    }).catchError((e) {
      toast(e.toString());
    });

    storeCartData();
  }
}
