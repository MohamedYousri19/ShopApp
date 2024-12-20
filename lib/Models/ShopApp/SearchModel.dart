class SearchModel{
  bool? status ;
  SearchDataModel? data ;
  SearchModel.fromJson(Map<String,dynamic> json){
    status = json['status'] ;
    data =  SearchDataModel.fromJson(json['data']);
  }
}
class SearchDataModel{
  int? currentPage ;
  List<Product>? data = [] ;
  SearchDataModel.fromJson(Map<String,dynamic> json){
    currentPage = json['current_page'] ;
    json['data'].forEach((element){
      data?.add(Product.fromJson(element)) ;
    });
  }
}
class Product{
  int? id ;
  dynamic price ;
  dynamic old_price ;
  int? discount ;
  String? image ;
  String? name ;
  bool? in_favorites ;
  Product.fromJson(Map<String,dynamic> json){
    id = json['id'] ;
    price = json['price'] ;
    old_price = json['old_price'] ;
    discount = json['discount'] ;
    image = json['image'] ;
    name = json['name'] ;
    in_favorites = json['in_favorites'] ;
  }
}