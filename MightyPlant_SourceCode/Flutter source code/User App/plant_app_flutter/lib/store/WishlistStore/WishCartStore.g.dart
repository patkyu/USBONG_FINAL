// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WishCartStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WishCartStore on WishCartStoreBase, Store {
  final _$wishListAtom = Atom(name: 'WishCartStoreBase.wishList');

  @override
  List<WishlistResponse> get wishList {
    _$wishListAtom.reportRead();
    return super.wishList;
  }

  @override
  set wishList(List<WishlistResponse> value) {
    _$wishListAtom.reportWrite(value, super.wishList, () {
      super.wishList = value;
    });
  }

  final _$addToWishListAsyncAction =
      AsyncAction('WishCartStoreBase.addToWishList');

  @override
  Future<void> addToWishList(WishlistResponse? data) {
    return _$addToWishListAsyncAction.run(() => super.addToWishList(data));
  }

  final _$storeWishlistDataAsyncAction =
      AsyncAction('WishCartStoreBase.storeWishlistData');

  @override
  Future<void> storeWishlistData() {
    return _$storeWishlistDataAsyncAction.run(() => super.storeWishlistData());
  }

  final _$getWishlistItemAsyncAction =
      AsyncAction('WishCartStoreBase.getWishlistItem');

  @override
  Future<void> getWishlistItem() {
    return _$getWishlistItemAsyncAction.run(() => super.getWishlistItem());
  }

  final _$clearWishlistAsyncAction =
      AsyncAction('WishCartStoreBase.clearWishlist');

  @override
  Future<void> clearWishlist() {
    return _$clearWishlistAsyncAction.run(() => super.clearWishlist());
  }

  final _$WishCartStoreBaseActionController =
      ActionController(name: 'WishCartStoreBase');

  @override
  void addAllWishListItem(List<WishlistResponse> productList) {
    final _$actionInfo = _$WishCartStoreBaseActionController.startAction(
        name: 'WishCartStoreBase.addAllWishListItem');
    try {
      return super.addAllWishListItem(productList);
    } finally {
      _$WishCartStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
wishList: ${wishList}
    ''';
  }
}
