class Employee {
  const Employee({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.company,
    required this.email,
  });

  final String id;
  final String name;
  final String jobTitle;
  final String company;
  final String email;

  String get firstName => name.split(' ').first;

  String get initial => name.isEmpty ? '' : name[0].toUpperCase();
}
