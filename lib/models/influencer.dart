class Influencer {
  final String name;
  final String profilePicture;
  final String username;
  final int followerCount;
  final double engagementRate;
  final double creditPoints;
  final String niche;
  final int shareCount;
  final int likesCount;
  final int commentsCount;

  Influencer({
    required this.name,
    required this.profilePicture,
    required this.username,
    required this.followerCount,
    required this.engagementRate,
    required this.creditPoints,
    required this.niche,
    required this.shareCount,
    required this.likesCount,
    required this.commentsCount,
  });

  factory Influencer.fromMap(Map<dynamic, dynamic> map) {
    return Influencer(
      name: map['name'] as String? ?? '',
      profilePicture: 'assets/images/dummy.jpg',
      username: map['username'] as String? ?? '',
      followerCount: map['followerCount'] as int? ?? 0,
      engagementRate: (map['engagementRate'] as num?)?.toDouble() ?? 0.0,
      creditPoints: (map['creditPoints'] as num?)?.toDouble() ?? 0.0,
      niche: map['niche'] as String? ?? '',
      shareCount: map['shareCount'] as int? ?? 0,
      likesCount: map['likesCount'] as int? ?? 0,
      commentsCount: map['commentsCount'] as int? ?? 0,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePicture': profilePicture,
      'username': username,
      'followerCount': followerCount,
      'engagementRate': engagementRate,
      'creditPoints': creditPoints,
      'niche': niche,
      'shareCount': shareCount,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
    };
  }
}

// List<Influencer> influencers = [
//   Influencer(
//     name: 'Fitness Guru',
//     profilePicture: 'assets/images/fitness_guru.jpg',
//     username: '@fitguru',
//     followerCount: 1000000,
//     engagementRate: 4.5,
//     creditPoints: 3.0,
//     niche: 'Fitness',
//     shareCount: 200,
//     likesCount: 4000,
//     commentsCount: 1000,
//   ),
//   Influencer(
//     name: 'Fashionista',
//     profilePicture: 'assets/images/fashionista.jpg',
//     username: '@fashionista',
//     followerCount: 1500000,
//     engagementRate: 3.8,
//     creditPoints: 2.5,
//     niche: 'Fashion',
//     shareCount: 150,
//     likesCount: 3500,
//     commentsCount: 800,
//   ),
//   Influencer(
//     name: 'Foodie Delights',
//     profilePicture: 'assets/images/foodie_delights.jpg',
//     username: '@foodiedelights',
//     followerCount: 800000,
//     engagementRate: 5.2,
//     creditPoints: 3.5,
//     niche: 'Food',
//     shareCount: 180,
//     likesCount: 3000,
//     commentsCount: 600,
//   ),
//   Influencer(
//     name: 'Travel Explorer',
//     profilePicture: 'assets/images/travel_explorer.jpg',
//     username: '@travelexplorer',
//     followerCount: 1200000,
//     engagementRate: 3.2,
//     creditPoints: 4.0,
//     niche: 'Travel',
//     shareCount: 250,
//     likesCount: 2800,
//     commentsCount: 500,
//   ),
//   Influencer(
//     name: 'Tech Geek',
//     profilePicture: 'assets/images/tech_geek.jpg',
//     username: '@techgeek',
//     followerCount: 900000,
//     engagementRate: 4.0,
//     creditPoints: 2.0,
//     niche: 'Technology',
//     shareCount: 100,
//     likesCount: 1500,
//     commentsCount: 400,
//   ),
//   Influencer(
//     name: 'Beauty Guru',
//     profilePicture: 'assets/images/beauty_guru.jpg',
//     username: '@beautyguru',
//     followerCount: 1300000,
//     engagementRate: 4.3,
//     creditPoints: 3.5,
//     niche: 'Beauty',
//     shareCount: 300,
//     likesCount: 4500,
//     commentsCount: 900,
//   ),
//   Influencer(
//     name: 'Gaming Master',
//     profilePicture: 'assets/images/gaming_master.jpg',
//     username: '@gamingmaster',
//     followerCount: 1100000,
//     engagementRate: 3.5,
//     creditPoints: 4.5,
//     niche: 'Gaming',
//     shareCount: 80,
//     likesCount: 2000,
//     commentsCount: 300,
//   ),
//   Influencer(
//     name: 'Art Enthusiast',
//     profilePicture: 'assets/images/art_enthusiast.jpg',
//     username: '@artenthusiast',
//     followerCount: 950000,
//     engagementRate: 3.7,
//     creditPoints: 2.5,
//     niche: 'Art',
//     shareCount: 50,
//     likesCount: 800,
//     commentsCount: 200,
//   ),
//   Influencer(
//     name: 'Travel Blogger',
//     profilePicture: 'assets/images/travel_blogger.jpg',
//     username: '@travelblogger',
//     followerCount: 1400000,
//     engagementRate: 4.1,
//     creditPoints: 3.0,
//     niche: 'Travel',
//     shareCount: 120,
//     likesCount: 3200,
//     commentsCount: 700,
//   ),
//   Influencer(
//     name: 'Lifestyle Influencer',
//     profilePicture: 'assets/images/lifestyle_influencer.jpg',
//     username: '@lifestyleinfluencer',
//     followerCount: 1050000,
//     engagementRate: 3.9,
//     creditPoints: 2.8,
//     niche: 'Lifestyle',
//     shareCount: 70,
//     likesCount: 1800,
//     commentsCount: 400,
//   ),
// ];
