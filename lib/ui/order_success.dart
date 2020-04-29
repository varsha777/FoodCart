import 'package:flutter/material.dart';
import 'package:foodcart/ui/dashboard/dashboard_screen.dart';
import 'package:foodcart/ui/order_list.dart';
import 'package:foodcart/utils/screen_utils/flutter_screenutil.dart';
import 'package:foodcart/utils/storage/PreferenceUtils.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class OrderPlacedSuccess extends StatefulWidget {
  String orderNo = "";

  OrderPlacedSuccess(this.orderNo);

  @override
  _OrderPlacedSuccessState createState() => _OrderPlacedSuccessState();
}

class _OrderPlacedSuccessState extends State<OrderPlacedSuccess>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(vsync: this, duration: new Duration(seconds: 1));
    animation = new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    _sendEmail();
  }

  String username = 'Sathyalakshmiaryavysyafoodcorn@gmail.com';
  String password = '123456789@Rajesh';

  void _sendEmail() async {
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Food Cart')
      ..recipients.add('Sathyalakshmiaryavysyafoodcorn@gmail.com')
//      ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      ..bccRecipients.add(Address('reddyrajeshkesarla04@gmail.com'))
      ..subject = 'New Delivery'
      ..text = 'Hi you got a new delivery request \n Order No:-${widget.orderNo}'
      ..html = "<h1>Hi you got a new delivery request</h1>\n<h2>Order No:-${widget.orderNo}</h2>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      _sendEmailToUser();
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      _sendEmailToUser();
    }
  }

  void _sendEmailToUser() async {
    String userName = await PreferenceUtils.getUserName();
    String userEmail = await PreferenceUtils.getUserEmail();

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Food Cart')
      ..recipients.add(userEmail)
//      ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
//      ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Order NO.#${widget.orderNo}'
      ..text =
          "Hi $userName,\n \t Thanks for ordering from FOOD CART your order will be delivered at your door step with in 1hour.\nOrder No:-${widget.orderNo}"
      ..html =
          "<h3>Hi $userName,</h3>\n \t <h4>Thanks for ordering from FOOD CART your order will be delivered at your door step with in 1hour.</h4>"
              "\n<h2>Order No:-${widget.orderNo}</h2>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  @override
  dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 760, allowFontScaling: true);

    return Scaffold(
      appBar: AppBar(
        title: Text("Order Placed"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
            }),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/tick_mark.png',
              width: (animation.value * 250).w,
              height: (animation.value * 250).h,
            ),
            Text(
              "Order No. #${widget.orderNo}",
              style: TextStyle(fontSize: 18.ssp, fontWeight: FontWeight.bold),
            ),
            Text(
              "Placed successfully",
              style: TextStyle(fontSize: 18.ssp, fontWeight: FontWeight.bold),
            ),
            FlatButton.icon(
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (BuildContext context) => OrdersList()));
                },
                icon: Icon(Icons.call_made),
                label: Text(
                  "TRACK ORDER",
                  style: TextStyle(fontSize: 20.ssp, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}
