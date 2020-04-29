import 'package:flutter/material.dart';
import 'package:foodcart/utils/screen_utils/flutter_screenutil.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 760, allowFontScaling: true);

    return Scaffold(
      appBar: AppBar(
        title: Text("About us"),
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Card(
              elevation: 2.h,
              margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.w))),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ListTile(
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0.w),
                        child: Image.asset(
                          'images/logo.png',
                          height: 40.h,
                          width: 40.w,
                          fit: BoxFit.scaleDown,
                        )),
                    title: Text(
                      "Food Cart",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18.ssp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[300],
                    height: 1,
                    indent: 50,
                  ),
                  ListTile(
                    leading: Icon(Icons.info_outline, size: 30.h, color: Colors.grey),
                    title: Text(
                      "Version",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "1.0.0",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                    ),
                  )
                ],
              ),
            ),
            Card(
              elevation: 2.h,
              margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.w))),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.call,
                      color: Colors.teal,
                    ),
                    title: Text(
                      "Contact",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "+91 9100458104, +91 8142491534",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[300],
                    height: 1,
                    indent: 50,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.email,
                      color: Colors.teal,
                    ),
                    title: Text("Email",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      "Sathyalakshmiaryavysyafoodcorn@gmail.com,\nreddyrajeshkesarla04@gmail.com",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[300],
                    height: 1,
                    indent: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.h, bottom: 10.h),
                    child: Text(
                      "About",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 20.w),
                    child: Text(
                      "At FoodCart enjoy ordering fresh, tasty and healthy food from the easy of your kitchen to be delivered at you door step max with in 1 hour of ordering.",
                      softWrap: true,
                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
