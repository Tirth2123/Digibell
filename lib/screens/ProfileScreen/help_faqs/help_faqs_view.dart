import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/app_styles.dart';
import '../../../../widgets/loader_widget.dart';
import 'bloc/help_faqs_bloc.dart';
import 'bloc/help_faqs_event.dart';
import 'bloc/help_faqs_state.dart';

class HelpAndFaqScreen extends StatefulWidget {
  const HelpAndFaqScreen({Key? key}) : super(key: key);

  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HelpFaqsBloc>(
          create: (_) => HelpFaqsBloc(),
        ),
      ],
      child: const HelpAndFaqScreen(),
    );
  }

  @override
  State<HelpAndFaqScreen> createState() => _HelpAndFaqScreenState();
}

class _HelpAndFaqScreenState extends State<HelpAndFaqScreen> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HelpFaqsBloc>(context).add(
      PerformHelpFaqsEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Help & FAQs',
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<HelpFaqsBloc, HelpFaqsState>(
        listener: (context, state) {
          if (state.isCompleted) {}
        },
        builder: (context, state) {
          return Stack(
            children: [
              ListView.builder(
                itemCount: state.helpFaqsModel?.data?.length ?? 0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: CustomExpansionPanelContainer(
                      question: state.helpFaqsModel?.data?[index].question ?? '',
                      answer: state.helpFaqsModel?.data?[index].answer ?? '',
                      isExpanded: state.helpFaqsModel?.data?[index].isExpanded ?? false,
                    ),
                  );
                },
              ),
              Visibility(
                child: LoaderWidget(),
                visible: state.isLoading,
              )
            ],
          );
        },
      ),
    );
  }
}

class CustomExpansionPanelContainer extends StatefulWidget {
  final String question;
  final String answer;
  late final bool isExpanded;

  CustomExpansionPanelContainer({
    super.key,
    required this.question,
    required this.answer,
    required this.isExpanded,
  });

  @override
  _CustomExpansionPanelContainerState createState() => _CustomExpansionPanelContainerState();
}

class _CustomExpansionPanelContainerState extends State<CustomExpansionPanelContainer> {
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Adjust the width as needed
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppStyles.boderColor),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.question,
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    ),
                  ],
                ),
              ),
            ),
            if (_isExpanded)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  widget.answer,
                  style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
