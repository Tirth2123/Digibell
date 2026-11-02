import 'package:Digibells/screens/Address/SavedAddress/saved_address_screen.dart';
import 'package:Digibells/screens/ProductDetailsScreen/product_details_screen.dart';
import 'package:Digibells/screens/ProfileScreen/settings/setting_screen.dart';
import 'package:Digibells/screens/voucher_screen/voucher_screen.dart';
import 'package:flutter/material.dart';
import '../app_screens/app_screens.dart';
import '../screens/ActivateQrCode/activate_qr_code_screen.dart';
import '../screens/AddMember/add_member.dart';
import '../screens/AddMember/new_member_add.dart';
import '../screens/AddQRCodeDetails/add_qr_code_details.dart';
import '../screens/Address/AddAddress/add_addresses_screen.dart';
import '../screens/CallHistory/call_history.dart';
import '../screens/FavouriteMember/favourite_member_screen.dart';
import '../screens/FirstTimeHomeScreen/first_time_home_screen.dart';
import '../screens/HomeScreen/home_screen.dart';
import '../screens/LoginScreen/login_screen.dart';
import '../screens/NotificationScreen/notification_screen.dart';
import '../screens/OrderHistoryScreen/order_history.dart';
import '../screens/ProfileScreen/help_faqs/help_faqs_view.dart';
import '../screens/ProfileScreen/profile_screen.dart';
import '../screens/SingUP/sing_up_screen.dart';
import '../screens/SubscriptionScreen/subscription_screen.dart';
import '../screens/ViewQRCode/sticker_order_history.dart';
import '../screens/ViewQRCode/view_qr_code.dart';
import '../screens/callingScreens/audio_call_screen.dart';
import '../screens/callingScreens/ringing_incomingcall_screen.dart';
import '../screens/callingScreens/video_call_screen.dart';
import '../screens/shopping_cart/shopping_cart_screen.dart';
import '../screens/splashScreen/splash_screen.dart';

class AppRouter {
  final RouteObserver<PageRoute> routeObserver;

  AppRouter() : routeObserver = RouteObserver<PageRoute>();

  Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppScreens.splashscreen:
        return _buildRoute(
          settings,
          SplashScreen(),
        );
      case AppScreens.loginScreen:
        return _buildRoute(
          settings,
          LoginScreen(),
        );
      case AppScreens.singUpScreen:
        return _buildRoute(
          settings,
          SingUpScreen(),
        );
      case AppScreens.firstTimeHomeScreen:
        return _buildRoute(
          settings,
          FirstTimeHomeScreen(),
        );
      case AppScreens.subscriptionScreen:
        final argument = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          settings,
          SubscriptionScreen.create(
            argument['update'],
            argument['index'],
            argument['qrId'],
          ),
        );

      case AppScreens.addQrCodeDetails:
        final argument = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          settings,
          AddQrCodeDetails(
            qrDetails: argument['qrDetails'],
            isUpdate: argument['isUpdate'],
            index: argument['index'],
            firstQR: argument['firstQR'],
          ),
        );
      case AppScreens.homeScreen:
        return _buildRoute(
          settings,
          HomeScreen(),
        );
      case AppScreens.viewQRCodeScreen:
        final argument = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          settings,
          ViewQRCodeScreen(
            qrCode: argument['qrCode'],
            id: argument['id'],
          ),
        );
      case AppScreens.addMemberScreen:
        final argument = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          settings,
          AddMemberScreen(isHotel: argument['isHotel'],qrId: argument['qrId'],),
        );
      case AppScreens.stickerOrderHistoryScreen:
        return _buildRoute(
          settings,
          StickerOrderHistoryScreen(),
        );
      case AppScreens.newAddMemberScreen:
        return _buildRoute(
          settings,
          NewMemberAddScreen(),
        );
      case AppScreens.callHistoryScreen:
        return _buildRoute(
          settings,
          CallHistoryScreen(),
        );
      case AppScreens.profileScreen:
        return _buildRoute(
          settings,
          ProfileScreen(),
        );
      case AppScreens.helpAndFaqs:
        return _buildRoute(
          settings,
          HelpAndFaqScreen(),
        );
      // case AppScreens.productDetailsScreen:
      //   return _buildRoute(
      //     settings,
      //     ProductDetailsScreen(),
      //   );
      case AppScreens.orderHistoryScreen:
        final argument = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          settings,
          OrderHistoryScreen(fromDrawer: argument['fromDrawer'],),
        );
      case AppScreens.voucherScreen:
        return _buildRoute(
          settings,
          VoucherScreen(),
        );
      case AppScreens.notificationScreen:
        return _buildRoute(
          settings,
          NotificationScreen(),
        );
      case AppScreens.addAddressesScreen:
        final argument = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          settings,
          AddAddressesScreen(
            id: argument['id'],
            city: argument['city'],
            area: argument['area'],
            house: argument['house'],
            landMark: argument['landmark'],
            pinCode: argument['pinCode'],
          ),
        );
      case AppScreens.favouriteMemberScreen:
        return _buildRoute(
          settings,
          FavouriteMemberScreen(),
        );
      case AppScreens.activateQRCodeScreen:
        final argument = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          settings,
          QRScanScreen(
            id: argument['id'],
          ),
        );
      // case AppScreens.upgradeSubscriptionPlanScreen:
      //   return _buildRoute(
      //     settings,
      //     UpgradeSubscriptionPlanScreen(),
      //   );
      case AppScreens.savedAddress:
        final argument = settings.arguments as Map<String, dynamic>;
        return _buildRoute(settings, SavedAddressScreen.create(argument['fromShopping'], argument['fromDrawer']));
      case AppScreens.settingScreen:
        return _buildRoute(
          settings,
          SettingScreen(),
        );
      case AppScreens.ringingScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          settings,
          RingingScreen(
            callId: arguments['callId'],
            userCount: arguments['userCount'],
            receiverId: arguments['receiverId'],
            type: arguments['type'],
            callerName: arguments['callerName'],
            token: arguments['token'],
            channelName: arguments['channelName'],
            callerId: arguments['callerId'],
            members: arguments['members'],
          ),
        );
      case AppScreens.audioCallScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          settings,
          AudioCallScreen(
            callId: arguments['callId'],
            userCount: arguments['userCount'],
            members: arguments['members'],
            callerId: arguments['callerId'],
            receiverId: arguments['receiverId'],
            callerName: arguments['callerName'],
            channelName: arguments['channelName'],
            token: arguments['token'],
          ),
        );
      case AppScreens.videoCallScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          settings,
          VideoCallScreen(
            members: arguments['members'],
            userCount: arguments['userCount'],
            callId: arguments['callId'],
            callerId: arguments['callerId'],
            receiverId: arguments['receiverId'],
            callerName: arguments['callerName'],
            channelName: arguments['channelName'],
            token: arguments['token'],
          ),
        );
      case AppScreens.productDetailsScreen:
        final argument = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          settings,
          ProductDetailsScreen(id: argument['id']),
        );
      case AppScreens.shoppingCartScreen:
        final argument = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          settings,
          ShoppingCartScreen.create(
            argument['discount'],
            argument['voucherCode'],
          ),
        );
      default:
        return _buildRoute(
          settings,
          const Scaffold(
            body: SizedBox(
              child: Text('Screen is Not Defined'),
            ),
          ),
        );
    }
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => builder,
    );
  }
}
