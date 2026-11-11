import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import '../../app_screens/app_screens.dart';
import '../../constants/asset_path.dart';
import '../../soketIO/bloc/socket_connect_bloc.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_styles.dart';
import '../../utils/app_utils.dart';
import '../../utils/logger.dart';
import '../../utils/stream_builder.dart';
import '../../utils/capitalize_first_letter.dart';

class RingingScreen extends StatefulWidget {
  final String receiverId;
  final String type;
  final String callerName;
  final String token;
  final String channelName;
  final String callerId;
  final String callId;
  final int userCount;
  final List<dynamic> members;

  RingingScreen({
    super.key,
    required this.callerName,
    required this.userCount,
    required this.callId,
    required this.members,
    required this.callerId,
    required this.type,
    required this.receiverId,
    required this.token,
    required this.channelName,
  });

  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SocketConnectBloc>(create: (_) => SocketConnectBloc()),
      ],
      child: RingingScreen(
        userCount: 0,
        callId: '',
        receiverId: '',
        callerId: '',
        callerName: '',
        channelName: '',
        token: '',
        type: '',
        members: [],
      ),
    );
  }

  @override
  State<RingingScreen> createState() => _RingingScreenState();
}

class _RingingScreenState extends State<RingingScreen> {
  Timer? _timer;
  AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _vibrationTimer;

  @override
  void initState() {
    super.initState();
    socketConnect();
    _startTimer();
    _playAudio();
    startCallVibration();
  }

  Future<void> socketConnect() async {
    logger.w("Socket value 2==> ${StreamUtil.socket.hasValue}");
    var internet = await AppUtils.checkInternet();
    if (internet) {
      if (StreamUtil.socket.hasValue) {
        if (StreamUtil.socket.value.connected == false) {
          BlocProvider.of<SocketConnectBloc>(context).add(PerformSocketConnectEvent());
        }
      } else {
        BlocProvider.of<SocketConnectBloc>(context).add(PerformSocketConnectEvent());
      }
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    stopCallVibration();

    try {
      if (StreamUtil.socket.hasValue && StreamUtil.socket.value.connected) {
        StreamUtil.socket.value.emit("clearmycall", {'channelName': widget.channelName});
      }
    } catch (_) {}

    super.dispose();
  }

  Future<void> startCallVibration() async {
    final canVibrate = await Vibrate.canVibrate;
    if (!canVibrate) return;

    _vibrationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      Vibrate.vibrate();
    });
  }

  void stopCallVibration() async {
    _vibrationTimer?.cancel();
    _vibrationTimer = null;
  }

  Future<void> _playAudio() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('audio/ringtone.mp3'));
  }

  void _startTimer() async {
    _timer = Timer(Duration(seconds: 30), () async {
      await actionClick('noResponse');
      await callReject();
    });
  }

  Future<void> callReject() async {
    await FlutterCallkitIncoming.endCall(widget.callId);
    _audioPlayer.stop();
    stopCallVibration();
    _timer?.cancel();
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppScreens.firstTimeHomeScreen,
          (Route<dynamic> route) => false,
    );
    StreamUtil.bottomNavigationIndex.add(0);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade700,
        body: BlocConsumer<SocketConnectBloc, SocketConnectState>(
          listener: (context, state) async {
            if (state.actionButtonCompleted) {
              if (state.actionType == 'reject') {
                await callReject();
              } else if (state.actionType == 'accept') {
                await callAccepted();
                if (state.type == 'audioCall') {
                  stopCallVibration();
                  _audioPlayer.stop();
                  _timer?.cancel();
                  await Navigator.of(context).pushReplacementNamed(
                    AppScreens.audioCallScreen,
                    arguments: {
                      'members': widget.members,
                      'userCount': widget.userCount,
                      'callId': widget.callId,
                      'token': widget.token,
                      'receiverId': widget.receiverId,
                      'channelName': widget.channelName,
                      'callerId': widget.callerId,
                      'callerName': widget.callerName,
                    },
                  );
                } else if (state.type == 'videoCall') {
                  stopCallVibration();
                  _audioPlayer.stop();
                  _timer?.cancel();
                  await Navigator.of(context).pushReplacementNamed(
                    AppScreens.videoCallScreen,
                    arguments: {
                      'members': widget.members,
                      'userCount': widget.userCount,
                      'callId': widget.callId,
                      'token': widget.token,
                      'receiverId': widget.receiverId,
                      'channelName': widget.channelName,
                      'callerId': widget.callerId,
                      'callerName': widget.callerName,
                    },
                  );
                }
              }
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height / 9.h,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            widget.callerName.isNotEmpty ? widget.callerName : "Unknown",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black, fontSize: 30.h, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "Calling.....",
                          style: TextStyle(color: Colors.black, fontSize: 18.h, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.1),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 3.5.h,
                  left: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 130.w,
                    backgroundColor: AppStyles.audio_call,
                    child: Center(
                      child: Text(
                        capitalizeFirstLetter(widget.callerName),
                        style: TextStyle(color: AppStyles.audio_call_text, fontWeight: FontWeight.w500, fontSize: 100.w),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height / 9.h,
                  left: MediaQuery.of(context).size.height / 14.h,
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        if (mounted) {
                          await actionClick('reject');
                        } else {
                          logger.e("NOT MOUNTED --> reject");
                        }
                      } on Exception catch (e) {
                        logger.e("reject --> $e");
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 35.w,
                              backgroundColor: AppStyles.call_red,
                              child: Center(
                                child: Image.asset(
                                  ImageAssetPath.cut_call,
                                  height: 25.h,
                                  width: 25.w,
                                ),
                              ),
                            ),
                            SizedBox(height: 14.h),
                            Text(
                              "Decline",
                              style: TextStyle(color: AppStyles.black, fontSize: 16.h, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height / 9.h,
                  right: MediaQuery.of(context).size.height / 14.h,
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        stopCallVibration();
                        await actionClick('accept');
                      } on Exception catch (e) {
                        logger.e("accept --> $e");
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 35.w,
                              backgroundColor: AppStyles.call_green,
                              child: Center(
                                child: Image.asset(
                                  ImageAssetPath.call,
                                  height: 33.h,
                                  width: 33.w,
                                ),
                              ),
                            ),
                            SizedBox(height: 14.h),
                            Text(
                              "Accept",
                              style: TextStyle(color: AppStyles.black, fontSize: 16.h, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> actionClick(String actionType) async {
    var internet = await AppUtils.checkInternet();
    if (internet) {
      BlocProvider.of<SocketConnectBloc>(context).add(PerformCallAction(
        members: widget.members,
        userCount: widget.userCount,
        callId: widget.callId,
        actionType: actionType,
        callerName: widget.callerName,
        type: widget.type,
        token: widget.token,
        receiverId: widget.receiverId,
        callerId: widget.callerId,
        channelName: widget.channelName,
      ));
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> callAccepted() async {
    var internet = await AppUtils.checkInternet();
    if (internet) {
      BlocProvider.of<SocketConnectBloc>(context).add(PerformCallAccepted(
        callerName: widget.callerName,
        type: widget.type,
        token: widget.token,
        receiverId: widget.receiverId,
        callerId: widget.callerId,
        channelName: widget.channelName,
        members: widget.members,
      ));
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }
}
