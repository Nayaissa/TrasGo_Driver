class TabModel {
  bool? success;
  String? message;
  Data? data;
  int? statusCode;
  String? timestamp;

  TabModel(
      {this.success, this.message, this.data, this.statusCode, this.timestamp});

  TabModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    statusCode = json['status_code'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status_code'] = this.statusCode;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Data {
  List<Items>? items;

  Data({this.items});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  String? key;
  String? name;
  String? description;
  bool? isFinal;
  int? displayOrder;
  String? color;

  Items(
      {this.id,
      this.key,
      this.name,
      this.description,
      this.isFinal,
      this.displayOrder,
      this.color});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    name = json['name'];
    description = json['description'];
    isFinal = json['is_final'];
    displayOrder = json['display_order'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['key'] = this.key;
    data['name'] = this.name;
    data['description'] = this.description;
    data['is_final'] = this.isFinal;
    data['display_order'] = this.displayOrder;
    data['color'] = this.color;
    return data;
  }
}