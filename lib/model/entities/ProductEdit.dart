class ProductEdit {

  int? id;
  String? name;
  String? description;
  String? image;
  double? price;
  int? quantity;


  ProductEdit.empty();

  ProductEdit({

    this.id,
    this.name,
    this.description,
    this.image,
    this.price,
    this.quantity,

  });

  factory ProductEdit.fromJson(Map<String, dynamic> json){


    ProductEdit prodotto =  ProductEdit(

      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
      quantity: json['quantity'],
    );


    return prodotto;
  }


  Map<String, dynamic> toJson() => {

    'name': name,
    'description': description,
    'image': image,
    'price': price,
    'quantity': quantity
  };

  @override
  String toString(){
    return name! + " " + quantity.toString() ;
  }
}