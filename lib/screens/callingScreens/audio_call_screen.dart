import 'dart:async';
import 'package:Digibells/utils/logger.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/subjects.dart';
import '../../api_client/api_constans.dart';
import '../../app_screens/app_screens.dart';
import '../../soketIO/bloc/socket_connect_bloc.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_styles.dart';
import '../../utils/app_utils.dart';
import '../../utils/stream_builder.dart';
import '../../utils/capitalize_first_letter.dart';

class AudioCallScreen extends StatefulWidget {
  final String callerName;
  final String callId;
  final String receiverId;
  final String callerId;
  final String token;
  final String channelName;
  final int userCount;
  final List<dynamic> members;
  AudioCallScreen(
      {super.key, required this.members,required this.userCount, required this.callId,required this.receiverId, required this.callerId, required this.callerName, required this.channelName, required this.token});

  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SocketConnectBloc>(create: (_) => SocketConnectBloc()),
      ],
      child: AudioCallScreen(
        userCount: 0,
        callId: '',
        receiverId: '',
        callerId: '',
        callerName: '',
        channelName: '',
        token: '',
        members: [],
      ),
    );
  }

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  RtcEngine? _engine;
  int? _remoteUid;
  Timer? _timer;
  BehaviorSubject<int> timing = BehaviorSubject<int>.seeded(0);
  bool _muted = false;
  bool _speaker = false;

  String token = '';
  String channelName = '';

  @override
  void initState() {
    super.initState();
    socketConnect();
    token = widget.token;
    channelName = widget.channelName;
    if (token != '' && channelName != '') {
      initAgora();
      startTimer();
    }
  }

  Future<void> socketConnect() async {
    logger.w("Socket value 2==> ${StreamUtil.socket.hasValue}");
    var internet = await AppUtils.checkInternet();
    if (internet) {
      if (StreamUtil.socket.hasValue && StreamUtil.socket.value.connected == false) {
        BlocProvider.of<SocketConnectBloc>(context).add(PerformSocketConnectEvent());
      } else if (!StreamUtil.socket.hasValue) {
        BlocProvider.of<SocketConnectBloc>(context).add(PerformSocketConnectEvent());
      }
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> initAgora() async {
    await Permission.microphone.request();
    await Permission.bluetooth.request();

    if (await Permission.microphone.isGranted) {
      try {
        // Create and initialize the Agora engine
        _engine = createAgoraRtcEngine();

        await _engine?.initialize(RtcEngineContext(
          appId: APIConstants.APP_ID,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ));

        _engine?.registerEventHandler(
          RtcEngineEventHandler(
            onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
              setState(() {});
            },
            onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
              setState(() {
                _remoteUid = remoteUid;
              });
              _engine?.setEnableSpeakerphone(false);
            },
            onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppScreens.firstTimeHomeScreen,
                    (Route<dynamic> route) => false,
              );
              StreamUtil.bottomNavigationIndex.add(0);
              setState(() {
                _remoteUid = null;
              });
            },
            onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
              logger.e('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
            },

          ),
        );

        // Set the client role and join the channel
        await _engine?.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

        await _engine?.joinChannel(
          token: token,
          channelId: channelName,
          uid: 0,
          options:   ChannelMediaOptions(

          ),
        );
      } on AgoraRtcException catch (e) {
        logger.e("Agora RTC Exception: ${e.code}, ${e.message}");
      } catch (e) {
        logger.e("Unexpected error during Agora initialization: $e");
      }
    } else {
      debugPrint("Microphone permission not granted");
    }
  }

  void startTimer() {
    _timer = Timer.periodic(
      Duration(seconds: 1),
          (Timer timer) {
        timing.add(timing.value + 1);
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    timing.close();

    try {
      if (_engine != null) {
        _engine?.stopEchoTest();
        _engine?.leaveChannel();
        _engine?.release();
      }
    } catch (e) {
      logger.e("Error during Agora engine disposal Audio Call: $e");
    }

    super.dispose();
  }

  void toggleMute() async {
    setState(() {
      _muted = !_muted;
    });
    await _engine?.muteLocalAudioStream(_muted);
  }

  void toggleSpeaker() async {
    setState(() {
      _speaker = !_speaker;
    });
    await _engine?.setEnableSpeakerphone(_speaker);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade700,
        body: BlocConsumer<SocketConnectBloc, SocketConnectState>(
          listener: (context, state) {
            if (state.onActionButtonCompleted || state.actionButtonCompleted) {
              logger.w("Action Completed, Type: ${state.actionType}");
              if (state.actionType == 'reject') {
                logger.w("Call Rejected - Navigating to Home Screen");
                Navigator.pushNamedAndRemoveUntil(context, AppScreens.firstTimeHomeScreen, (Route<dynamic> route) => false);
                StreamUtil.bottomNavigationIndex.add(0);
              }
            }
          },
          builder: (context, state) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Stack(
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).size.height / 9.h,
                      left: 0.0,
                      right: 0.0,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                widget.callerName != "" ? '${widget.callerName}' : "Unknown",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.black, fontSize: 30.h, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            StreamBuilder<int>(stream: timing, builder: (context, snapshot) {
                              if(formatTime(timing.value) == '00:10:00' ){
                                actionClick('reject');
                              }
                              return Text(
                                formatTime(timing.value),
                                textAlign: TextAlign.center,
                                style: AppStyles.fontStyleW600Bold.copyWith(fontSize: 16.sp, color: AppStyles.black, fontWeight: FontWeight.w500),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 3.5.h,
                  left: 0.0,
                  right: 0.0,
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
                  bottom: 15.0,
                  left: 0.0,
                  right: 0.0,
                  child: Column(
                    children: [
                      Container(
                        height: 70.h,
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 25.w, right: 25.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            customWhiteBgWithIcon(
                              onTap: toggleSpeaker,
                              imageAsset: _speaker ? CupertinoIcons.speaker_slash_fill : CupertinoIcons.speaker_fill,
                              bgColor: AppStyles.whiteColor.withOpacity(0.2),
                            ),
                            customWhiteBgWithIcon(
                              onTap: toggleMute,
                              imageAsset: _muted ? CupertinoIcons.mic_slash_fill : CupertinoIcons.mic_solid,
                              bgColor: AppStyles.whiteColor.withOpacity(0.2),
                            ),
                            customWhiteBgWithIcon(
                              onTap: () {
                                actionClick('reject');
                              },
                              imageAsset: CupertinoIcons.phone_down_fill,
                              bgColor: AppStyles.redColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget customWhiteBgWithIcon({required VoidCallback onTap, required IconData imageAsset, required Color bgColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60.h,
        height: 60.h,
        decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
        child: Center(
          child: Icon(
            imageAsset,
            size: 25.h,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void actionClick(String actionType) async {
    var internet = await AppUtils.checkInternet();
    if (internet) {
      BlocProvider.of<SocketConnectBloc>(context).add(PerformCallAction(
        callId: widget.callId,
        userCount: widget.userCount,
        actionType: actionType,
        type: 'audioCall',
        members: widget.members,
        channelName: widget.channelName,
        receiverId: widget.receiverId,
        token: widget.token,
        callerName: widget.callerName,
        callerId: widget.callerId,
      ));
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = secs.toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }
}

