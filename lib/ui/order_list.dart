import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodcart/models/OrderModel.dart';
import 'package:foodcart/utils/screen_utils/flutter_screenutil.dart';
import 'package:foodcart/utils/storage/PreferenceUtils.dart';
import 'package:intl/intl.dart';

class OrdersList extends StatefulWidget {
  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool isApiLoading = false;
  List<OrderModel> _ordersList = List();

  @override
  void initState() {
    _loadInitialData();
    super.initState();
  }

  _loadInitialData() async {
    setState(() {
      isApiLoading = true;
    });
    String userId = await PreferenceUtils.getUserId();
    Firestore.instance
        .collection("OrderHistory")
        .where("orderBy", isEqualTo: userId)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      if (snapshot.documents.length > 0) {
        print("-----${snapshot.documents.length}");
        List<DocumentSnapshot> list = snapshot.documents;
        for (int i = 0; i < list.length; i++) {
          DocumentSnapshot document = list[i];
          print(document);
          _ordersList.add(OrderModel.fromJson(document.data));
        }
        _ordersList.sort((a, b) {
          return b.orderNo.compareTo(a.orderNo);
        });
      }

      setState(() {
        isApiLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 760, allowFontScaling: true);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Order History"),
      ),
      body: isApiLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _ordersList.length == 0
              ? Center(
                  child: Text("No Orders available"),
                )
              : ListView.builder(
                  itemCount: _ordersList.length,
                  itemBuilder: (context, index) {
                    return OrdersItemRow(_ordersList[index]);
                  }),
    );
  }
}

class OrdersItemRow extends StatelessWidget {
  OrderModel _orderModel;

  OrdersItemRow(this._orderModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      margin: EdgeInsets.only(left: 10.w, top: 10.h, right: 10.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  "Order No. ${_orderModel.orderNo}",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal, fontSize: 20.ssp),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "\u20B9 ${_orderModel.totalPrice}",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.ssp),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List<Widget>.generate(_orderModel.orderItemsList.length, (int index) {
              if (index == _orderModel.orderItemsList.length - 1) {
                return Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: Text(
                      "${_orderModel.orderItemsList[index].itemName}(${_orderModel.orderItemsList[index].quantity}) -> \u20B9${_orderModel.orderItemsList[index].itemTotal}.",
                      textAlign: TextAlign.start),
                );
              } else {
                return Text(
                    "${_orderModel.orderItemsList[index].itemName}(${_orderModel.orderItemsList[index].quantity}) -> \u20B9${_orderModel.orderItemsList[index].itemTotal}, ",
                    textAlign: TextAlign.start);
              }
            }),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Text(
                  getTimeData(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.ssp),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Status: ${_orderModel.status}",
                  textAlign: TextAlign.end,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.ssp),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  String getTimeData() {
    var date = new DateTime.fromMillisecondsSinceEpoch(int.parse(_orderModel.orderId) * 1000);
    var format = new DateFormat('EEE, d MMM hh:mm aaa');
    return format.format(date);
  }
}
