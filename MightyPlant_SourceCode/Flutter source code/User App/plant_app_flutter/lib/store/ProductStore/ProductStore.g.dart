// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProductStore on ProductStoreBase, Store {
  final _$cartProductIdAtom = Atom(name: 'ProductStoreBase.cartProductId');

  @override
  List<int> get cartProductId {
    _$cartProductIdAtom.reportRead();
    return super.cartProductId;
  }

  @override
  set cartProductId(List<int> value) {
    _$cartProductIdAtom.reportWrite(value, super.cartProductId, () {
      super.cartProductId = value;
    });
  }

  final _$mIsUserExistInReviewAtom =
      Atom(name: 'ProductStoreBase.mIsUserExistInReview');

  @override
  bool get mIsUserExistInReview {
    _$mIsUserExistInReviewAtom.reportRead();
    return super.mIsUserExistInReview;
  }

  @override
  set mIsUserExistInReview(bool value) {
    _$mIsUserExistInReviewAtom.reportWrite(value, super.mIsUserExistInReview,
        () {
      super.mIsUserExistInReview = value;
    });
  }

  final _$addToCartListAsyncAction =
      AsyncAction('ProductStoreBase.addToCartList');

  @override
  Future<void> addToCartList({required int prodId}) {
    return _$addToCartListAsyncAction
        .run(() => super.addToCartList(prodId: prodId));
  }

  final _$removeFromCartListAsyncAction =
      AsyncAction('ProductStoreBase.removeFromCartList');

  @override
  Future<void> removeFromCartList({required int prodId}) {
    return _$removeFromCartListAsyncAction
        .run(() => super.removeFromCartList(prodId: prodId));
  }

  @override
  String toString() {
    return '''
cartProductId: ${cartProductId},
mIsUserExistInReview: ${mIsUserExistInReview}
    ''';
  }
}
