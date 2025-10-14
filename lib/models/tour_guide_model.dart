class TourGuideModel {
  final String id;
  final String name;
  final String bio;
  final String imageAsset;
  final double rating;
  final List<String> languages;
  final List<String> specialties;
  final int pricePerDay;
  final int reviewCount;
  final String experience;
  final String location;
  final String? phone;
  final String? email;


  TourGuideModel({
    required this.id,
    required this.name,
    required this.bio,
    required this.imageAsset,
    required this.rating,
    required this.languages,
    required this.specialties,
    required this.pricePerDay,
    required this.reviewCount,
    required this.experience,
    required this.location,
    this.phone,
    this.email,
  });

  factory TourGuideModel.fromJson(Map<String, dynamic> json) {
    return TourGuideModel(
      id: json['id'] as String,
      name: json['name'] as String,
      bio: json['bio'] as String,
      imageAsset: json['imageAsset'] as String,
      rating: (json['rating'] as num).toDouble(),
      languages: List<String>.from(json['languages'] ?? []),
      specialties: List<String>.from(json['specialties'] ?? []),
      pricePerDay: json['pricePerDay'] as int,
      reviewCount: json['reviewCount'] as int,
      experience: json['experience'] as String,
      location: json['location'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'imageAsset': imageAsset,
      'rating': rating,
      'languages': languages,
      'specialties': specialties,
      'pricePerDay': pricePerDay,
      'reviewCount': reviewCount,
      'experience': experience,
      'location': location,
      'phone': phone,
      'email': email,
    };
  }
}