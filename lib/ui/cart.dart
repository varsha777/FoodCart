import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodcart/models/MenuModel.dart';
import 'package:foodcart/models/OrderModel.dart';
import 'package:foodcart/ui/order_list.dart';
import 'package:foodcart/ui/order_success.dart';
import 'package:foodcart/utils/messages/MessagesFunctions.dart';
import 'package:foodcart/utils/screen_utils/flutter_screenutil.dart';
import 'package:foodcart/utils/storage/Database.dart';
import 'package:foodcart/utils/storage/PreferenceUtils.dart';

class CartList extends StatefulWidget {
  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  List<MenuItemModel> _menuItemList = List();

  @override
  void initState() {
    /*_menuItemList.add(MenuItemModel(
        image:
            "https://www.indianhealthyrecipes.com/wp-content/uploads/2013/01/idli-recipe-1-500x500.jpg",
        description: "1 piece with chutny",
        itemName: "Idli",
        price: "5",
        itemCount: 0,
        time: "8:00 AM - 11:30 AM"));

    _menuItemList.add(MenuItemModel(
        image: "https://maayeka.com/wp-content/uploads/2014/08/masala-dosa-recipe.jpg",
        description: "1 piece with chutny",
        itemName: "Masala Dosa",
        price: "25",
        itemCount: 0,
        time: "8:00 AM - 11:30 AM"));

    _menuItemList.add(MenuItemModel(
        image:
            "https://i2.wp.com/www.vegrecipesofindia.com/wp-content/uploads/2018/10/medu-vada-recipe-2.jpg",
        description: "1 piece with chutny",
        itemName: "Uddina Vada",
        price: "8",
        itemCount: 0,
        time: "8:00 AM - 11:30 AM"));*/

    _loadInitialData();

    super.initState();
  }

  String userId = "", userName = "", userPhone = "";

