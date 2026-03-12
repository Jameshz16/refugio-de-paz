class Verse {
  final String text;
  final String reference;
  final DateTime date;
  final String? prayer;
  bool isFavorite;

  Verse({
    required this.text,
    required this.reference,
    required this.date,
    this.prayer,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'reference': reference,
    'date': date.toIso8601String(),
    'prayer': prayer,
    'isFavorite': isFavorite,
  };

  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
    text: json['text'],
    reference: json['reference'],
    date: DateTime.parse(json['date']),
    prayer: json['prayer'],
    isFavorite: json['isFavorite'] ?? false,
  );
}
