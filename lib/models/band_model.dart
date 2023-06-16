class BandModel {
  const BandModel({
    required this.id,
    this.name = 'Anon',
    this.votes = 0,
  });

  factory BandModel.fromJson(Map<String, dynamic> json) {
    return BandModel(
      id: json.containsKey('id') ? json['id'].toString() : 'no-id',
      name: json.containsKey('name') ? json['name'].toString() : 'no-name',
      votes: json.containsKey('votes')
          ? (int.tryParse(json['votes'].toString()) ?? 0)
          : 0,
    );
  }

  final String id;
  final String name;
  final int votes;
}
