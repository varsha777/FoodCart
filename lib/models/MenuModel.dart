import 'package:foodcart/models/Model.dart';

class MenuItemModel{
	int id;
	String image;
	String itemName;
	String time;
	String description;
	String price;
	String type;
	int itemCount;

	static String tableName = "CartItems";

	MenuItemModel({this.id,
		this.image,
		this.itemName,
		this.time,
		this.description,
		this.price,
		this.itemCount,
		this.type});

	MenuItemModel.fromJson(Map<String, dynamic> json) {
		this.id = json['id'];
		this.description = json['description'];
		this.image = json['image'].toString();
		this.itemCount = json['itemCount'];
		this.itemName = json['itemName'];
		this.price = json['price'].toString();
		this.time = json['time'];
		this.type = json['type'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['description'] = this.description;
		data['image'] = this.image;
		data['itemCount'] = this.itemCount;
		data['itemName'] = this.itemName;
		data['price'] = this.price;
		data['time'] = this.time;
		data['type'] = this.type;
		return data;
	}

	Map<String, dynamic> toMap() {
		Map<String, dynamic> map = {
			'id': id,
			'itemCount': itemCount,
			'itemName': itemName,
			"price": price
		};
		return map;
	}

	static MenuItemModel fromMap(Map<String, dynamic> map) {
		print("---${map['id']}");
		return MenuItemModel(
				id: map['id'], itemCount: map['itemCount'], itemName: map['itemName'], price: map['price'].toString());
	}
}