  Future<List<MenuItemModel>> _loadInitialData() async {
    userId = await PreferenceUtils.getUserId();
    userName = await PreferenceUtils.getUserName();
    userPhone = await PreferenceUtils.getPhoneNumber();

    List<Map<String, dynamic>> _cartItems = await DB.allSelectedItems();
    _menuItemList.clear();
    for (int i = 0; i < _cartItems.length; i++) {
      _menuItemList.add(MenuItemModel.fromMap(_cartItems[i]));
    }
    return _menuItemList;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool apiLoading = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 760, allowFontScaling: true);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("My Cart"),
        elevation: 5,
        leading: IgnorePointer(
          ignoring: apiLoading,
          child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
      ),
      body: apiLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _4header(),
                Expanded(
                  flex: 15,
                  child: FutureBuilder(
                      future: _loadInitialData(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          default:
                            if (snapshot.hasError || _menuItemList.length <= 0)
                              return Center(
                                child: Text("No items in cart"),
                              );
                            else
                              return _listData();
                        }
                      }),
                ),
              ],
            ),
    );
  }

  Widget _listData() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          flex: 15,
          child: ListView.builder(
              itemCount: _menuItemList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    CartItemRow(
                      _menuItemList[index],
                      updateCallback: (bool value) {
                        _doDbOperations(_menuItemList[index], index, value);
                        if (value) {
                          _menuItemList[index].itemCount++;
                        } else {
                          _menuItemList[index].itemCount--;
                        }
                        if (_menuItemList[index].itemCount <= 0) {
                          _menuItemList.removeAt(index);
                        }
                        setState(() {});
                        return value;
                      },
                      deleteCallback: (bool deleteValue) {
                        _doDBItemDeleteOperation(_menuItemList[index], index);
                        if (deleteValue) {
                          _menuItemList.removeAt(index);
                        }
                        setState(() {});
                        return deleteValue;
                      },
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 1,
                    )
                  ],
                );
              }),
        ),
        _bottomPart()
      ],
    );
  }

  void _doDbOperations(MenuItemModel item, int index, bool value) async {
    List<dynamic> _tempList = await DB.checkItem(item);
    if (_tempList.length <= 0) {
      // insert
      DB.insertMenuItem(item);
    } else {
      //update
      DB.updateItemValue(item);
    }

    List<Map<String, dynamic>> _checkList = await DB.checkItem(item);
    if (item.itemCount <= 0) {
      DB.deleteOneMenuItem(item);
    }
    setState(() {});
  }

  void _doDBItemDeleteOperation(MenuItemModel item, int index) async {
    await DB.deleteOneMenuItem(item);
    setState(() {
    });
  }

  Widget _bottomPart() {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10.w)),
        margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.w),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: ListTile(
                  title: Text(
                    "Total:- \u20B9 " + _getTotalItemsPrice(),
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Items:- " + _getTotalItemsQuantity(),
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(right: 7.w),
                child: MaterialButton(
                  onPressed: () {
                    _placeOrder();
                  },
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    "Place Order",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Expanded _4header() {
    return Expanded(
      flex: 1,
      child: Container(
        color: Colors.black,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                child: Text(
                  "Item Name",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                child: Text(
                  "Qty",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                child: Text(
                  "Price",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getTotalItemsPrice() {
    int price = 0;
    for (int i = 0; i < _menuItemList.length; i++) {
      price = price + (int.parse(_menuItemList[i].price) * _menuItemList[i].itemCount);
    }
    return price.toString();
  }

  String _getTotalItemsQuantity() {
    int qty = 0;
    for (int i = 0; i < _menuItemList.length; i++) {
      qty = qty + _menuItemList[i].itemCount;
    }
    return qty.toString();
  }

  void _placeOrder() {
    if (_menuItemList.length <= 0) {
      _scaffoldKey.currentState
          .showSnackBar(ErrorMessages.showErrorMessage("No items available to place order"));
    } else {
      setState(() {
        apiLoading = true;
      });
      Firestore.instance.collection("OrderHistory").getDocuments().then((QuerySnapshot snapshot) {
        // check order no
        _updateOrderDetails(snapshot.documents.length + 1);
        //
      }, onError: (_error) {
        setState(() {
          apiLoading = false;
        });
        _scaffoldKey.currentState.showSnackBar(
            ErrorMessages.showErrorMessage(_error.toString() + " Some thing went wrong"));
      });
    }
  }

  void _updateOrderDetails(int orderNo) async{
    OrderModel orderModel = OrderModel();
    orderModel.status = "Ordered";
    orderModel.orderNo = orderNo;
    orderModel.orderId = DateTime.now().millisecondsSinceEpoch.toString();
    orderModel.totalPrice = int.parse(_getTotalItemsPrice());
    orderModel.totalQty = int.parse(_getTotalItemsQuantity());
    orderModel.Name = userName;
    orderModel.orderBy = userId;
    orderModel.Phone = userPhone;

    List<OrderItemsListListBean> _itemsList = List();
    for (int i = 0; i < _menuItemList.length; i++) {
      OrderItemsListListBean orderItems = OrderItemsListListBean();
      orderItems.itemName = _menuItemList[i].itemName;
      orderItems.itemId = _menuItemList[i].id;
      orderItems.itemPrice = int.parse(_menuItemList[i].price);
      orderItems.quantity = _menuItemList[i].itemCount;
      orderItems.itemTotal = int.parse(_menuItemList[i].price) * _menuItemList[i].itemCount;
      _itemsList.add(orderItems);
    }

    orderModel.orderItemsList = _itemsList;

    Firestore.instance.collection("OrderHistory").document().setData(orderModel.toJson()).then(
        (_onValue) {
          DB.deleteAllMenuItems();
      _scaffoldKey.currentState.showSnackBar(ErrorMessages.showErrorMessage("Updated Success"));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => OrderPlacedSuccess(orderModel.orderNo.toString())));
    }, onError: (_onError) {
      setState(() {
        apiLoading = false;
      });
      _scaffoldKey.currentState.showSnackBar(
          ErrorMessages.showErrorMessage(_onError.toString() + " Some thing went wrong"));
    });
  }
}

typedef changeValue = bool Function(bool);
typedef deleteValue = bool Function(bool);

class CartItemRow extends StatelessWidget {
  MenuItemModel _menuItemModel;
  changeValue updateCallback;
  deleteValue deleteCallback;

  CartItemRow(this._menuItemModel, {this.updateCallback, this.deleteCallback});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                deleteCallback(true);
              }),
        ),
        Expanded(
          flex: 3,
          child: ListTile(
            title: Text(
              _menuItemModel.itemName,
              style: TextStyle(fontSize: 15.ssp, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Price:- \u20B9${_menuItemModel.price}",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _menuItemModel.itemCount != 0
                  ? IconButton(
                      icon: new Icon(Icons.remove),
                      onPressed: () {
                        updateCallback(false);
                      })
                  : new Container(),
              Text(
                _menuItemModel.itemCount.toString(),
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              IconButton(
                  icon: new Icon(Icons.add),
                  onPressed: () {
                    updateCallback(true);
                  }),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "\u20B9" + _getItemTotalPrice(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.ssp, color: Theme.of(context).primaryColor),
          ),
        )
      ],
    );
  }

  String _getItemTotalPrice() {
    return (int.parse(_menuItemModel.price) * _menuItemModel.itemCount).toString();
  }
}
