import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodcart/ui/cart.dart';
import 'package:foodcart/ui/dashboard/breakfast_screen.dart';
import 'package:foodcart/ui/dashboard/dinner_screen.dart';
import 'package:foodcart/ui/dashboard/lunch_screen.dart';
import 'package:foodcart/ui/dashboard/snacks_screen.dart';
import 'package:foodcart/ui/profile_screen.dart';
import 'package:foodcart/utils/messages/MessagesFunctions.dart';
import 'package:foodcart/utils/screen_utils/flutter_screenutil.dart';
import 'package:foodcart/utils/storage/Database.dart';
import 'package:foodcart/utils/storage/PreferenceUtils.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TabController tabController;

  TextStyle label = new TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
  TextStyle unselectedLabel = new TextStyle(color: Colors.white, fontWeight: FontWeight.w300);

  String userProfileImage = "";

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  void _initializeData() async {
    userProfileImage = await PreferenceUtils.getUserImage();
    setState(() {});
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 760, allowFontScaling: true);

    return Scaffold(
      key: _scaffoldKey,
      body: DefaultTabController(
          length: 4,
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return <Widget>[
                SliverAppBar(
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (BuildContext context) => Profile()));
                    },
                    child: CircleAvatar(
                      radius: 15.w,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          width: 35,
                          imageUrl: userProfileImage,
                          fit: BoxFit.fill,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.account_circle, color: Colors.white, size: 20),
                          placeholder: (context, url) {
                            return Icon(
                              Icons.account_circle,
                              color: Colors.white,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.h),
                      child: IconButton(
                          icon: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext context) => CartList()));
                          }),
                    )
                  ],
                  elevation: 5,
                  expandedHeight: 150.h,
                  floating: false,
                  pinned: true,
                  centerTitle: true,
                  title: Image.asset(
                    'images/logo.png',
                    height: 45.h,
                    width: 120.w,
                  ),
                  bottom: TabBar(
                    labelStyle: label,
                    unselectedLabelStyle: unselectedLabel,
                    tabs: <Widget>[
                      Tab(
                        icon: CircleAvatar(
                            child: Image.asset(
                          'images/breakfast.png',
                          height: 100.h,
                        )),
                        text: "Tiffin",
                      ),
                      Tab(
                        icon: CircleAvatar(
                            child: Image.asset(
                          'images/lunch.png',
                          height: 100.h,
                        )),
                        text: "Lunch",
                      ),
                      Tab(
                        icon: CircleAvatar(
                            child: Image.asset(
                          'images/snack.png',
                          height: 100.h,
                        )),
                        text: "Snacks",
                      ),
                      Tab(
                        icon: CircleAvatar(
                            child: Image.asset(
                          'images/dinner.png',
                          height: 100.h,
                        )),
                        text: "Dinner",
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[BreakFast(), Lunch(), Snacks(), Dinner()],
            ),
          )),
    );
  }
}
