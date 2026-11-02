import 'package:Digibells/screens/AddMember/add_qr_member/bloc/add_qr_member_bloc.dart';
import 'package:Digibells/screens/AddMember/add_qr_member/bloc/add_qr_member_event.dart';
import 'package:Digibells/screens/AddMember/get_all_members/bloc/get_all_members_event.dart';
import 'package:Digibells/screens/AddMember/get_qr_member/bloc/get_qr_member_event.dart';
import 'package:Digibells/screens/AddMember/remove_member/bloc/remove_member_bloc.dart';
import 'package:Digibells/screens/AddMember/remove_member/bloc/remove_member_event.dart';
import 'package:Digibells/screens/AddMember/remove_member/bloc/remove_member_state.dart';
import 'package:Digibells/screens/AddMember/remove_qr_member/bloc/remove_qr_member_bloc.dart';
import 'package:Digibells/screens/AddMember/remove_qr_member/bloc/remove_qr_member_event.dart';
import 'package:Digibells/screens/AddMember/remove_qr_member/bloc/remove_qr_member_state.dart';
import 'package:Digibells/widgets/loader_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../api_client/api_constans.dart';
import '../../app_screens/app_screens.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_styles.dart';
import '../../utils/app_utils.dart';
import '../../utils/capitalize_first_letter.dart';
import 'add_qr_member/bloc/add_qr_member_state.dart';
import 'get_all_members/bloc/get_all_members_bloc.dart';
import 'get_all_members/bloc/get_all_members_state.dart';
import 'get_qr_member/bloc/get_qr_member_bloc.dart';
import 'get_qr_member/bloc/get_qr_member_state.dart';

class AddMemberScreen extends StatefulWidget {
  bool isHotel;
  String qrId;

