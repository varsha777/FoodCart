import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodcart/ui/about_us.dart';
import 'package:foodcart/ui/order_list.dart';
import 'package:foodcart/utils/common_functions/UtilFunctions.dart';
import 'package:foodcart/utils/screen_utils/flutter_screenutil.dart';
import 'package:foodcart/utils/storage/PreferenceUtils.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userProfileImage = "", userProfileName = "";

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  void _initializeData() async {
    userProfileImage = await PreferenceUtils.getUserImage();
    userProfileName = await PreferenceUtils.getUserName();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 760, allowFontScaling: true);

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              width: double.infinity,
              child: _topView(),
            ),
            SizedBox(
              height: 10.h,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (BuildContext context) => OrdersList()));
              },
              title: Text(
                "Orders",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              leading: CircleAvatar(
                radius: 25.h,
                child: Icon(Icons.list),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey,
              indent: 70,
            ),
            SizedBox(
              height: 10.h,
            ),
            Banner(
              location: BannerLocation.topStart,
              message: "New",
              child: Container(
                child: ListTile(
                  title: Text(
                    "Groceries Delivery",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  leading: CircleAvatar(
                    radius: 25.h,
                    child: Icon(Icons.add_shopping_cart),
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey,
              indent: 70,
            ),
            SizedBox(
              height: 10.h,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (BuildContext context) => AboutUs()));
              },
              title: Text(
                "About Us",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              leading: CircleAvatar(
                radius: 25.h,
                child: Icon(Icons.info_outline),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey,
              indent: 70,
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
                onPressed: () {
                  Utils.doLogout(context);
                },
                child: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).accentColor)
          ],
        ),
      ),
    );
  }

  Widget _topView() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 15.h,
        ),
        CircleAvatar(
          radius: 50.h,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: CachedNetworkImage(
              width: 100.w,
              imageUrl: userProfileImage,
              fit: BoxFit.fill,
              errorWidget: (context, url, error) =>
                  Icon(Icons.account_circle, color: Colors.white, size: 20.h),
              placeholder: (context, url) {
                return Icon(
                  Icons.account_circle,
                  color: Colors.white,
                );
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            userProfileName,
            style: TextStyle(fontSize: 23.ssp, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
