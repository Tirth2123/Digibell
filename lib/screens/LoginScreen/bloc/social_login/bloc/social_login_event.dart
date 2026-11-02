part of 'social_login_bloc.dart';

@immutable
abstract class SocialLoginEvent {
  const SocialLoginEvent();
}

class PerformSocialLoginEvent extends SocialLoginEvent {
  final dynamic data;

  PerformSocialLoginEvent({required this.data});
}
