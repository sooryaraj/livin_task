/// Class to store the menu item
class MenuItem {
  final String name;
  final double price;

  const MenuItem(this.name, this.price);

  MenuItem copyWith({String? name, double? price}) {
    return MenuItem(name ?? this.name, price ?? this.price);
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(json['name'], json['price']);
  }
}
