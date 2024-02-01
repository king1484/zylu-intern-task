class Employee {
  final int id;
  final String name;
  final DateTime joinDate;
  final bool isActive;

  Employee(
      {required this.id,
      required this.name,
      required this.joinDate,
      required this.isActive});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'joinDate': joinDate.toIso8601String(),
      'isActive': isActive ? 1 : 0,
    };
  }
}
