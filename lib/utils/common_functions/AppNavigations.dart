import 'package:url_launcher/url_launcher.dart';

class Launches {
  static void launchPhonePad(String number) async {
    String numberUrl = "tel:" + number;
    if (await canLaunch(numberUrl)) {
      await launch(numberUrl);
    } else {
      throw "could not launch $numberUrl";
    }
  }

  static void launchMessage(String number) async {
    String messageUrl = "sms:" + number;
    if (await canLaunch(messageUrl)) {
      await launch(messageUrl);
    } else {
      throw "could not launch $messageUrl";
    }
  }

  static void launchEmail(String toEmail) async {
    String emailUrl = "mailto:" + toEmail + "?" + "subject=Subject-&body=Hi\n";
    if (await canLaunch(emailUrl)) {
      await launch(emailUrl);
    } else {
      throw "could not launch default email app";
    }
  }
}
