import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/app_styles.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});
  static Widget create() {
    return MultiBlocProvider(
      providers: [
        //  BlocProvider<SubscriptionDetailsBloc>(create: (_) => SubscriptionDetailsBloc()),
      ],
      child: SettingScreen(),
    );
  }

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.white,
    );
  }
}
