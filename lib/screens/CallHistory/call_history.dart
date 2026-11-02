import 'package:Digibells/screens/CallHistory/call_history/bloc/call_history_bloc.dart';
import 'package:Digibells/screens/CallHistory/call_history/bloc/call_history_event.dart';
import 'package:Digibells/utils/logger.dart';
import 'package:Digibells/widgets/loader_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../utils/app_styles.dart';
import '../../utils/capitalize_first_letter.dart';
import '../../utils/time_formatter.dart';
import 'call_history/bloc/call_history_state.dart';

class CallHistoryScreen extends StatefulWidget {
  const CallHistoryScreen({super.key});

  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CallHistoryBloc>(create: (_) => CallHistoryBloc()),
      ],
      child: CallHistoryScreen(),
    );
  }

  @override
  State<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends State<CallHistoryScreen> {
  @override
  void initState() {
    BlocProvider.of<CallHistoryBloc>(context).add(
      PerformCallHistoryEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primary,
      body: BlocConsumer<CallHistoryBloc, CallHistoryState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 140.h,
                  color: AppStyles.primary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: AppStyles.white,
                              ),
                            ),
                            SizedBox(
                              width: 50.w,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 180.w,
                                child: Text(
                                  "Call History",
                                  textAlign: TextAlign.center,
                                  style: AppStyles.white_24_w400.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 705.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 40.h, left: 25.w, right: 25.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Recently",
                          style: AppStyles.black_17_w600.copyWith(fontSize: 18.sp),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Expanded(
                          child: state.callHistoryModel?.data?.length == 0
                              ? Center(
                                  child: Text(
                                  "Call History Empty!",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ))
                              : Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(11),
                                    ),
                                    color: AppStyles.white,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: AppStyles.bordercolor,
                                      ),
                                    ],
                                  ),
                                  child: state.isLoading
                                      ? LoaderWidget()
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: state.callHistoryModel?.data?.length ?? 0,
                                          itemBuilder: (context, index) {
                                            //dynamic item = state.callHistoryModel?.data?[index] ?? 0 ;

                                            return Dismissible(
                                              key: Key(state.callHistoryModel?.data?[index].callerName ?? '' + index.toString()),
                                              direction: DismissDirection.endToStart,
                                              onDismissed: (direction) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text("${state.callHistoryModel?.data?[index].callerName} dismissed"),
                                                  ),
                                                );
                                              },
                                              background: Container(
                                                color: AppStyles.red,
                                                alignment: Alignment.centerRight,
                                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                child: Text(
                                                  'Delete',
                                                  style: AppStyles.white_15_w500.copyWith(fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    leading: CircleAvatar(
                                                      radius: 25,
                                                      backgroundColor: AppStyles.circle,
                                                      child: Text(
                                                        capitalizeFirstLetter(state.callHistoryModel?.data?[index].callerName ?? ''),
                                                        style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w500, fontSize: 18.sp),
                                                      ),
                                                    ),
                                                    title: Text(
                                                      state.callHistoryModel?.data?[index].callerName == ''
                                                          ? 'Unknown'
                                                          : state.callHistoryModel?.data?[index].callerName ?? '',
                                                      style: AppStyles.black_17_w600.copyWith(color: AppStyles.blue, fontSize: 16.sp),
                                                    ),
                                                    subtitle: Row(
                                                      children: [
                                                        Icon(
                                                          state.callHistoryModel?.data?[index].callAction == "A"
                                                              ? Icons.call_outlined
                                                              : Icons.call_outlined,
                                                          color: state.callHistoryModel?.data?[index].callAction == "A"
                                                              ? AppStyles.green
                                                              : AppStyles.normalText,
                                                          size: 16.sp,
                                                        ),
                                                        SizedBox(width: 5.w),
                                                        Text(
                                                          state.callHistoryModel?.data?[index].callAction == "A" ? 'Received' : 'Incoming' ?? '',
                                                          style: TextStyle(
                                                            fontFamily: 'Montserrat',
                                                            color: state.callHistoryModel?.data?[index].callAction == "A"
                                                                ? AppStyles.green
                                                                : AppStyles.normalText,
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          DateFormat('dd/MM/yyyy')
                                                              .format(DateTime.parse(state.callHistoryModel?.data?[index].createdAt ?? '')),
                                                          style: AppStyles.greyColor_12_w500
                                                              .copyWith(color: AppStyles.normalText, fontWeight: FontWeight.normal),
                                                        ),
                                                        SizedBox(
                                                          height: 4.h,
                                                        ),
                                                        Text(
                                                          formatTime(state.callHistoryModel?.data?[index].createdAt ?? ''),
                                                          style: AppStyles.greyColor_12_w500
                                                              .copyWith(color: AppStyles.normalText, fontWeight: FontWeight.normal),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                    child: Divider(
                                                      color: AppStyles.textFieldBorderColor,
                                                      thickness: 1.w,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
