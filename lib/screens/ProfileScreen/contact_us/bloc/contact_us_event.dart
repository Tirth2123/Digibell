abstract class ContactUsEvent {
  const ContactUsEvent();
}

class PerformContactUsEvent extends ContactUsEvent {
  final dynamic data;

  PerformContactUsEvent({required this.data});
}
