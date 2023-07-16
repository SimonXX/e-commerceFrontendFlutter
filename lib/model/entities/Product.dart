class Product {

  int? id;
  String? barCode;
  String? name;
  String? description;
  String? image;
  double? price;
  int? quantity;


  Product.empty();

  Product({
    this.id,
    this.barCode,
    this.name,
    this.description,
    this.image,
    this.price,
    this.quantity,

  });

  factory Product.fromJson(Map<String, dynamic> json){


    Product prodotto =  Product(
      id:json['id'],
      barCode: json['barCode'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
      quantity: json['quantity'],
    );


    return prodotto;
  }


  Map<String, dynamic> toJson() => {
    'id': id,
    'barCode': barCode,
    'name': name,
    'description': description,
    'image': image,
    'price': price,
    'quantity': quantity
  };

  @override
  String toString(){
    return barCode! + " " + name! + " " + quantity.toString() ;
  }
}