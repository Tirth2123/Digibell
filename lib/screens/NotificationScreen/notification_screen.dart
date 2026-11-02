import 'package:Digibells/screens/NotificationScreen/accept_invite/bloc/accept_invite_bloc.dart';
import 'package:Digibells/screens/NotificationScreen/accept_invite/bloc/accept_invite_event.dart';
import 'package:Digibells/screens/NotificationScreen/decline_invite/bloc/decline_invite_bloc.dart';
import 'package:Digibells/screens/NotificationScreen/decline_invite/bloc/decline_invite_event.dart';
import 'package:Digibells/screens/NotificationScreen/get_notification/bloc/get_notification_bloc.dart';
import 'package:Digibells/screens/NotificationScreen/get_notification/bloc/get_notification_event.dart';
import 'package:Digibells/screens/NotificationScreen/get_notification/bloc/read_notification_bloc.dart';
import 'package:Digibells/utils/alert_utils.dart';
import 'package:Digibells/utils/logger.dart';
import 'package:Digibells/widgets/loader_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_client/api_constans.dart';
import '../../constants/asset_path.dart';
import '../../utils/app_styles.dart';
import '../../utils/app_utils.dart';
import 'accept_invite/bloc/accept_invite_state.dart';
import 'decline_invite/bloc/decline_invite_state.dart';
import 'get_notification/bloc/get_notification_state.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetNotificationsBloc>(create: (_) => GetNotificationsBloc()),
        BlocProvider<AcceptInviteBloc>(create: (_) => AcceptInviteBloc()),
        BlocProvider<DeclineInviteBloc>(create: (_) => DeclineInviteBloc()),
        BlocProvider<ReadNotificationBloc>(create: (_) => ReadNotificationBloc()),
      ],
      child: NotificationScreen(),
    );
  }

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  //bool _showButtons = true;

  BehaviorSubject<int> notificationCount = BehaviorSubject<int>.seeded(0);

  @override
  void initState() {
    BlocProvider.of<GetNotificationsBloc>(context).add(
      PerformGetNotificationsEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.white,
      appBar: AppBar(
        backgroundColor: AppStyles.white,
        elevation: 0.0,
        title: Text(
          "Notification",
          style: AppStyles.black_24_w300,
        ),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black87,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: "Go back",
            );
          },
        ),
        actions: [
          StreamBuilder<int>(
            stream: notificationCount,
            builder: (context, snapshot) {
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(
                        Icons.notifications_none,
                        color: AppStyles.primary,
                      size: 30.0,
                    ),
                    onPressed: () {},
                  ),
                  Positioned(
                    right: 10.0,
                    top: 10.0,
                    child: snapshot.data == 0 ? Container(width: 0.0, height: 0.0,)
                        : Container(
                      width: 15.0,
                      height: 15.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red
                      ),
                      child: Center(
                        child: Text(
                          snapshot.data! > 9 ? '9+': '${snapshot.data}',
                          style: TextStyle(
                            fontSize: 8.0,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
          )
        ],
      ),
      body: BlocConsumer<GetNotificationsBloc, GetNotificationsState>(
        listener: (context, state) {
          if (state.isCompleted) {
            notificationCount.add(state.getNotificationsModel?.notificationCount ?? 0);
            
            if(notificationCount.value != 0){
              BlocProvider.of<ReadNotificationBloc>(context).add(
                PerformReadNotificationEvent()
              );
            }
          }
        },
        builder: (context, state) {
          return BlocConsumer<AcceptInviteBloc, AcceptInviteState>(
            listener: (context, acceptState) {
              if (acceptState.isCompleted) {
                AlertUtils.showToast(acceptState.acceptInviteModel?.message ?? '');
                BlocProvider.of<GetNotificationsBloc>(context).add(
                  PerformGetNotificationsEvent(),
                );
              }
            },
            builder: (context, acceptState) {
              return BlocConsumer<DeclineInviteBloc, DeclineInviteState>(
                listener: (context, declineState) {
                  if (declineState.isCompleted) {
                    AlertUtils.showToast(declineState.declineInviteModel?.message ?? '');
                    BlocProvider.of<GetNotificationsBloc>(context).add(
                      PerformGetNotificationsEvent(),
                    );
                  }
                },
                builder: (context, declineState) {
                  return Container(
                    child: BlocConsumer<ReadNotificationBloc, ReadNotificationState>(
                    listener: (context, state) {
                      if(state.isCompleted){
                        notificationCount.add(0);
                      }
                    },
                    builder: (context, readState) {
                      return Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 25.w, right: 25.w,  bottom: 20.h),
                          child: Column(
                            children: [
                              Expanded( // Ensures ListView takes up available space
                                child: state.getNotificationsModel?.data?.isEmpty ?? true
                                    ? Center(
                                  child: Text(
                                    "No notifications available",
                                    style: TextStyle(fontSize: 15.w),
                                  ),
                                )
                                    : ListView.separated(
                                  itemCount: state.getNotificationsModel?.data?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    logger.w(state.getNotificationsModel?.data?[index].senderDetails?.userImage);
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 10.h, top: 10.h),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              state.getNotificationsModel?.data?[index].senderDetails?.userImage != '' &&
                                                  state.getNotificationsModel?.data?[index].senderDetails?.userImage != null
                                                  ? ClipRRect(
                                                borderRadius: BorderRadius.circular(22.w),
                                                child: CachedNetworkImage(
                                                  height: 44.h,
                                                  width: 44.w,
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder: (context, url, progress) => Center(
                                                    child: CircularProgressIndicator(
                                                      value: progress.progress,
                                                      color: AppStyles.white,
                                                    ),
                                                  ),
                                                  imageUrl:
                                                  '${APIConstants.imageUrl}${state.getNotificationsModel?.data?[index].senderDetails?.userImage}',
                                                ),
                                              )
                                                  : CircleAvatar(
                                                radius: 22,
                                                backgroundImage: AssetImage(ImageAssetPath.memberImage),
                                              ),
                                              SizedBox(width: 18.w),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            state.getNotificationsModel?.data?[index].senderDetails?.name ?? 'Unknown',
                                                            style: AppStyles.black_17_w600.copyWith(
                                                              fontSize: 15.sp,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 12.w),
                                                        Flexible(
                                                          child: Text(
                                                            "${getTimeDifference(state.getNotificationsModel?.data?[index].createdAt ?? '')}",
                                                            overflow: TextOverflow.ellipsis,
                                                            style: AppStyles.hintText_15_w400.copyWith(fontSize: 15.sp, fontWeight: FontWeight.w500),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 6.h),
                                                    Text(
                                                      state.getNotificationsModel?.data?[index].message ?? '',
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: AppStyles.hintText_15_w400.copyWith(fontSize: 15.sp),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.h),
                                          Visibility(
                                            visible: state.getNotificationsModel?.data?[index].memberDetails != null &&
                                                !(state.getNotificationsModel?.data?[index].memberDetails?.isRejectInvitation ?? false) &&
                                                !(state.getNotificationsModel?.data?[index].memberDetails?.isAcceptInvitation ?? false),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                  width: 120.w,
                                                  height: 35.h,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      acceptInvite(state.getNotificationsModel?.data?[index].memberId);
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: AppStyles.primary,
                                                      padding: EdgeInsets.symmetric(vertical: 9.h),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(30),
                                                      ),
                                                    ),
                                                    child: Text('Accept', style: AppStyles.white_16_w700.copyWith(fontSize: 13.sp)),
                                                  ),
                                                ),
                                                SizedBox(width: 16),
                                                SizedBox(
                                                  width: 120.w,
                                                  height: 35.h,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      declineInvite(state.getNotificationsModel?.data?[index].memberId);
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: AppStyles.secondaryPrimaryColor,
                                                      padding: EdgeInsets.symmetric(vertical: 9.h),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(30),
                                                      ),
                                                    ),
                                                    child: Text('Decline',
                                                        style: AppStyles.white_16_w700.copyWith(fontSize: 13.sp, color: AppStyles.primary)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) => Divider(
                                    color: AppStyles.textFieldBorderColor,
                                    thickness: 1.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          child: LoaderWidget(),
                          visible: state.isLoading || acceptState.isLoading || declineState.isLoading,
                        ),
                      ],
                    );
  },
),
                  );

                },
              );
            },
          );
        },
      ),
    );
  }

  String getTimeDifference(String createdAt) {
    DateTime createdTime = DateTime.parse(createdAt);
    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(createdTime);

    if (difference.inDays > 0) {
      return "${difference.inDays} days ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hours ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minutes ago";
    } else {
      return "Just now";
    }
  }

  Future<void> acceptInvite(dynamic id) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<AcceptInviteBloc>(context).add(
        PerformAcceptInviteEvent(id: id),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> declineInvite(dynamic id) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<DeclineInviteBloc>(context).add(
        PerformDeclineInviteEvent(id: id),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }
}
