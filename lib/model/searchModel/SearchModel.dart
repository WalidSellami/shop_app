class SearchModel {
  bool? status;
  FData? data;

  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = (json['data'] != null) ?  FData.fromJson(json['data']) : null;
  }

}

class FData {
  int? currentPage;
  List<SData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? path;
  int? perPage;
  int? to;
  int? total;

  FData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <SData>[];
      json['data'].forEach((v) {
        data!.add(SData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }
}

class SData {
  int? id;
  dynamic price;
  String? image;
  String? name;
  String? description;

  SData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    image = json['image'];
    name = json['name'];
    description = json['description'];

  }

}

