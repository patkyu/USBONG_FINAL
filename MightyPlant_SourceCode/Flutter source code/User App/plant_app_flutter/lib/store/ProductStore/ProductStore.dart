import 'package:mobx/mobx.dart';

part 'ProductStore.g.dart';

class ProductStore = ProductStoreBase with _$ProductStore;

abstract class ProductStoreBase with Store {
  @observable
  List<int> cartProductId = ObservableList();

  @observable
  bool mIsUserExistInReview = false;

  @action
  Future<void> addToCartList({required int prodId}) async {
    cartProductId.add(prodId);
  }

  @action
  Future<void> removeFromCartList({required int prodId}) async {
    cartProductId.removeWhere((element) => element == prodId);
  }

  bool isItemInCart({required int prodId}) {
    return cartProductId.any((element) {
      return element == prodId;
    });
  }
}
