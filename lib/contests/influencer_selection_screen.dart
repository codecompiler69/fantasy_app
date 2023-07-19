import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fantasyapp/widgets/app_text.dart';

import 'create_team.dart';

enum SortOption {
  engagementRate,
  followerCount,
}

class InfluencerScreen extends StatefulWidget {
  const InfluencerScreen({Key? key, required this.contestData})
      : super(key: key);
  final Map<String, dynamic> contestData;

  @override
  State<InfluencerScreen> createState() => _InfluencerScreenState();
}

class _InfluencerScreenState extends State<InfluencerScreen> {
  final TextEditingController _searchController = TextEditingController();
  SortOption _sortOption = SortOption.engagementRate;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchInfluencers(String searchQuery) {
    setState(() {
      _sortOption = SortOption.engagementRate;
    });
  }

  Stream<QuerySnapshot> _applySorting(CollectionReference collection) {
    if (_sortOption == SortOption.engagementRate) {
      return collection.orderBy('engagementRate', descending: true).snapshots();
    } else {
      return collection.orderBy('followerCount', descending: true).snapshots();
    }
  }

  void pushToCreateTeam() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTeam(
          contestData: widget.contestData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Influencers',
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: const Color.fromARGB(255, 176, 144, 229),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: pushToCreateTeam,
        label: const Text('Create Team'),
        icon: const Icon(Icons.edit),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
            child: TextField(
              controller: _searchController,
              onChanged: _searchInfluencers,
              decoration: const InputDecoration(
                hintText: 'Search by name or username',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const AppText(
                  text: 'Sort by : ',
                  size: 18.0,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(width: 15),
                DropdownButton<SortOption>(
                  value: _sortOption,
                  onChanged: (SortOption? option) {
                    setState(() {
                      _sortOption = option!;
                    });
                  },
                  items: const [
                    DropdownMenuItem<SortOption>(
                      value: SortOption.engagementRate,
                      child: Text('Engagement Rate'),
                    ),
                    DropdownMenuItem<SortOption>(
                      value: SortOption.followerCount,
                      child: Text('Follower Count'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _applySorting(
                  FirebaseFirestore.instance.collection('influencers')),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: AppText(
                      text: 'Error: ${snapshot.error}',
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final influencerDocs = snapshot.data?.docs ?? [];

                return ListView.builder(
                  itemCount: influencerDocs.length,
                  itemBuilder: (context, index) {
                    final influencerData =
                        influencerDocs[index].data() as Map<String, dynamic>;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            AssetImage(influencerData['profilePicture']),
                      ),
                      title: AppText(
                        text: influencerData['name'],
                        fontWeight: FontWeight.bold,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: influencerData['username'],
                          ),
                          AppText(
                            text:
                                'Followers: ${influencerData['followerCount'].toString()}',
                          ),
                        ],
                      ),
                      trailing: AppText(
                        text:
                            'Engagement Rate: ${influencerData['engagementRate']}%',
                        size: 13,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
