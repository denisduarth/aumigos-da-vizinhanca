abstract class Animal {
  int age;
  String name;

  Animal({required this.age, required this.name});

  Map<String, dynamic> toJson();
}
