const appName = "USBONG Plant Shop";
const appDesc = "USBONG Plant Shop";

const baseUrl = 'https://woo-softly-magnetic-peace.wpcomstaging.com/index.php';
const mDomainUrl = '$baseUrl/wp-json/';
const ConsumerKey = 'ck_b2ade434ddd1709fd7d57059db4c3a1a67e8f5f5';
const ConsumerSecret = 'cs_495387646a8749d5513d77a2d72350b1bef6ac07';
const mOneSignalAppId = '8998f41d-2133-4012-b4a0-bf3c1a794966';

class PaymentKeys {
  final String razorKey = "YOUR REZOR PAY KEY";
  final String payStackPublicKey = 'YOUR PAYSTACK PUBLIC KEY';
  final String razorPayDescription = "REZOR PAY DISCRIPTION";
}

const BANNER_AD_ID_ANDROID = "ADMOB ADROID BANNER ID";
const BANNER_AD_ID_IOS = "ADMOB IOS BANNER ID";
const INTERSTITIAL_AD_ID_ANDROID = "ADMOB ANDROID INTERTITIAL ID";
const INTERSTITIAL_AD_ID_IOS = "ADMOB IOS INTERTITIAL ID";

const ENABLE_ADS = false;

const IS_RAZORPAY = true;
const IS_PAY_STACK = true;

const PAYMENT_METHOD_NATIVE = "native";

PaymentKeys paymentKeys = PaymentKeys();

class DefaultValues {
  final String defaultLanguage = "en";
}

DefaultValues defaultValues = DefaultValues();

const LoginTypeApp = 'app';
const LoginTypeGoogle = 'google';
const LoginTypeOTP = 'otp';
const LoginTypeApple = 'apple';

const COMPLETED = "completed";
const REFUNDED = "refunded";
const CANCELED = "cancelled";
const TRASH = "trash";
const FAILED = "failed";
const SUCCESS = 'Success';

bool isSocial = false;

class SharedPref {
  final String selectedLanguage = "selectedLanguage";
  final String isRemember = "IsRemember";
  final String isFirstTime = "isFirstTime";
  final String appThemeMode = "appThemeMode";

  ///User
  final String userPassword = "userPassword";
  final String userPhotoUrl = "userPhotoUrl";
  final String userId = "userId";
  final String isLoggedIn = "isLoggedIn";
  final String firstName = "firstName";
  final String lastName = "lastName";
  final String userEmail = "userEmail";
  final String userName = "userName";
  final String apiToken = "apiToken";
  final String wishlistData = "wishlistData";
  final String cartItemList = "cartItemList";
  final String billingAddress = "billingAddress";
  final String shippingAddress = "shippingAddress";

  final String contact = "contact";
  final String copyrightText = "copyrightText";
  final String facebook = "facebook";
  final String instagram = "instagram";
  final String privacyPolicy = "privacyPolicy";
  final String refundPolicy = "refundPolicy";
  final String shippingPolicy = "shippingPolicy";
  final String termCondition = "termCondition";
  final String twitter = "twitter";
  final String websiteUrl = "websiteUrl";
  final String whatsapp = "whatsapp";
  final String appLang = "appLang";
  final String currencySymbol = "currencySymbol";
  final String enableCustomDashboard = "enableCustomDashboard";
  final String paymentMethod = "paymentMethod";
}

SharedPref sharedPref = SharedPref();
const cartUpdate = "cartUpdate";
const wishListUpdate = "wishListUpdate";

class AppThemeMode {
  final int themeModeLight = 1;
  final int themeModeDark = 2;
  final int themeModeSystem = 0;
}

const VideoTypeCustom = 'custom_url';
const VideoTypeYouTube = 'youtube';
const VideoTypeIFrame = 'iframe';

const WISHLIST_ITEM_LIST = 'WISHLIST_ITEM_LIST';
const CART_ITEM_LIST = 'CART_ITEM_LIST';

AppThemeMode appThemeMode = AppThemeMode();
const DASHBOARD_ITEMS = 6;
const appBarTextSize = 22;
