import 'package:Digibells/screens/Address/delete_address/bloc/delete_address_bloc.dart';
import 'package:Digibells/screens/Address/delete_address/bloc/delete_address_event.dart';
import 'package:Digibells/screens/Address/delete_address/bloc/delete_address_state.dart';
import 'package:Digibells/screens/Address/set_default_address/bloc/set_default_address_bloc.dart';
import 'package:Digibells/screens/Address/set_default_address/bloc/set_default_address_event.dart';
import 'package:Digibells/screens/Address/set_default_address/bloc/set_default_address_state.dart';
import 'package:Digibells/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app_screens/app_screens.dart';
import '../../../utils/alert_utils.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/stream_builder.dart';
import '../../../widgets/loader_widget.dart';
import '../get_address/bloc/get_address_bloc.dart';

class SavedAddressScreen extends StatefulWidget {
  bool fromShopping = false;
  bool fromDrawer = false;
  SavedAddressScreen({super.key, required this.fromShopping, required this.fromDrawer});

  static Widget create(bool fromShopping, bool fromDrawer) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetAddressScreenBloc>(create: (_) => GetAddressScreenBloc()),
        BlocProvider<DeleteAddressBloc>(create: (_) => DeleteAddressBloc()),
        BlocProvider<SetDefaultAddressBloc>(create: (_) => SetDefaultAddressBloc()),
      ],
      child: SavedAddressScreen(
        fromShopping: fromShopping,
        fromDrawer: fromDrawer,
      ),
    );
  }

  @override
  State<SavedAddressScreen> createState() => _SavedAddressScreenState();
}

