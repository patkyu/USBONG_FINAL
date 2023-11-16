// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CartStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CartStore on _CartStore, Store {
  final _$cartResponseAtom = Atom(name: '_CartStore.cartResponse');

  @override
  CartResponse get cartResponse {
    _$cartResponseAtom.reportRead();
    return super.cartResponse;
  }

  @override
  set cartResponse(CartResponse value) {
    _$cartResponseAtom.reportWrite(value, super.cartResponse, () {
      super.cartResponse = value;
    });
  }

  final _$cartListAtom = Atom(name: '_CartStore.cartList');

  @override
  List<CartData> get cartList {
    _$cartListAtom.reportRead();
    return super.cartList;
  }

  @override
  set cartList(List<CartData> value) {
    _$cartListAtom.reportWrite(value, super.cartList, () {
      super.cartList = value;
    });
  }

  final _$cartTotalAmountAtom = Atom(name: '_CartStore.cartTotalAmount');

  @override
  double get cartTotalAmount {
    _$cartTotalAmountAtom.reportRead();
    return super.cartTotalAmount;
  }

  @override
  set cartTotalAmount(double value) {
    _$cartTotalAmountAtom.reportWrite(value, super.cartTotalAmount, () {
      super.cartTotalAmount = value;
    });
  }

  final _$cartTotalPayableAmountAtom =
      Atom(name: '_CartStore.cartTotalPayableAmount');

  @override
  double get cartTotalPayableAmount {
    _$cartTotalPayableAmountAtom.reportRead();
    return super.cartTotalPayableAmount;
  }

  @override
  set cartTotalPayableAmount(double value) {
    _$cartTotalPayableAmountAtom
        .reportWrite(value, super.cartTotalPayableAmount, () {
      super.cartTotalPayableAmount = value;
    });
  }

  final _$discountedValueAtom = Atom(name: '_CartStore.discountedValue');

  @override
  double get discountedValue {
    _$discountedValueAtom.reportRead();
    return super.discountedValue;
  }

  @override
  set discountedValue(double value) {
    _$discountedValueAtom.reportWrite(value, super.discountedValue, () {
      super.discountedValue = value;
    });
  }

  final _$itemCalculatedPriceAtom =
      Atom(name: '_CartStore.itemCalculatedPrice');

  @override
  double get itemCalculatedPrice {
    _$itemCalculatedPriceAtom.reportRead();
    return super.itemCalculatedPrice;
  }

  @override
  set itemCalculatedPrice(double value) {
    _$itemCalculatedPriceAtom.reportWrite(value, super.itemCalculatedPrice, () {
      super.itemCalculatedPrice = value;
    });
  }

  final _$cartSavedAmountAtom = Atom(name: '_CartStore.cartSavedAmount');

  @override
  double get cartSavedAmount {
    _$cartSavedAmountAtom.reportRead();
    return super.cartSavedAmount;
  }

  @override
  set cartSavedAmount(double value) {
    _$cartSavedAmountAtom.reportWrite(value, super.cartSavedAmount, () {
      super.cartSavedAmount = value;
    });
  }

  final _$initAsyncAction = AsyncAction('_CartStore.init');

  @override
  Future<CartResponse> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  final _$addToCartAsyncAction = AsyncAction('_CartStore.addToCart');

  @override
  Future<void> addToCart({required int index, required int qty}) {
    return _$addToCartAsyncAction
        .run(() => super.addToCart(index: index, qty: qty));
  }

  final _$removeFromCartAsyncAction = AsyncAction('_CartStore.removeFromCart');

  @override
  Future<void> removeFromCart({required int index}) {
    return _$removeFromCartAsyncAction
        .run(() => super.removeFromCart(index: index));
  }

  final _$storeCartDataAsyncAction = AsyncAction('_CartStore.storeCartData');

  @override
  Future<void> storeCartData() {
    return _$storeCartDataAsyncAction.run(() => super.storeCartData());
  }

  final _$clearCartAsyncAction = AsyncAction('_CartStore.clearCart');

  @override
  Future<void> clearCart() {
    return _$clearCartAsyncAction.run(() => super.clearCart());
  }

  final _$_CartStoreActionController = ActionController(name: '_CartStore');

  @override
  void calculateTotals() {
    final _$actionInfo = _$_CartStoreActionController.startAction(
        name: '_CartStore.calculateTotals');
    try {
      return super.calculateTotals();
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cartResponse: ${cartResponse},
cartList: ${cartList},
cartTotalAmount: ${cartTotalAmount},
cartTotalPayableAmount: ${cartTotalPayableAmount},
discountedValue: ${discountedValue},
itemCalculatedPrice: ${itemCalculatedPrice},
cartSavedAmount: ${cartSavedAmount}
    ''';
  }
}
