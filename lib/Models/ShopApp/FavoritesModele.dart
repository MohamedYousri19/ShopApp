class FavoritesModel{
  bool? status ;
  FavoritesDataModel? data ;
  FavoritesModel.fromJson(Map<String,dynamic> json){
    status = json['status'] ;
    data =  FavoritesDataModel.fromJson(json['data']);
  }
}
class FavoritesDataModel{
  int? currentPage ;
  List<DataModel>? data = [] ;
  FavoritesDataModel.fromJson(Map<String,dynamic> json){
    currentPage = json['current_page'] ;
    json['data'].forEach((element){
      data?.add(DataModel.fromJson(element)) ;
    });
  }
}
class DataModel {
  int? id ;
  Product? product ;

  DataModel.fromJson(Map<String,dynamic> json){
    id = json['id'] ;
    product = Product.fromJson(json['product']) ;
  }
}
class Product{
  int? id ;
  dynamic price ;
  dynamic old_price ;
  int? discount ;
  String? image ;
  String? name ;
  Product.fromJson(Map<String,dynamic> json){
    id = json['id'] ;
    price = json['price'] ;
    old_price = json['old_price'] ;
    discount = json['discount'] ;
    image = json['image'] ;
    name = json['name'] ;
  }
}