class _SavedAddressScreenState extends State<SavedAddressScreen> {
  @override
  void initState() {
    BlocProvider.of<GetAddressScreenBloc>(context).add(
      PerformGetAddressScreenEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // onPopInvoked: (bool value) {
      //   if (widget.fromShopping == true) {
      //     Navigator.pushReplacementNamed(context, AppScreens.shoppingCartScreen, arguments: {'voucherCode': '', 'discount': 0});
      //   }else if(widget.fromDrawer == true){
      //     logger.w("HHHEEEERRRREEE 0==> ${value}");
      //     logger.w("HHHEEEERRRREEE 1==> ${widget.fromDrawer}");
      //     logger.w("HHHEEEERRRREEE 2==> ${Navigator.canPop(context)}");
      //     if(Navigator.canPop(context)) {
      //       Navigator.pop(context);
      //     }
      //   } else {
      //     Navigator.pushNamedAndRemoveUntil(context, AppScreens.firstTimeHomeScreen, (Route<dynamic> route) => false);
      //     StreamUtil.bottomNavigationIndex.add(3);
      //   }
      // },
      child: Scaffold(
        backgroundColor: AppStyles.white,
        appBar: AppBar(
          backgroundColor: AppStyles.white,
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          // toolbarHeight: 90.h,
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: AppStyles.black,
                  size: 28.w,
                ),
                onPressed: () async {
                  var result = await Navigator.pushNamed(context, AppScreens.addAddressesScreen, arguments: {
                    'id': '',
                    'pinCode': '',
                    'landmark': '',
                    'house': '',
                    'area': '',
                    'city': '',
                  });

                  if (result == true) {
                    BlocProvider.of<GetAddressScreenBloc>(context).add(
                      PerformGetAddressScreenEvent(),
                    );
                  }
                },
              ),
            )
          ],
          leading: IconButton(
            onPressed: () {
              if (widget.fromShopping == true) {
                Navigator.pushReplacementNamed(context, AppScreens.shoppingCartScreen, arguments: {'voucherCode': '', 'discount': 0});
              } else if(widget.fromDrawer == true){
                Navigator.pop(context);
              }else {
                Navigator.pushNamedAndRemoveUntil(context, AppScreens.firstTimeHomeScreen, (Route<dynamic> route) => false);
                StreamUtil.bottomNavigationIndex.add(3);
              }
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppStyles.black,
            ),
          ),
          title: Text(
            "Saved Address",
            style: AppStyles.black_24_w300,
          ),
        ),
        body: SizedBox(
          child: BlocConsumer<GetAddressScreenBloc, GetAddressScreenState>(
            listener: (context, state) {
              if (state.isCompleted) {
              } else if (state.isFailed) {
                // AlertUtils.showToast(
                //   stateCart.errorMsg ?? AppConstString.somethingError,
                // );
              }
            },
            builder: (context, state) {
              return BlocConsumer<DeleteAddressBloc, DeleteAddressState>(
                listener: (context, deleteState) {
                  if (deleteState.isCompleted) {
                    AlertUtils.showToast('Address deleted successfully.');
                    BlocProvider.of<GetAddressScreenBloc>(context).add(
                      PerformGetAddressScreenEvent(),
                    );
                  }
                },
                builder: (context, deleteState) {
                  return BlocConsumer<SetDefaultAddressBloc, SetDefaultAddressState>(
                    listener: (context, defaultState) {
                      if (defaultState.isCompleted) {
                        AlertUtils.showToast('Address set as default successfully.');
                        BlocProvider.of<GetAddressScreenBloc>(context).add(
                          PerformGetAddressScreenEvent(),
                        );
                      }
                    },
                    builder: (context, defaultState) {
                      return SizedBox(
                        child: Stack(
                          children: [
                            state.getAllAddressModel?.data?.length == 0
                                ? Center(
                                    child: Text("No Address Found"),
                                  )
                                : ListView.separated(
                                    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
                                    itemBuilder: (context, index) {
                                      var address = state.getAllAddressModel?.data?[index];
                                      return Container(
                                          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              new BoxShadow(
                                                color: Colors.grey.shade300,
                                                offset: Offset(0, 1),
                                                blurRadius: 8.0,
                                              ),
                                            ],
                                            color: AppStyles.white,
                                            border: Border.all(color: Color(0x265D6268)),
                                            borderRadius: BorderRadius.circular(9),
                                          ),
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  address?.house ?? '',
                                                  style: AppStyles.black_17_w600.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF0E1728),
                                                  ),
                                                ),
                                                SizedBox(height: 5.h),
                                                Text(
                                                  '${address?.landmark}, ${address?.area}, ${address?.city}, ${address?.pinCode}.',
                                                  style: AppStyles.black_14_w500.copyWith(),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 11.h, bottom: 5.h),
                                                  child: Divider(),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        address?.isDefaultAddress == true
                                                            ? AlertUtils.showToast('Address already set as default')
                                                            : setDefaultAddressSubmitButton(address?.sId ?? '');
                                                      },
                                                      child: Container(
                                                          width: 150.w,
                                                          height: 35.h,
                                                          decoration: BoxDecoration(
                                                              color: state.getAllAddressModel?.data?[index].isDefaultAddress != true
                                                                  ? Colors.white
                                                                  : AppStyles.primary,
                                                              border: Border.all(color: AppStyles.primary),
                                                              borderRadius: BorderRadius.circular(5)),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                state.getAllAddressModel?.data?[index].isDefaultAddress != true
                                                                    ? 'Set as Default'
                                                                    : 'Selected',
                                                                style: state.getAllAddressModel?.data?[index].isDefaultAddress != true
                                                                    ? AppStyles.black_17_w600
                                                                        .copyWith(fontWeight: FontWeight.w500, color: AppStyles.primary)
                                                                    : AppStyles.black_17_w600
                                                                        .copyWith(fontWeight: FontWeight.w500, color: Colors.white),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          onTap: () async {
                                                            logger.w("THIS IS ID ==> ${address?.sId}");
                                                            logger.w("THIS IS HOUSE ==> ${address?.house}");
                                                            logger.w("THIS IS LANDMARK ==> ${address?.landmark}");
                                                            logger.w("THIS IS AREA ==> ${address?.area}");
                                                            logger.w("THIS IS PINCODE ==> ${address?.pinCode}");
                                                            var result = await  Navigator.pushNamed(context, AppScreens.addAddressesScreen, arguments: {
                                                              'id': address?.sId ?? '',
                                                              'house': address?.house ?? '',
                                                              'landmark': address?.landmark ?? '',
                                                              'area': address?.area ?? '',
                                                              'city': address?.city ?? '',
                                                              'pinCode': address?.pinCode ?? '',
                                                            });
                                                            if (result == true) {
                                                              BlocProvider.of<GetAddressScreenBloc>(context).add(
                                                                PerformGetAddressScreenEvent(),
                                                              );
                                                            }
                                                          },
                                                          child: Container(
                                                            width: 62.w,
                                                            height: 32.h,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  color: Colors.grey,
                                                                ),
                                                                borderRadius: BorderRadius.circular(5)),
                                                            child: Center(
                                                              child: Text(
                                                                'Edit',
                                                                style: AppStyles.black_17_w600
                                                                    .copyWith(fontWeight: FontWeight.w500, color: Color(0xFF0E1728)),
                                                                textAlign: TextAlign.start,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 10.w),
                                                        Container(
                                                          height: 32.h,
                                                          width: 32.w,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                color: Colors.grey,
                                                              ),
                                                              borderRadius: BorderRadius.circular(5)),
                                                          child: InkWell(
                                                              onTap: () {
                                                                address?.isDefaultAddress == true
                                                                    ? //   AlertUtils
                                                                    AlertUtils.showToast("You cannot delete default address")
                                                                    : _showConfirmationDialog(state.getAllAddressModel?.data?[index].sId ?? '');
                                                              },
                                                              child: Icon(
                                                                Icons.delete,
                                                                color: Colors.red,
                                                              )),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8.h,
                                                )
                                              ]));
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(height: 10.h);
                                    },
                                    itemCount: state.getAllAddressModel?.data?.length ?? 0,
                                  ),
                            Visibility(visible: state.isLoading || defaultState.isLoading || deleteState.isLoading, child: LoaderWidget()),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  _showConfirmationDialog(dynamic id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            'Confirm remove?',
            style: AppStyles.black_17_w600.copyWith(fontSize: 20.sp),
          ),
          content: Text(
            'Are you sure you want to remove this address?',
            style: AppStyles.black_17_w600.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: AppStyles.black_14_w500.copyWith(fontWeight: FontWeight.w600, color: AppStyles.primary),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await removeAddressSubmitButton(id);
              },
              child: Text(
                'Remove',
                style: AppStyles.black_14_w500.copyWith(fontWeight: FontWeight.w600, color: AppStyles.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> removeAddressSubmitButton(dynamic id) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<DeleteAddressBloc>(context).add(
        PerformDeleteAddressEvent(id: id),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> setDefaultAddressSubmitButton(dynamic id) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<SetDefaultAddressBloc>(context).add(
        PerformSetDefaultAddressEvent(id: id),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }
}
