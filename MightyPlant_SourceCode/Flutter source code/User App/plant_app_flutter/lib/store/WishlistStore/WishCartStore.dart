import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/model/wishlist/WishlistResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/utils/constants.dart';

import '../../main.dart';

part 'WishCartStore.g.dart';

class WishCartStore = WishCartStoreBase with _$WishCartStore;

abstract class WishCartStoreBase with Store {
  @observable
  List<WishlistResponse> wishList = ObservableList<WishlistResponse>();

  @action
  Future<void> addToWishList(WishlistResponse? data) async {
    if (wishList.any((element) => element.pro_id == data!.pro_id)) {
      wishList.remove(data);

      await wishlistApi.removeFromWishList(pId: data!.pro_id!).then((value) {
        wishlistApi.getWishList().then((value) {
          appStore.setLoading(false);
          wishList = ObservableList.of(value);
        }).catchError((e) {
          log(e.toString());
        });
        toast(value.message, print: true);
      }).catchError((e) {
        log(e.toString());
      });
    } else {
      wishList.add(data!);
      await wishlistApi.addToWishList(pId: data.pro_id!.toInt()).then((value) {
        getWishlistItem();
        toast(value.message, print: true);
      }).catchError((e) {
        log(e.toString());
      });
    }
    storeWishlistData();
  }

  bool isItemInWishlist(int id) {
    return wishList.any((element) => element.pro_id == id);
  }

  @action
  Future<void> storeWishlistData() async {
    if (wishList.isNotEmpty) {
      await setValue(WISHLIST_ITEM_LIST, jsonEncode(wishList));
      log(getStringAsync(WISHLIST_ITEM_LIST));
    } else {
      await setValue(WISHLIST_ITEM_LIST, '');
    }
  }

  @action
  void addAllWishListItem(List<WishlistResponse> productList) {
    wishList.addAll(productList);
  }

  @action
  Future<void> getWishlistItem() async {
    wishlistApi.getWishList().then((value) {
      appStore.setLoading(false);
      wishList = ObservableList.of(value);
      wishList.forEachIndexed((element, index) {
        log("akxx"+element.name!);
      });
    }).catchError((e) {
      log(e.toString());
    });
  }

  @action
  Future<void> clearWishlist() async {
    wishList.clear();
    storeWishlistData();
  }
}
