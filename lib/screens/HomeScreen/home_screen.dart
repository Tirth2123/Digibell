import 'package:Digibells/constants/app_constants.dart';
import 'package:Digibells/main.dart';
import 'package:Digibells/screens/HomeScreen/forcefully_update/bloc/forcefully_update_bloc.dart';
import 'package:Digibells/screens/HomeScreen/get_all_qr_details/bloc/get_all_qr_details_bloc.dart';
import 'package:Digibells/screens/HomeScreen/get_all_qr_details/bloc/get_all_qr_details_event.dart';
import 'package:Digibells/screens/HomeScreen/get_all_qr_details/bloc/get_all_qr_details_state.dart';
import 'package:Digibells/screens/HomeScreen/update_qr_status/bloc/update_qr_status_bloc.dart';
import 'package:Digibells/screens/HomeScreen/update_qr_status/bloc/update_qr_status_event.dart';
import 'package:Digibells/screens/HomeScreen/update_qr_status/bloc/update_qr_status_state.dart';
import 'package:Digibells/screens/NotificationScreen/get_notification/bloc/get_notification_bloc.dart';
import 'package:Digibells/screens/NotificationScreen/get_notification/bloc/get_notification_event.dart';
import 'package:Digibells/utils/alert_utils.dart';
import 'package:Digibells/utils/app_utils.dart';
import 'package:Digibells/utils/date_formate.dart';
import 'package:Digibells/utils/logger.dart';
import 'package:Digibells/widgets/loader_widget.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../app_screens/app_screens.dart';
import '../../constants/asset_path.dart';
import '../../utils/app_styles.dart';
import '../../utils/stream_builder.dart';
import 'get_all_qr_details/model/get_all_qr_details_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetAllQRDetailsBloc>(create: (_) => GetAllQRDetailsBloc()),
        BlocProvider<UpdateQRStatusBloc>(create: (_) => UpdateQRStatusBloc()),
        BlocProvider<ForcefullyUpdateBloc>(create: (_) => ForcefullyUpdateBloc()),
        BlocProvider<GetNotificationsBloc>(create: (_) => GetNotificationsBloc()),
      ],
      child: HomeScreen(),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool isSelect = false;
  bool? noData;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    BlocProvider.of<GetAllQRDetailsBloc>(context).add(
      PerformGetAllQRDetailsEvent(),
    );
    BlocProvider.of<GetNotificationsBloc>(context).add(
      PerformGetNotificationsEvent(),
    );
    super.initState();
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppStyles.white,
        floatingActionButton: noData == true
            ? SizedBox()
            : FloatingActionButton(
                onPressed: () {
                  if (prefs?.getBool(AppConstants.guestLogin) == true) {
                    AlertUtils.showGuestUserDialog(context);
                  } else {
                    Navigator.pushNamed(context, AppScreens.addQrCodeDetails, arguments: {
                      'isUpdate': false,
                      'qrDetails': GetAllQRList(),
                      'index': _tabController.index == 0
                          ? 0
                          : _tabController.index == 1
                              ? 0
                              : _tabController.index == 2
                                  ? 1
                                  : 2,
                      'firstQR': false
                    });
                  }
                },
                backgroundColor: AppStyles.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                tooltip: 'Generate QR',
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 35.w,
                ),
                // child: Image.asset(ImageAssetPath.qrCode, color: Colors.white,height: 22, width: 22,),
              ),
        body: BlocConsumer<GetAllQRDetailsBloc, GetAllQRDetailsState>(
          listener: (context, state) {
            if (state.isCompleted) {
              noData = state.getAllQRDetailsModel?.data?.length == 0 ? true : false;
            }
          },
          builder: (context, state) {
            return BlocConsumer<UpdateQRStatusBloc, UpdateQRStatusState>(
              listener: (context, updateState) {
                if (updateState.isCompleted) {
                  AlertUtils.showToast(updateState.updateQRStatusModel?.message ?? '');
                  BlocProvider.of<GetAllQRDetailsBloc>(context).add(
                    PerformGetAllQRDetailsEvent(),
                  );
                }
              },
              builder: (context, updateState) {
                return Stack(
                  children: [
                    SizedBox(
                      child: noData == true
                          ? noHomeData()
                          : Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.h),
                              child: Column(
                                children: [
                                  Container(
                                    height: 60.h,
                                    color: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 10.h),
                                    child: TabBar(
                                      dividerColor: Colors.transparent,
                                      labelPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.0.h),
                                      controller: _tabController,
                                      indicator: BoxDecoration(
                                        color: AppStyles.activeTabColor,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      labelColor: AppStyles.white,
                                      unselectedLabelColor: AppStyles.primary,
                                      labelStyle: AppStyles.red_16_w300.copyWith(color: AppStyles.white, fontWeight: FontWeight.w500),
                                      unselectedLabelStyle: AppStyles.red_16_w300.copyWith(color: AppStyles.primary, fontWeight: FontWeight.w500),
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      automaticIndicatorColorAdjustment: true,
                                      tabs: [
                                        Tab(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: AppStyles.activeTabColor),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text('All'),
                                            ),
                                          ),
                                        ),
                                        Tab(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: AppStyles.activeTabColor),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text('Home'),
                                            ),
                                          ),
                                        ),
                                        Tab(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: AppStyles.activeTabColor),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text('Hotel'),
                                            ),
                                          ),
                                        ),
                                        Tab(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: AppStyles.activeTabColor),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text('Car'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      physics: NeverScrollableScrollPhysics(),
                                      controller: _tabController,
                                      children: [
                                        sectionAll(state.getAllQRDetailsModel?.data),
                                        sectionHome(state.getAllQRDetailsModel?.data),
                                        sectionHotel(state.getAllQRDetailsModel?.data),
                                        sectionCar(state.getAllQRDetailsModel?.data),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    Visibility(
                      child: LoaderWidget(),
                      visible: state.isLoading,
                    )
                  ],
                );
              },
            );
          },
        ));
  }

  Widget sectionAll(List<GetAllQRList>? data) {
    return SingleChildScrollView(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: data?.length ?? 0,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            isSelect = data?[index].active == true ? true : false;
            return Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.h, bottom: 20.h),
              child: Container(
                // height: 439.2.h,
                // width: 700.w,
                decoration: BoxDecoration(
                  border: Border.all(color: AppStyles.bordercolor),
                  color: AppStyles.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  boxShadow: [BoxShadow(color: AppStyles.dividerColor, blurRadius: 10.0)],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          Image.asset(
                            data?[index].type == 'hotel'
                                ? ImageAssetPath.hotelOneImage
                                : data?[index].type == 'car'
                                    ? ImageAssetPath.carImage
                                    : ImageAssetPath.colorsHome,
                            height: 30.h,
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Text(
                              data?[index].type == 'hotel'
                                  ? data![index].hotelName ?? ''
                                  : data?[index].type == 'car'
                                      ? data![index].carNumber ?? ''
                                      : data?[index].name ?? '',
                              style: AppStyles.black_24_w300.copyWith(fontSize: 15.sp, fontWeight: FontWeight.w500)),
                          Spacer(),
                          FlutterSwitch(
                            height: 20.0,
                            width: 45.0,
                            padding: 0.0,
                            toggleSize: 18.0,
                            borderRadius: 30.0,
                            activeColor: AppStyles.switchColor,
                            activeToggleColor: AppStyles.primary,
                            inactiveColor: AppStyles.switchColor,
                            inactiveToggleColor: AppStyles.white,
                            value: isSelect,
                            onToggle: (value) {
                              setState(() {
                                isSelect = value;
                              });
                              BlocProvider.of<UpdateQRStatusBloc>(context).add(
                                PerformUpdateQRStatusEvent(id: data?[index].sId),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 12.h, bottom: 8.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, AppScreens.activateQRCodeScreen, arguments: {
                                'id': data?[index].sId,
                              });
                            },
                            child: SizedBox(
                              height: 69.h,
                              width: 147.w,
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppStyles.bordercolor)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        ImageAssetPath.activateQrCode,
                                        height: 25.h,
                                      ),
                                      SizedBox(
                                        height: 5.sp,
                                      ),
                                      Text("Activate QR Code", style: AppStyles.greyColor_12_w500)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppScreens.addMemberScreen,
                                arguments: {
                                  'isHotel': data?[index].type == 'hotel' ? true : false,
                                  'qrId': data?[index].sId,
                                },
                              );
                            },
                            child: Container(
                              height: 69.h,
                              width: 147.w,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppStyles.bordercolor)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      ImageAssetPath.addMember,
                                      height: 25.h,
                                    ),
                                    SizedBox(
                                      height: 5.sp,
                                    ),
                                    Text("Add Member", style: AppStyles.greyColor_12_w500)
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 12.h, bottom: 8.h),
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppScreens.callHistoryScreen,
                              );
                            },
                            child: Container(
                              height: 69.h,
                              width: 147.w,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppStyles.bordercolor)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      ImageAssetPath.callHistory,
                                      height: 25.h,
                                    ),
                                    SizedBox(
                                      height: 5.sp,
                                    ),
                                    Text("Call History", style: AppStyles.greyColor_12_w500)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, AppScreens.addQrCodeDetails, arguments: {
                                'isUpdate': true,
                                'qrDetails': data?[index],
                                'index': data?[index].type == 'hotel'
                                    ? 1
                                    : data?[index].type == 'car'
                                        ? 2
                                        : 0,
                                'firstQR': false
                              });
                            },
                            child: Container(
                              height: 69.h,
                              width: 147.w,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppStyles.bordercolor)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      ImageAssetPath.editInformation,
                                      height: 25.h,
                                    ),
                                    SizedBox(
                                      height: 5.sp,
                                    ),
                                    Text("Edit Information", style: AppStyles.greyColor_12_w500)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 22.w,
                        right: 22.w,
                        top: 15.h,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppScreens.viewQRCodeScreen,
                              arguments: {'qrCode': data?[index].qrImage, 'id': data?[index].sId});
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppStyles.white,
                          padding: EdgeInsets.symmetric(vertical: 11.h),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: AppStyles.bordercolor),
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(ImageAssetPath.viewQrCodeSvg),
                            SizedBox(
                              width: 15.w,
                            ),
                            Text('View QR code',
                                style: AppStyles.greyColor_12_w500.copyWith(
                                  fontSize: 15.sp,
                                )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Container(
                      // height: 100.h,
                      // width: 700.w,
                      decoration: BoxDecoration(
                          color: AppStyles.primary,
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
                      child: Padding(
                        padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 12.h, bottom: 17.h),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data?[index].subscriptionDetails != null ? data![index].subscriptionDetails?.name ?? '' : "Free",
                                  style: AppStyles.white_15_w500.copyWith(fontSize: 19.sp, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 100.w,
                                  height: 35.h,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (data?[index].subscriptionDetails == null)
                                        Navigator.pushNamed(context, AppScreens.subscriptionScreen, arguments: {
                                          'qrId': data?[index].sId,
                                          'update': true,
                                          'index': data?[index].type == 'hotel'
                                              ? 1
                                              : data?[index].type == 'car'
                                                  ? 2
                                                  : 0
                                        });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: AppStyles.white,
                                      padding: EdgeInsets.symmetric(vertical: 9.h),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: AppStyles.bordercolor),
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                    ),
                                    child: Text(
                                      data?[index].subscriptionDetails != null
                                          ? '₹ ${data![index].subscriptionDetails?.price.toString()}/-'
                                          : 'UpGrade',
                                      style: AppStyles.black_17_w600.copyWith(
                                        fontSize: 13.sp,
                                        color: AppStyles.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Text(
                                data![index].subscriptionDetails != null
                                    ? "Your subscription is valid until ${formatDate(data[index].validUpto ?? '')}"
                                    : "You’ve received a ${data![index].remainingDay ?? '3'}-day free trial as our welcome gift to you.",
                                maxLines: 3,
                                style: AppStyles.white_15_w500.copyWith(
                                  fontSize: 12.sp,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget sectionHome(List<GetAllQRList>? data) {
    final filteredList = data?.where((item) => item.type == 'home').toList() ?? [];
    return filteredList.length == 0
        ? Center(child: Text("No home added!"))
        : SingleChildScrollView(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  isSelect = filteredList[index].active == true ? true : false;

                  return Padding(
                    padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.h, bottom: 20.h),
                    child: Container(
                      // height: 439.2.h,
                      // width: 700.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppStyles.bordercolor),
                        color: AppStyles.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        boxShadow: [BoxShadow(color: AppStyles.dividerColor, blurRadius: 10.0)],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  ImageAssetPath.colorsHome,
                                  height: 30.h,
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Text(filteredList[index].name ?? '',
                                    style: AppStyles.black_24_w300.copyWith(fontSize: 15.sp, fontWeight: FontWeight.w500)),
                                Spacer(),
                                FlutterSwitch(
                                  height: 20.0,
                                  width: 45.0,
                                  padding: 0.0,
                                  toggleSize: 18.0,
                                  borderRadius: 30.0,
                                  activeColor: AppStyles.switchColor,
                                  activeToggleColor: AppStyles.primary,
                                  inactiveColor: AppStyles.switchColor,
                                  inactiveToggleColor: AppStyles.white,
                                  value: isSelect,
                                  onToggle: (value) {
                                    setState(() {
                                      isSelect = value;
                                    });
                                    BlocProvider.of<UpdateQRStatusBloc>(context).add(
                                      PerformUpdateQRStatusEvent(id: filteredList[index].sId),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 12.h, bottom: 8.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, AppScreens.activateQRCodeScreen, arguments: {
                                      'id': filteredList[index].sId,
                                    });
                                  },
                                  child: Container(
                                    height: 69.h,
                                    width: 147.w,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppStyles.bordercolor)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            ImageAssetPath.activateQrCode,
                                            height: 25.h,
                                          ),
                                          SizedBox(
                                            height: 5.sp,
                                          ),
                                          Text("Activate QR Code", style: AppStyles.greyColor_12_w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppScreens.addMemberScreen,
                                      arguments: {
                                        'isHotel': false,
                                        'qrId': filteredList[index].sId,
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 69.h,
                                    width: 147.w,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppStyles.bordercolor)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            ImageAssetPath.addMember,
                                            height: 25.h,
                                          ),
                                          SizedBox(
                                            height: 5.sp,
                                          ),
                                          Text("Add Member", style: AppStyles.greyColor_12_w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 12.h, bottom: 8.h),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppScreens.callHistoryScreen,
                                    );
                                  },
                                  child: Container(
                                    height: 69.h,
                                    width: 147.w,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppStyles.bordercolor)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            ImageAssetPath.callHistory,
                                            height: 25.h,
                                          ),
                                          SizedBox(
                                            height: 5.sp,
                                          ),
                                          Text("Call History", style: AppStyles.greyColor_12_w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, AppScreens.addQrCodeDetails,
                                        arguments: {'isUpdate': true, 'qrDetails': filteredList[index], 'index': 0, 'firstQR': false});
                                  },
                                  child: Container(
                                    height: 69.h,
                                    width: 147.w,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppStyles.bordercolor)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            ImageAssetPath.editInformation,
                                            height: 25.h,
                                          ),
                                          SizedBox(
                                            height: 5.sp,
                                          ),
                                          Text("Edit Information", style: AppStyles.greyColor_12_w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 22.w,
                              right: 22.w,
                              top: 15.h,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, AppScreens.viewQRCodeScreen,
                                    arguments: {'qrCode': filteredList[index].qrImage, 'id': filteredList[index].sId});
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: AppStyles.white,
                                padding: EdgeInsets.symmetric(vertical: 11.h),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: AppStyles.bordercolor),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(ImageAssetPath.viewQrCodeSvg),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text('View QR code',
                                      style: AppStyles.greyColor_12_w500.copyWith(
                                        fontSize: 15.sp,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Container(
                            // height: 100.h,
                            // width: 700.w,
                            decoration: BoxDecoration(
                                color: AppStyles.primary,
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
                            child: Padding(
                              padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 12.h, bottom: 17.h),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        filteredList[index].subscriptionDetails != null
                                            ? filteredList[index].subscriptionDetails?.name.toString() ?? ''
                                            : "Free",
                                        style: AppStyles.white_15_w500.copyWith(fontSize: 19.sp, fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        width: 100.w,
                                        height: 35.h,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (filteredList[index].subscriptionDetails == null)
                                              Navigator.pushNamed(context, AppScreens.subscriptionScreen,
                                                  arguments: {'qrId': filteredList[index].sId, 'update': true, 'index': 0});
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor: AppStyles.white,
                                            padding: EdgeInsets.symmetric(vertical: 9.h),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(color: AppStyles.bordercolor),
                                              borderRadius: BorderRadius.circular(11),
                                            ),
                                          ),
                                          child: Text(
                                            filteredList[index].subscriptionDetails != null
                                                ? '₹ ${filteredList[index].subscriptionDetails?.price.toString()}/-'
                                                : 'UpGrade',
                                            style: AppStyles.black_17_w600.copyWith(
                                              fontSize: 13.sp,
                                              color: AppStyles.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Text(
                                      filteredList[index].subscriptionDetails != null
                                          ? "Your plan is valid until ${formatDate(filteredList[index].validUpto ?? '')}"
                                          : "You’ve received a ${filteredList[index].remainingDay ?? '3'}-day free trial as our welcome gift to you.",
                                      maxLines: 3,
                                      style: AppStyles.white_15_w500.copyWith(
                                        fontSize: 12.sp,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
  }

  Widget sectionHotel(List<GetAllQRList>? data) {
    final filteredList = data?.where((item) => item.type == 'hotel').toList() ?? [];
    return filteredList.length == 0
        ? Center(child: Text("No hotel added!"))
        : SingleChildScrollView(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  isSelect = filteredList[index].active == true ? true : false;
                  return Padding(
                    padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 5.h, bottom: 20.h),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppStyles.bordercolor),
                        color: AppStyles.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        boxShadow: [BoxShadow(color: AppStyles.dividerColor, blurRadius: 10.0)],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                            child: Row(
                              children: [
                                Image.asset(
                                  ImageAssetPath.hotelOneImage,
                                  height: 40.h,
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(filteredList[index].hotelName ?? '',
                                        style: AppStyles.black_24_w300.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                                    SizedBox(
                                        width: 200.w,
                                        child: Text(
                                          "${filteredList[index].address}, ${filteredList[index].city}, ${filteredList[index].state}, ${filteredList[index].pincode}",
                                          style: AppStyles.hintText_15_w400.copyWith(fontSize: 12.sp, overflow: TextOverflow.ellipsis),
                                          maxLines: 2,
                                        )),
                                  ],
                                ),
                                Spacer(),
                                FlutterSwitch(
                                  height: 20.0,
                                  width: 45.0,
                                  padding: 0.0,
                                  toggleSize: 18.0,
                                  borderRadius: 30.0,
                                  activeColor: AppStyles.switchColor,
                                  activeToggleColor: AppStyles.primary,
                                  inactiveColor: AppStyles.switchColor,
                                  inactiveToggleColor: AppStyles.white,
                                  value: isSelect,
                                  onToggle: (value) {
                                    setState(() {
                                      isSelect = value;
                                    });
                                    BlocProvider.of<UpdateQRStatusBloc>(context).add(
                                      PerformUpdateQRStatusEvent(id: filteredList[index].sId),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          Divider(),
                          // Padding(
                          //   padding: EdgeInsets.only(left: 22.w, right: 22.w, top: 12.h, bottom: 8.h),
                          //   child: Column(
                          //     children: [
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           InkWell(
                          //             onTap: () {
                          //               Navigator.pushNamed(context, AppScreens.activateQRCodeScreen, arguments: {
                          //                 'id': filteredList[index].sId,
                          //               });
                          //             },
                          //             child: Container(
                          //               height: 69.h,
                          //               width: 147.w,
                          //               decoration:
                          //                   BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppStyles.bordercolor)),
                          //               child: Padding(
                          //                 padding: const EdgeInsets.all(8.0),
                          //                 child: Column(
                          //                   children: [
                          //                     Image.asset(
                          //                       ImageAssetPath.activateQrCode,
                          //                       height: 25.h,
                          //                     ),
                          //                     SizedBox(
                          //                       height: 5.sp,
                          //                     ),
                          //                     Text("Activate QR Code", style: AppStyles.greyColor_12_w500)
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //           SizedBox(
                          //             width: 20.w,
                          //           ),
                          //           GestureDetector(
                          //             onTap: () {},
                          //             child: Container(
                          //               height: 69.h,
                          //               width: 147.w,
                          //               decoration:
                          //                   BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppStyles.bordercolor)),
                          //               child: Padding(
                          //                 padding: const EdgeInsets.all(8.0),
                          //                 child: Column(
                          //                   children: [
                          //                     Image.asset(
                          //                       ImageAssetPath.editInformation,
                          //                       height: 25.h,
                          //                     ),
                          //                     SizedBox(
                          //                       height: 5.sp,
                          //                     ),
                          //                     Text("Edit Information", style: AppStyles.greyColor_12_w500)
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //       SizedBox(
                          //         height: 15.h,
                          //       ),
                          //       ElevatedButton(
                          //         onPressed: () {
                          //           Navigator.pushNamed(
                          //             context,
                          //             AppScreens.addMemberScreen,
                          //           );
                          //         },
                          //         style: ElevatedButton.styleFrom(
                          //           elevation: 0,
                          //           backgroundColor: AppStyles.white,
                          //           padding: EdgeInsets.symmetric(vertical: 11.h),
                          //           shape: RoundedRectangleBorder(
                          //             side: BorderSide(color: AppStyles.bordercolor),
                          //             borderRadius: BorderRadius.circular(11),
                          //           ),
                          //         ),
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             Image.asset(
                          //               ImageAssetPath.addMember,
                          //               height: 25.h,
                          //             ),
                          //             SizedBox(
                          //               width: 15.w,
                          //             ),
                          //             Text('Add Member', style: AppStyles.greyColor_12_w500.copyWith(fontSize: 15.sp, color: AppStyles.primary)),
                          //           ],
                          //         ),
                          //       ),
                          //       // SizedBox(
                          //       //   height: 20.h,
                          //       // ),
                          //       // Row(
                          //       //   children: [
                          //       //     Icon(
                          //       //       Icons.circle,
                          //       //       size: 7.h,
                          //       //     ),
                          //       //     SizedBox(
                          //       //       width: 15.h,
                          //       //     ),
                          //       //     Text(
                          //       //       "Available QR Code",
                          //       //       style: AppStyles.black_14_w500,
                          //       //     ),
                          //       //     SizedBox(
                          //       //       width: 10.h,
                          //       //     ),
                          //       //     Text(
                          //       //       "0/8",
                          //       //       style: AppStyles.black_14_w500,
                          //       //     ),
                          //       //   ],
                          //       // ),
                          //     ],
                          //   ),
                          // ),
                          Padding(
                            padding: EdgeInsets.only(left: 22.w, right: 22.w, top: 12.h, bottom: 8.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, AppScreens.activateQRCodeScreen, arguments: {
                                      'id': filteredList[index].sId,
                                    });
                                  },
                                  child: Container(
                                    height: 69.h,
                                    width: 147.w,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppStyles.bordercolor)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            ImageAssetPath.activateQrCode,
                                            height: 25.h,
                                          ),
                                          SizedBox(
                                            height: 5.sp,
                                          ),
                                          Text("Activate QR Code", style: AppStyles.greyColor_12_w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppScreens.addMemberScreen,
                                      arguments: {
                                        'isHotel': true,
                                        'qrId': filteredList[index].sId,
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 69.h,
                                    width: 147.w,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppStyles.bordercolor)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            ImageAssetPath.addMember,
                                            height: 25.h,
                                          ),
                                          SizedBox(
                                            height: 5.sp,
                                          ),
                                          Text("Add Member", style: AppStyles.greyColor_12_w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 22.w, right: 22.w, top: 12.h, bottom: 8.h),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppScreens.callHistoryScreen,
                                    );
                                  },
                                  child: Container(
                                    height: 69.h,
                                    width: 147.w,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppStyles.bordercolor)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            ImageAssetPath.callHistory,
                                            height: 25.h,
                                          ),
                                          SizedBox(
                                            height: 5.sp,
                                          ),
                                          Text("Call History", style: AppStyles.greyColor_12_w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, AppScreens.addQrCodeDetails,
                                        arguments: {'isUpdate': true, 'qrDetails': filteredList[index], 'index': 1, 'firstQR': false});
                                  },
                                  child: Container(
                                    height: 69.h,
                                    width: 147.w,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppStyles.bordercolor)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            ImageAssetPath.editInformation,
                                            height: 25.h,
                                          ),
                                          SizedBox(
                                            height: 5.sp,
                                          ),
                                          Text("Edit Information", style: AppStyles.greyColor_12_w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 22.w,
                              right: 22.w,
                              top: 15.h,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, AppScreens.viewQRCodeScreen,
                                    arguments: {'qrCode': filteredList[index].qrImage, 'id': filteredList[index].sId});
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: AppStyles.white,
                                padding: EdgeInsets.symmetric(vertical: 11.h),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: AppStyles.bordercolor),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(ImageAssetPath.viewQrCodeSvg),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text('View QR code',
                                      style: AppStyles.greyColor_12_w500.copyWith(
                                        fontSize: 15.sp,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Container(
                            // height: 100.h,
                            // width: 700.w,
                            decoration: BoxDecoration(
                                color: AppStyles.primary,
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
                            child: Padding(
                              padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 12.h, bottom: 17.h),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        filteredList[index].subscriptionDetails != null
                                            ? filteredList[index].subscriptionDetails?.name.toString() ?? ''
                                            : "Free",
                                        style: AppStyles.white_15_w500.copyWith(fontSize: 19.sp, fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        width: 100.w,
                                        height: 35.h,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (filteredList[index].subscriptionDetails == null)
                                              Navigator.pushNamed(context, AppScreens.subscriptionScreen,
                                                  arguments: {'qrId': filteredList[index].sId, 'update': true, 'index': 1});
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor: AppStyles.white,
                                            padding: EdgeInsets.symmetric(vertical: 9.h),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(color: AppStyles.bordercolor),
                                              borderRadius: BorderRadius.circular(11),
                                            ),
                                          ),
                                          child: Text(
                                            filteredList[index].subscriptionDetails != null
                                                ? '₹ ${filteredList[index].subscriptionDetails?.price.toString()}/-'
                                                : 'UpGrade',
                                            style: AppStyles.black_17_w600.copyWith(
                                              fontSize: 13.sp,
                                              color: AppStyles.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Text(
                                      filteredList[index].subscriptionDetails != null
                                          ? "Your plan is valid until ${formatDate(filteredList[index].validUpto ?? '')}"
                                          : "You’ve received a ${filteredList[index].remainingDay ?? '3'}-day free trial as our welcome gift to you.",
                                      maxLines: 3,
                                      style: AppStyles.white_15_w500.copyWith(
                                        fontSize: 12.sp,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
  }

  Widget sectionCar(List<GetAllQRList>? data) {
    final filteredList = data?.where((item) => item.type == 'car').toList() ?? [];
    return filteredList.length == 0
        ? Center(child: Text("No car added!"))
        : SingleChildScrollView(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  isSelect = filteredList[index].active == true ? true : false;
                  return Padding(
                    padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 5.h, bottom: 20.h),
                    child: Container(
                      // height: 439.2.h,
                      // width: 700.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppStyles.bordercolor),
                        color: AppStyles.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        boxShadow: [BoxShadow(color: AppStyles.dividerColor, blurRadius: 10.0)],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  ImageAssetPath.carImage,
                                  height: 30.h,
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Text(filteredList[index].carNumber ?? '',
                                    style: AppStyles.black_24_w300.copyWith(fontSize: 15.sp, fontWeight: FontWeight.w500)),
                                Spacer(),
                                FlutterSwitch(
                                  height: 20.0,
                                  width: 45.0,
                                  padding: 0.0,
                                  toggleSize: 18.0,
                                  borderRadius: 30.0,
                                  activeColor: AppStyles.switchColor,
                                  activeToggleColor: AppStyles.primary,
                                  inactiveColor: AppStyles.switchColor,
                                  inactiveToggleColor: AppStyles.white,
                                  value: isSelect,
                                  onToggle: (value) {
                                    setState(() {
                                      isSelect = value;
                                    });
                                    BlocProvider.of<UpdateQRStatusBloc>(context).add(
                                      PerformUpdateQRStatusEvent(id: filteredList[index].sId),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.only(left: 22.w, right: 22.w, top: 12.h, bottom: 8.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, AppScreens.activateQRCodeScreen, arguments: {
                                      'id': filteredList[index].sId,
                                    });
                                  },
                                  child: Container(
                                    height: 69.h,
                                    width: 147.w,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppStyles.bordercolor)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            ImageAssetPath.activateQrCode,
                                            height: 25.h,
                                          ),
                                          SizedBox(
                                            height: 5.sp,
                                          ),
                                          Text("Activate QR Code", style: AppStyles.greyColor_12_w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppScreens.addMemberScreen,
                                      arguments: {
                                        'isHotel': false,
                                        'qrId': filteredList[index].sId,
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 69.h,
                                    width: 147.w,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppStyles.bordercolor)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            ImageAssetPath.addMember,
                                            height: 25.h,
                                          ),
                                          SizedBox(
                                            height: 5.sp,
                                          ),
                                          Text("Add Member", style: AppStyles.greyColor_12_w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 22.w, right: 22.w, top: 12.h, bottom: 8.h),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppScreens.callHistoryScreen,
                                    );
                                  },
                                  child: Container(
                                    height: 69.h,
                                    width: 147.w,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppStyles.bordercolor)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            ImageAssetPath.callHistory,
                                            height: 25.h,
                                          ),
                                          SizedBox(
                                            height: 5.sp,
                                          ),
                                          Text("Call History", style: AppStyles.greyColor_12_w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, AppScreens.addQrCodeDetails,
                                        arguments: {'isUpdate': true, 'qrDetails': filteredList[index], 'index': 2, 'firstQR': false});
                                  },
                                  child: Container(
                                    height: 69.h,
                                    width: 147.w,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppStyles.bordercolor)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            ImageAssetPath.editInformation,
                                            height: 25.h,
                                          ),
                                          SizedBox(
                                            height: 5.sp,
                                          ),
                                          Text("Edit Information", style: AppStyles.greyColor_12_w500)
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 22.w,
                              right: 22.w,
                              top: 15.h,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, AppScreens.viewQRCodeScreen,
                                    arguments: {'qrCode': filteredList[index].qrImage, 'id': filteredList[index].sId});
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: AppStyles.white,
                                padding: EdgeInsets.symmetric(vertical: 11.h),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: AppStyles.bordercolor),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(ImageAssetPath.viewQrCodeSvg),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text('View QR code',
                                      style: AppStyles.greyColor_12_w500.copyWith(
                                        fontSize: 15.sp,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Container(
                            // height: 100.h,
                            // width: 700.w,
                            decoration: BoxDecoration(
                                color: AppStyles.primary,
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
                            child: Padding(
                              padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 12.h, bottom: 17.h),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        filteredList[index].subscriptionDetails != null
                                            ? filteredList[index].subscriptionDetails?.name.toString() ?? ''
                                            : "Free",
                                        style: AppStyles.white_15_w500.copyWith(fontSize: 19.sp, fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        width: 100.w,
                                        height: 35.h,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (filteredList[index].subscriptionDetails == null)
                                              Navigator.pushNamed(context, AppScreens.subscriptionScreen,
                                                  arguments: {'qrId': filteredList[index].sId, 'update': true, 'index': 2});
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor: AppStyles.white,
                                            padding: EdgeInsets.symmetric(vertical: 9.h),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(color: AppStyles.bordercolor),
                                              borderRadius: BorderRadius.circular(11),
                                            ),
                                          ),
                                          child: Text(
                                            filteredList[index].subscriptionDetails != null
                                                ? '₹ ${filteredList[index].subscriptionDetails?.price.toString()}/-'
                                                : 'UpGrade',
                                            style: AppStyles.black_17_w600.copyWith(
                                              fontSize: 13.sp,
                                              color: AppStyles.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Text(
                                      filteredList[index].subscriptionDetails != null
                                          ? "Your plan is valid until ${formatDate(filteredList[index].validUpto ?? '')}"
                                          : "You’ve received a ${filteredList[index].remainingDay ?? '3'}-day free trial as our welcome gift to you.",
                                      maxLines: 3,
                                      style: AppStyles.white_15_w500.copyWith(
                                        fontSize: 12.sp,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
  }

  Widget noHomeData() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text("Welcome to DigiBells", style: AppStyles.black_24_w300),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                child: Text(
                  "We're dedicated to redefining the way you interact with your doorbell. We believe in simplicity, security, and seamless experiences.",
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppStyles.textFieldText_15_w500.copyWith(color: AppStyles.normalText),
                ),
              ),
            ),
          ),
          SizedBox(height: 30.h),
          SizedBox(
            height: 250.h, // Set a fixed height for the Swiper
            child: Swiper(
              onIndexChanged: (index) {
                setState(() {
                  _currentIndex = index; // Update current index
                });
              },
              itemCount: 2,
              autoplay: true,
              itemBuilder: (context, index) {
                final imagePath = index == 0
                    ? ImageAssetPath.home_1 // First image
                    : ImageAssetPath.home_2; // Second image
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    left: 5.w,
                  ),
                  child: Container(
                    width: 7.w,
                    height: 7.h,
                    margin: EdgeInsets.symmetric(
                      horizontal: 0.7.w,
                    ),
                    decoration: BoxDecoration(
                      color: _currentIndex == index ? AppStyles.primary : AppStyles.textFieldBorderColor,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: _currentIndex == index ? AppStyles.primary : AppStyles.textFieldBorderColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 70.h),
          SizedBox(
            width: 300.w,
            height: 55.h,
            child: ElevatedButton(
              onPressed: () {
                if (prefs?.getBool(AppConstants.guestLogin) == true) {
                  AlertUtils.showGuestUserDialog(context);
                } else {
                  Navigator.pushNamed(context, AppScreens.addQrCodeDetails,
                      arguments: {'isUpdate': false, 'qrDetails': GetAllQRList(), 'index': 0, 'firstQR': true});
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppStyles.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppStyles.primary),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Activate QR code',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: AppStyles.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
