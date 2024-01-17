class Person {
  final String name;
  final String surName;
  final int? id;
  Person({
    required this.name,
    required this.surName,
    required this.id,
  });
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json["id"],
      name: json["name"],
      surName: json["surName"],
    );
  }
  Map<String, dynamic> get toJson => {
        "id": id.toString(),
        "name": name,
        "surName": surName,
      };
}