  AddMemberScreen({super.key, required this.isHotel, required this.qrId});

  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetAllMembersBloc>(create: (_) => GetAllMembersBloc()),
        BlocProvider<AddQRMemberBloc>(create: (_) => AddQRMemberBloc()),
        BlocProvider<RemoveQRMemberBloc>(create: (_) => RemoveQRMemberBloc()),
        BlocProvider<GetQRMemberBloc>(create: (_) => GetQRMemberBloc()),
        BlocProvider<RemoveMemberBloc>(create: (_) => RemoveMemberBloc()),
      ],
      child: AddMemberScreen(isHotel: false,qrId: '',),
    );
  }

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {


  @override
  void initState() {
    BlocProvider.of<GetAllMembersBloc>(context).add(
      PerformGetAllMembersEvent(),
    );
    BlocProvider.of<GetQRMemberBloc>(context).add(
      PerformGetQRMemberEvent(id: widget.qrId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primary,
      body: BlocConsumer<GetAllMembersBloc, GetAllMembersState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocConsumer<RemoveMemberBloc, RemoveMemberState>(
            listener: (context, removeState) {
              if (removeState.isCompleted) {
                AlertUtils.showToast('Member removed successfully');
                BlocProvider.of<GetAllMembersBloc>(context).add(
                  PerformGetAllMembersEvent(),
                );
              }
            },
            builder: (context, removeState) {
              return BlocConsumer<GetQRMemberBloc, GetQRMemberState>(
                listener: (context, getQRState) {
                  if (getQRState.isCompleted) {}
                },
                builder: (context, getQRState) {
                  return BlocConsumer<AddQRMemberBloc, AddQRMemberState>(
                    listener: (context, addQRState) {
                      if (addQRState.isCompleted) {
                        AlertUtils.showToast('Member added successfully.');
                        BlocProvider.of<GetQRMemberBloc>(context).add(
                          PerformGetQRMemberEvent(  id: widget.qrId),
                        );
                      }else if(addQRState.isFailed){
                        print("THIS IS 1${addQRState.errorMsg}");

                        AlertUtils.showToast(addQRState.errorMsg ?? '');
                      }
                    },
                    builder: (context, addQRState) {
                      return BlocConsumer<RemoveQRMemberBloc, RemoveQRMemberState>(
                        listener: (context, removeQRState) {
                          if(removeQRState.isCompleted){
                            AlertUtils.showToast('QR code removed successfully.');
                            BlocProvider.of<GetQRMemberBloc>(context).add(
                              PerformGetQRMemberEvent(  id: widget.qrId),
                            );
                          }
                        },
                        builder: (context, removeQRState) {
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
                                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            Align(
                                              alignment: Alignment.center,
                                              child: SizedBox(
                                                width: 180.w,
                                                child: Text(
                                                  "Add Member",
                                                  textAlign: TextAlign.center,
                                                  style: AppStyles.white_24_w400.copyWith(fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  AppScreens.newAddMemberScreen,
                                                );
                                              },
                                              icon: Icon(
                                                Icons.add,
                                                color: AppStyles.white,
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
                                  child: state.isLoading || removeState.isLoading
                                      ? LoaderWidget()
                                      : state.getAllMembersModel?.data?.length == 0
                                      ? Center(
                                      child: Text(
                                        "No member added.",
                                        style: TextStyle(fontSize: 15),
                                      ))
                                      : SingleChildScrollView(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: state.getAllMembersModel?.data?.length ?? 0,
                                        //state.getAllMembersModel?.data?.length ?? 0,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (BuildContext context, int index) {
                                          List<String> selectedID = getQRState.getQRMemberModel?.data ?? [];

                                         String ids = state.getAllMembersModel?.data?[index].memberDetails?.sId ?? '';

                                          bool isAdded = ids.isNotEmpty && selectedID.contains(ids);
                                          return Dismissible(
                                            key: Key(state.getAllMembersModel?.data?[index].sId ?? ''),
                                            direction: DismissDirection.endToStart,
                                            onDismissed: (direction) {
                                               removeMember(state.getAllMembersModel?.data?[index].sId ?? '');
                                            },
                                            background: Container(
                                              color: Colors.red,
                                              alignment: Alignment.centerRight,
                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                              child: Icon(Icons.delete, color: Colors.white),
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(11),
                                                      border: Border.all(color: AppStyles.textFieldBorderColor),
                                                    ),
                                                    child: ListTile(
                                                      leading: state.getAllMembersModel?.data?[index].memberDetails?.userImage != null &&
                                                          state.getAllMembersModel?.data?[index].memberDetails?.userImage != ""
                                                          ? ClipRRect(
                                                        borderRadius: BorderRadius.circular(28.w),
                                                        child: CachedNetworkImage(
                                                          height: 56.h,
                                                          width: 56.w,
                                                          fit: BoxFit.cover,
                                                          progressIndicatorBuilder: (context, url, progress) =>
                                                              Center(
                                                                child: CircularProgressIndicator(
                                                                  value: progress.progress,
                                                                  color: AppStyles.white,
                                                                ),
                                                              ),
                                                          imageUrl:
                                                          '${APIConstants.imageUrl}${state.getAllMembersModel?.data?[index].memberDetails?.userImage}',
                                                        ),
                                                      )
                                                          : CircleAvatar(
                                                        radius: 26.w,
                                                        backgroundColor: AppStyles.audio_call,
                                                        child: Center(
                                                          child: Text(
                                                            capitalizeFirstLetter(state.getAllMembersModel?.data?[index].memberDetails?.name ?? ''),
                                                            style: TextStyle(
                                                                color: AppStyles.audio_call_text, fontWeight: FontWeight.w500, fontSize: 20.w),
                                                          ),
                                                        ),
                                                      ),
                                                      trailing: InkWell(
                                                          onTap: () {
                                                            if (ids != null || ids != '') {

                                                                          setState(() {
                                                                            if (isAdded) {
                                                                              // selectedID.remove(ids);
                                                                              removeQRMember(ids);

                                                                            } else {
                                                                              if (widget.isHotel == true) {
                                                                                showModalBottomSheet(
                                                                                  context: context,
                                                                                  builder: ((builder) => hotelBottomSheet(context, ids)),
                                                                                );

                                                                              }

                                                                            else  {
                                                                              addQRMember(ids);
                                                                            }

                                                                            }
                                                                          });

                                                                      }else{
                                                              AlertUtils.showToast('ID null');
                                                            }
                                                                      //isAdded == true ?
                                                            // removeMember(state.getAllMembersModel?.data?[index].sId);
                                                          },
                                                          child: Container(
                                                            width: 34.w,
                                                            height: 38.h,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  color: isAdded == false ? Colors.green : Colors.red,
                                                                ),
                                                                borderRadius: BorderRadius.circular(5)),
                                                            child: Padding(
                                                              padding: EdgeInsets.all(2),
                                                              child: Center(
                                                                child: Icon(
                                                                  isAdded == false ? Icons.add : Icons.delete_outline_rounded,
                                                                  size: 24,
                                                                  color: isAdded == false ? Colors.green : Colors.red,
                                                                ),
                                                              ),
                                                            ),
                                                          )),
                                                      title: Text(
                                                        state.getAllMembersModel?.data?[index].memberDetails?.name ?? '',
                                                        style: AppStyles.black_17_w600,
                                                      ),
                                                      subtitle: Text(
                                                        state.getAllMembersModel?.data?[index].memberDetails?.email ?? '',
                                                        style: TextStyle(color: AppStyles.hintText),
                                                      ),
                                                      contentPadding: EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15.h,
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                  // color: AppStyles.white,
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget hotelBottomSheet(BuildContext context, dynamic id) {
    return Container(
      height: MediaQuery.of(context).size.height / 6,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 90,
        vertical: 30,
      ),
      child: Column(
        children: [
          SizedBox(
            width: 400.w,
            child: ElevatedButton(
              onPressed: ()async {
                addQRMemberForHotel(id,"F");
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: Text("For Food", style: AppStyles.white_16_w700.copyWith(fontSize: 13.sp)),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            width: 400.w,
            child: ElevatedButton(
              onPressed: ()async {
                addQRMemberForHotel(id,"R");
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: Text("As Receptionist", style: AppStyles.white_16_w700.copyWith(fontSize: 13.sp)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> removeMember(dynamic id) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<RemoveMemberBloc>(context).add(
        PerformRemoveMemberEvent(id: id),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> removeQRMember(dynamic id) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
     var data = {
       "memberId": id,
     };
      BlocProvider.of<RemoveQRMemberBloc>(context).add(
        PerformRemoveQRMemberEvent(id: widget.qrId, data:  data),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> addQRMember(dynamic id) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      var data = {
        "members": id,
      };
      BlocProvider.of<AddQRMemberBloc>(context).add(
        PerformAddQRMemberEvent(id:widget.qrId, data:data ),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> addQRMemberForHotel(dynamic id, String hotelType) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      var data = {
        "hotelMembers": {
          "type": hotelType,
          "member": id.toString(),
        }
      };
      BlocProvider.of<AddQRMemberBloc>(context).add(
        PerformAddQRMemberEvent(id: widget.qrId, data:data ),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

}
