import 'dart:async';
import 'dart:io';
import 'package:Digibells/utils/logger.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart'; // Add this import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
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

class VideoCallScreen extends StatefulWidget {
  final String token;
  final String channelName;
  final String callerName;
  final String receiverId;
  final String callerId;
  final String callId;
  final int userCount;
  final List<dynamic> members;

  VideoCallScreen(
      {super.key, required this.token,required this.userCount,required this.callId, required this.members, required this.callerId, required this.channelName, required this.receiverId, required this.callerName});
  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SocketConnectBloc>(create: (_) => SocketConnectBloc()),
      ],
      child: VideoCallScreen(
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
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  TextEditingController messageController = TextEditingController();
  BehaviorSubject<bool> muted = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> localUserJoined = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<int> streamRemoteUid = BehaviorSubject<int>.seeded(-1);
  BehaviorSubject<bool> remoteVideoEnabled = BehaviorSubject<bool>.seeded(true);
  RtcEngine? _engine;
  int? _remoteUid;
  Timer? _timer;
  BehaviorSubject<int> timing = BehaviorSubject<int>.seeded(0);
  bool _muted = false;
  bool _speaker = false;
  bool _video = true;
  Offset position = Offset(0, 0);

  @override
  void initState() {
    super.initState();
    socketConnect();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Size screenSize = MediaQuery.of(context).size;
      final double topRightX = screenSize.width - 100; // 100 is the width of the video widget.
      final double topRightY = kToolbarHeight;
      setState(() {
        position = Offset(topRightX, topRightY);
      });
    });
    initAgora();
    startTimer();
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
    localUserJoined.close();
    remoteVideoEnabled.close();
    streamRemoteUid.close();
    muted.close();
    try {
      if (_engine != null) {
        _engine?.stopEchoTest();
        _engine?.leaveChannel();
        _engine?.release();
      }
    } catch (e) {
      logger.e("Error during Agora engine disposal Video Call: $e");
    }

    super.dispose();
  }

  void safeAdd<T>(BehaviorSubject<T> subject, T event) {
    if (!subject.isClosed) {
      subject.add(event);
    }
  }

  Future<void> _handlePermissions() async {
    final permissionStatus = await [
      Permission.camera,
      Permission.microphone,
    ].request();
    if (permissionStatus[Permission.camera] != PermissionStatus.granted ||
        permissionStatus[Permission.microphone] != PermissionStatus.granted) {
      print("Permissions not granted");
    }
  }

  Future<void> initAgora() async {
    try {
      String? logFilePath;
      if (Platform.isAndroid) {
        final directory = await getExternalStorageDirectory();
        logFilePath = '${directory?.path}/agora-iris.log';
        await _engine?.setLogFile(logFilePath);
      } else if (Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        logFilePath = '${directory.path}/agora-iris.log';
        await _engine?.setLogFile(logFilePath);
      }

      await _handlePermissions();
      _engine = await createAgoraRtcEngine(); // Ensure compatibility with Agora SDK version

      await _engine?.initialize(
        const RtcEngineContext(
          appId: APIConstants.APP_ID, // Replace with your actual Agora APP_ID
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );
      print("Agora Engine Initialized Successfully");

      _engine?.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            print("Joined channel: ${connection.channelId}");
            safeAdd(localUserJoined, true);
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            print("User joined: $remoteUid");
            setState(() {
              _remoteUid = remoteUid;
            });
            safeAdd(streamRemoteUid, remoteUid);
            _engine?.setEnableSpeakerphone(true);
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            print("User Offline: $remoteUid, reason: $reason");
            setState(() {
              _remoteUid = null;
            });
            _engine?.leaveChannel();
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppScreens.firstTimeHomeScreen,
                  (Route<dynamic> route) => false,
            );
            StreamUtil.bottomNavigationIndex.add(0);
            safeAdd(streamRemoteUid, -1);
          },
          onRemoteVideoStateChanged: (RtcConnection connection, int remoteUid, RemoteVideoState state, RemoteVideoStateReason reason, int elapsed) {
            print("Remote video state changed: $state");
            safeAdd(remoteVideoEnabled, state != RemoteVideoState.remoteVideoStateStopped);
          },
          onError: (ErrorCodeType errorCode, String errorMessage) {
            print("Agora Error: $errorCode, $errorMessage");
          },
        ),
      );

      await _engine?.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await _engine?.enableVideo();
      await _engine?.startPreview();
      await _engine?.joinChannel(
        token: widget.token,
        channelId: widget.channelName,
        uid: 0,
        options: const ChannelMediaOptions(),
      );
    } catch (e) {
      print("Error during Agora Initialization: $e");
    }
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
    await _engine?.muteRemoteAudioStream(uid: _remoteUid!, mute: _speaker);
  }

  void toggleVideo() async {
    setState(() {
      _video = !_video;
    });
    await _engine?.enableLocalVideo(_video);
  }

  void onSwitchCamera() {
    _engine?.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocketConnectBloc, SocketConnectState>(
      listener: (context, state) {
        if (state.onActionButtonCompleted || state.actionButtonCompleted) {
          if (state.actionType == 'reject') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppScreens.firstTimeHomeScreen,
                  (Route<dynamic> route) => false,
            );
            StreamUtil.bottomNavigationIndex.add(0);
          }
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: Colors.black,
            body: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Stack(
                children: [
                  StreamBuilder<int>(
                    stream: streamRemoteUid,
                    builder: (context, snapshotStream) {
                      return snapshotStream.data == -1
                          ? Center(child: CircularProgressIndicator()) // Show loading indicator while waiting for remote video
                          : StreamBuilder<bool>(
                          stream: remoteVideoEnabled,
                          builder: (context, snapshot) {
                            return Stack(
                              children: [
                                if (snapshot.data == false)
                                  Container(color: Colors.grey.shade700),
                                _engine != null
                                    ? AgoraVideoView(
                                  controller: VideoViewController.remote(
                                    rtcEngine: _engine!,
                                    canvas: VideoCanvas(uid: snapshotStream.data),
                                    connection: RtcConnection(channelId: widget.channelName),
                                  ),
                                )
                                    : Center(child: CircularProgressIndicator()), // Loader while _engine is initializing
                              ],
                            );
                          });
                    },
                  ),
                  Positioned(
                    left: position.dx,
                    top: position.dy,
                    child: Draggable(
                      feedback: Material(
                        type: MaterialType.transparency,
                        child: Container(
                            width: 100.h,
                            height: 120.h,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network('${APIConstants.imageUrl}${StreamUtil.userPhoto.value}'))),
                      ),
                      childWhenDragging: Container(
                        width: 100.h,
                        height: 120.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(width: 3, color: AppStyles.whiteColor),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: StreamBuilder<bool>(
                              stream: localUserJoined,
                              builder: (context, snapshot) {
                                return snapshot.data == false || _engine == null
                                    ? Center(child: CircularProgressIndicator())
                                    : AgoraVideoView(
                                  controller: VideoViewController(
                                    rtcEngine: _engine!,
                                    canvas: const VideoCanvas(uid: 0),
                                  ),
                                );
                              }),
                        ),
                      ),
                      onDragEnd: (details) {
                        setState(() {
                          position = details.offset;
                        });
                      },
                      child: Container(
                        width: 100.h,
                        height: 120.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(width: 3, color: AppStyles.whiteColor),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: StreamBuilder<bool>(
                              stream: localUserJoined,
                              builder: (context, snapshot) {
                                return _engine == null || snapshot.data == false
                                    ? Center(child: CircularProgressIndicator())
                                    : AgoraVideoView(
                                  controller: VideoViewController(
                                    rtcEngine: _engine!,
                                    canvas: VideoCanvas(uid: 0),
                                  ),
                                );
                              }),
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
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customWhiteBgWithIcon(
                                  onTap: onSwitchCamera,
                                  imageAsset: CupertinoIcons.camera_rotate_fill,
                                  bgColor: AppStyles.whiteColor.withOpacity(0.2)),
                              customWhiteBgWithIcon(
                                  onTap: toggleMute,
                                  imageAsset: _muted ? CupertinoIcons.mic_slash_fill : CupertinoIcons.mic_solid,
                                  bgColor: AppStyles.whiteColor.withOpacity(0.2)),
                              customWhiteBgWithIcon(
                                  onTap: toggleSpeaker,
                                  imageAsset: _speaker ? CupertinoIcons.speaker_slash_fill : CupertinoIcons.speaker_fill,
                                  bgColor: AppStyles.whiteColor.withOpacity(0.2)),
                              customWhiteBgWithIcon(
                                  onTap: toggleVideo,
                                  imageAsset: _video == false ? Icons.videocam_off : Icons.videocam_rounded,
                                  bgColor: AppStyles.whiteColor.withOpacity(0.2)),
                              customWhiteBgWithIcon(
                                  onTap: () {
                                    actionClick('reject');
                                  },
                                  imageAsset: CupertinoIcons.phone_down_fill,
                                  bgColor: AppStyles.redColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
        type: 'videoCall',
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
