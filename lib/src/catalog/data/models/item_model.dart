class ItemModel {
  const ItemModel({required this.id, required this.name, required this.price});

  final String id;
  final String name;
  final double price;

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}
