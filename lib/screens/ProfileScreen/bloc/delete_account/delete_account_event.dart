part of 'delete_account_bloc.dart';

//
abstract class DeleteAccountEvent {
  const DeleteAccountEvent();
}

class PerformDeleteAccountEvent extends DeleteAccountEvent {
  PerformDeleteAccountEvent();
}
