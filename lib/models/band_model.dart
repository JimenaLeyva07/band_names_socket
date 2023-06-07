class BandModel {
  const BandModel({
    required this.id,
    this.name = 'Anon',
    this.votes = 0,
  });

  factory BandModel.fromJson(Map<String, dynamic> json) {
    return BandModel(
      id: json['id'].toString(),
      name: json['name'].toString(),
      votes: int.tryParse(json['votes'].toString()) ?? 0,
    );
  }

  final String id;
  final String name;
  final int votes;
}
