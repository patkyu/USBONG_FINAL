import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage? of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage);

  String get lblOldPassword;

  String get lblOldPasswordIsNotCorrect;

  String get lblNewPassword;

  String get lblChangePassword;

  String get lblConfirmPassword;

  String get lblPasswordLengthShouldBeMoreThanSix;

  String get lblBothPasswordShouldBeMatched;

  String get lblOldPasswordShouldNotBeSameAsNewPassword;

  String get lblSave;


  String get forget_Password;

  String get reset_password_link_will_be_sent_to_the_above_entered_email_address;

  String get email;

  String get enter_Valid_Email;

  String get reset_Password;

  String get sign_in_to_view_your;

  String get shop_them_anytime_you_like;

  String get login;

  String get no_Data;

  String get username_or_Email;

  String get password;

  String get remember_me;

  String get forgot_Password;

  String get submit;

  String get you_are_already_registered_with_us;

  String get sign_in_with_google;

  String get sign_in_with_Apple;

  String get first_Name;

  String get last_Name;

  String get username;

  String get by_Submitting_you_are_agreeing_to;

  String get terms_and_conditions;

  String get terms_of_use;

  String get privacy_policy;

  String get welcome;

  String get signUp;

  String get price_Details;

  String get price;

  String get items;

  String get discounts;

  String get total_Amount;

  String get please_add_the_shipping_address_first;

  String get swipe_to_Checkout;

  String get cart_is_Empty;

  String get cart;

  String get sub_Category;

  String get sub_Category_By;

  String get payment_Failed;

  String get payment_Confirmed;

  String get thank_you_your_payment_has_been_successful;

  String get done;

  String get web_View_Payment;

  String get order_placed_successfully;

  String get order_Summary;

  String get addresses;

  String get change_Address;

  String get billing_Address;

  String get shipping_Address;

  String get order_Details;

  String get select_Payment_Mode;

  String get payStack;

  String get razor_Pay;

  String get cash_on_delivery;

  String get pay_Now;

  String get out_Of_Stock;

  String get tips_and_Plant_Care;

  String get find_Tips_For_Keeping_Your_Plants_Alive;

  String get wishlist;

  String get categories;

  String get view_All;

  String get tips;

  String get tips_for_growing_plants;

  String get view_All_Screen;

  String get no_Orders_Yet;

  String get sorry_you_havent_place_any_order_yet;

  String get go_Back;

  String get ordered_on;

  String get payment_mode;

  String get total;

  String get shipping_information;

  String get items_you_ordered_are;

  String get your_Orders;

  String get you_have_not_yet_ordered_anything;

  String get orders;

  String get remove_from_cart;

  String get add_to_cart;

  String get category;

  String get ratings;

  String get weight;

  String get height;

  String get deal_ends_in;

  String get similar_Products;

  String get overview;

  String get about_Plant;

  String get deleted;

  String get are_you_sure_you_want_to_delete_this_review;

  String get edit;

  String get delete;

  String get your_review_has_been_saved;

  String get your_overall_rating_for_this_product;

  String get add_Review;

  String get what_do_you_like_or_dislike;

  String get product_Review;

  String get user_reviews;

  String get no_Reviews;

  String get search_Plants_and_accessories;

  String get search_Plants;

  String get no_Items_you_have_searched;

  String get help_and_Support;

  String get privacy_Policy;

  String get check_our_policies;

  String get url_is_Empty;

  String get terms_and_Condition;

  String get read_our_terms;

  String get refund_Policy;

  String get check_our_refund_policies;

  String get shipping_Policy;

  String get check_our_shipping_policies;

  String get website;

  String get our_Home_Page;

  String get contact_Us;

  String get welcome_planter;

  String get edit_Profile;

  String get change_your_Profile;

  String get change_Password;

  String get update_Password_to_be_secure;

  String get iew_All_your_orders;

  String get language;

  String get english;

  String get system_Theme;

  String get light_Mode;

  String get quires_are_welcomed;

  String get share;

  String get spread_more;

  String get logout;

  String get know_us_more;

  String get light;

  String get dark;

  String get system_Default;

  String get city;

  String get pinCode;

  String get company;

  String get phone;

  String get address_1;

  String get address_2;

  String get save_Billing_address;

  String get save;

  String get country;

  String get state;

  String get lblNA;

  String get personal_Details;

  String get billing_Addres;

  String get cancel;

  String get are_you_sure_you_want_to_update_the_profile;

  String get save_Shipping_address;

  String get swipe;

  String get wishList_is_Empty;

  String get wishList;

  String get invalid_URL;

  String get CartItemRemove;

  String get webViewPayment;

  String get lblVendor;

  String get lblAuthor;

  String get cancleOrderMsg11;

  String get cancleOrderMsg2;

  String get cancleOrderMsg3;

  String get cancleOrderMsg4;

  String get cancleOrderMsg5;

  String get cancleOrderMsg6;

  String get lblCancleORder;

  String get lblPricingDetail;

  String get lblShipping;

  String get lblDeliveredOn;

  String get lblSoldOut;

  String get externalFavMsg;

  String get lblGrpProduct;

  String get lblSale;

  String get lblSoldBy;

  String get lblDescription;

  String get lblShortDescription;

  String get lblPlant;

  String get lblAvailableIn;

  String get lblAboutUs;

  String get lblFollowUs;

  String get lblcopyright;

  String get lblMoreInfo;

  String get lblLogOutMsg;

  String get lblSelectTheme;

  String get lblWelComext;

  String get lblAreYouSure;

  String get lblBestSelling;

  String get lblSaleProduct;

  String get lblFeatured;

  String get lblNewest;

  String get lblHighestRating;

  String get lblDiscount;

  String get lbluploadImage;

  String get lblSameasBilling;

  String get lblyes;

  String get appName;

  String get WelcomeMsg;

  String get Message;

  String get lblTreatment;

  String get lblDashboard;

  String get lblSetting;
}
