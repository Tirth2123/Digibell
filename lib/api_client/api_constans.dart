class APIConstants {
  // static const baseUrl = 'http://52.66.209.70:3050/api/';
  static const imageUrl = 'https://digibells-assets.s3.ap-south-1.amazonaws.com/';

  // Local Development URLs (Port 7500)
  // For Physical Device & Local Testing (same Wi-Fi):
  static const baseUrl = 'http://10.16.166.159:7500/api';
  static const socket = 'http://10.16.166.159:7500';

  // For Android Emulator (uncomment if using emulator):
  // static const baseUrl = 'http://10.0.2.2:7500/api';
  // static const socket = 'http://10.0.2.2:7500';

  // For Localhost (iOS Simulator / Web):
  // static const baseUrl = 'http://localhost:7500/api';
  // static const socket = 'http://localhost:7500';

  // Production URLs:
  // static const baseUrl = 'https://server.digibellstechnologies.com/api';
  // static const socket = 'https://server.digibellstechnologies.com';
  // static const baseUrl = 'https://noble-lobster-sharing.ngrok-free.app/api';
  // static const socket = 'https://noble-lobster-sharing.ngrok-free.app';

  static const APP_ID = '40bb224797c241f6893ac383b7afd2c4';

  static const razorPay_ID = 'rzp_live_cchSnQk35FsDj2';

  static const shareAndroid =
      'Experience the cutting-edge features of digital bell technology with the DigiBells app! Download now: https://play.google.com/store/apps/details?id=com.app.digibell';
  static const shareIos =
      'Experience the cutting-edge features of digital bell technology with the DigiBells app! Download now: [APPLE APP LINK SOON]';

  //login user
  static const sendOTP = '/auth/send/otp/v1';
  static const verifyEOTP = '/auth/verify/otp/v1';
  static const socialLoginUrl = '/auth/login/via/social/v1';
  static const logout = '/auth/logout/user/v1';

  static const dataCheck = "/auth/check/user/exist/v1";
  static const reactivateAccount = "/user/activate/my/account/v1";
  static const login = "/auth/login/user/v1";
  static const register = "/auth/register/user/v1";
  static const guestUser = "/auth/guest/login/v1";

  static const userDetails = "/user/add/user/details/v1";
  static const uploadImage = "/user/upload/profile/image/v1";
  static const allowNotification = "/user/modify/notification/permission/v1";
  static const updateProfile = "/user/update/v1";
  static const deleteAccount = "/user/delete/account/v1";

  static const productList = "/product/list/v1";
  static const productDetails = "/product/details/";
  static const orderList = "/order/list/v1";
  static const purchseOrder = "/order/purchase/v1";

  // QR part
  static const addQRDetails = "/qr/generate/v1";
  static const activateQRCode = "/qr/activate/qr/v1";
  static const getAllQR = "/qr/list/v1";
  static String updateQRDetails(String id) {
    return "/qr/update/$id/v1";
  }

  static String updateQRStatus(String id) {
    return "/qr/change/status/$id/v1";
  }

  // address part
  static const addAddress = "/address/add/v1";
  static String updateAddress(String id) {
    return "/address/update/$id/v1";
  }

  static String deleteAddress(String id) {
    return "/address/delete/$id/v1";
  }

  static const getAllAddress = "/address/user/v1";
  static String defaultAddress(String id) {
    return "/address/set/address/default/$id/v1";
  }

  // call history
  static const callHistory = "/call/history/v1";

  // add members
  static const addMembers = "/member/add/v1";
  static const getAllMembers = "/member/my/v1";
  static String removeMember(String id) {
    return "/member/remove/$id/v1";
  }

  // add member for QR
  static String removeQRMember(String id) {
    return "/qr/remove/members/qr/$id/v1";
  }

  static String addQRMembers(String id) {
    return "/qr/add/members/qr/$id/v1";
  }

  static String getQRMembers(String id) {
    return "/qr/member/list/$id/v1";
  }

  //subscription
  static String subscriptionDetails(String type, String search) {
    return "/subscription/list/v1?type=$type&searchQuery=$search";
  }

  static const inAppPurchase = "/payment/upgrade/ios/qr/v1";

  static const upgradePlan = "/payment/upgrade/qr/v1";

  //notification
  static const getNotification = "/notification/list/v1";
  static const readNotification = "/notification/mark/read/v1";


  //accept/decline invitation
  static String acceptInvite(String id) {
    return "/member/accept/invitation/$id/v1";
  }

  static String rejectInvite(String id) {
    return "/member/reject/invitation/$id/v1";
  }

  //buy sticker
  static const orderSticker = "/product/order/create/v1";
  static const getMyOrders = "/product/order/get/list/v1";

  //purchase product
  static const addToCart = "/product/cart/add/product/v1";
  static const getCartItems = "/product/cart/get/my/carts/v1";
  static String removeCartItem(String id) {
    return "/product/cart/remove/$id/v1";
  }

  static String updateCartQuantity(String id) {
    return "/product/cart/update/$id/v2";
  }

  // Get Vouchers
  static const getVouchers = "/voucher/user/list/v1";

  // Notification
  static const modifyNotification = "/user/modify/notification/permission/v1";

  // contact us
  static const contactUs = "/contactus/send/v1";

  //forcefully update
  static const forcefullyUpdate = "/setting/get/app/version/v1";

  //help & faqs
  static const helpFaqs = "/faq/list/v1";

  // save payments
  static const payment = '/payment/save/v1';

  /// PLAY STORE AND APP STORE URL
  static const playStore = "https://play.google.com/store/apps/details?id=com.app.digibell";
  static const appStore = "";
}
