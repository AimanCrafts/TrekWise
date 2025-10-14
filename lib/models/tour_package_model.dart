class TourPackageModel {
  final String id;
  final String title;
  final String description;
  final String duration;
  final int price;
  final double rating;
  final List<String> includes;
  final int maxPeople;
  final String difficulty;
  final String season;
  final int bookings;
  final DateTime startDate;
  final DateTime endDate;
  final String imageUrl;

  TourPackageModel({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.price,
    required this.rating,
    required this.includes,
    required this.maxPeople,
    required this.difficulty,
    required this.season,
    required this.bookings,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
  });

  factory TourPackageModel.fromJson(Map<String, dynamic> json) {
    return TourPackageModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      duration: json['duration'] as String,
      price: json['price'] as int,
      rating: (json['rating'] as num).toDouble(),
      includes: List<String>.from(json['includes'] ?? []),
      maxPeople: json['maxPeople'] as int,
      difficulty: json['difficulty'] as String,
      season: json['season'] as String,
      bookings: json['bookings'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'price': price,
      'rating': rating,
      'includes': includes,
      'maxPeople': maxPeople,
      'difficulty': difficulty,
      'season': season,
      'bookings': bookings,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }
}
