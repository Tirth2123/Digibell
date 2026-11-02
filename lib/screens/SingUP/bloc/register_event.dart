part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {
  const RegisterEvent();
}

class PerformRegisterEvent extends RegisterEvent {
  final dynamic data;

  PerformRegisterEvent({required this.data});
}
