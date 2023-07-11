class Influencer {
  final String name;
  final String profilePicture;
  final String username;
  final int followerCount;
  final double engagementRate;
  final double creditPoints;
  final String niche;

  Influencer({
    required this.name,
    required this.profilePicture,
    required this.username,
    required this.followerCount,
    required this.engagementRate,
    required this.creditPoints,
    required this.niche,
  });

  factory Influencer.fromMap(Map<dynamic, dynamic> map) {
    return Influencer(
        name: map['name'] as String? ?? '',
        profilePicture: 'assets/images/dummy_profile_pic.png',
        username: map['username'] as String? ?? '',
        followerCount: map['followerCount'] as int? ?? 0,
        engagementRate: (map['engagementRate'] as num?)?.toDouble() ?? 0.0,
        creditPoints: (map['creditPoints'] as num?)?.toDouble() ?? 0.0,
        niche: map['niche'] as String? ?? '');
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
    };
  }
}

List<Influencer> influencers = [
  Influencer(
    name: 'Fitness Guru',
    profilePicture: 'assets/images/fitness_guru.jpg',
    username: '@fitguru',
    followerCount: 1000000,
    engagementRate: 4.5,
    creditPoints: 3.0,
    niche: 'Fitness',
  ),
  Influencer(
    name: 'Fashionista',
    profilePicture: 'assets/images/fashionista.jpg',
    username: '@fashionista',
    followerCount: 1500000,
    engagementRate: 3.8,
    creditPoints: 2.5,
    niche: 'Fashion ',
  ),
  Influencer(
    name: 'Foodie Delights',
    profilePicture: 'assets/images/foodie_delights.jpg',
    username: '@foodiedelights',
    followerCount: 800000,
    engagementRate: 5.2,
    creditPoints: 3.5,
    niche: 'Food',
  ),
  Influencer(
    name: 'Travel Explorer',
    profilePicture: 'assets/images/travel_explorer.jpg',
    username: '@travelexplorer',
    followerCount: 1200000,
    engagementRate: 3.2,
    creditPoints: 4.0,
    niche: 'Travel',
  ),
  Influencer(
    name: 'Tech Geek',
    profilePicture: 'assets/images/tech_geek.jpg',
    username: '@techgeek',
    followerCount: 900000,
    engagementRate: 4.0,
    creditPoints: 2.0,
    niche: 'Technology',
  ),
  Influencer(
    name: 'Beauty Guru',
    profilePicture: 'assets/images/beauty_guru.jpg',
    username: '@beautyguru',
    followerCount: 1300000,
    engagementRate: 4.3,
    creditPoints: 3.5,
    niche: 'Beauty',
  ),
  Influencer(
    name: 'Gaming Master',
    profilePicture: 'assets/images/gaming_master.jpg',
    username: '@gamingmaster',
    followerCount: 1100000,
    engagementRate: 3.5,
    creditPoints: 4.5,
    niche: 'Gaming',
  ),
  Influencer(
    name: 'Art Enthusiast',
    profilePicture: 'assets/images/art_enthusiast.jpg',
    username: '@artenthusiast',
    followerCount: 950000,
    engagementRate: 3.7,
    creditPoints: 2.5,
    niche: 'Art',
  ),
  Influencer(
    name: 'Travel Blogger',
    profilePicture: 'assets/images/travel_blogger.jpg',
    username: '@travelblogger',
    followerCount: 1400000,
    engagementRate: 4.1,
    creditPoints: 3.0,
    niche: 'Travel',
  ),
  Influencer(
    name: 'Lifestyle Influencer',
    profilePicture: 'assets/images/lifestyle_influencer.jpg',
    username: '@lifestyleinfluencer',
    followerCount: 1050000,
    engagementRate: 3.9,
    creditPoints: 2.8,
    niche: 'Lifestyle',
  ),
];
