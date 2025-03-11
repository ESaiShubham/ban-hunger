import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Models
class FoodPackage {
  final String id;
  final String title;
  final String description;
  final String donor;
  final String location;
  final int servings;
  final DateTime expiryTime;
  final String imageUrl;

  FoodPackage({
    required this.id,
    required this.title,
    required this.description,
    required this.donor,
    required this.location,
    required this.servings,
    required this.expiryTime,
    required this.imageUrl,
  });
}

class CommunityPost {
  final String id;
  final String userName;
  final String userAvatar;
  final String content;
  final DateTime timestamp;
  final int likes;
  final List<String> images;

  CommunityPost({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.timestamp,
    required this.likes,
    required this.images,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ban Hunger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE23744), // Zomato-inspired red
          primary: const Color(0xFFE23744),
          secondary: const Color(0xFF1C1C1C),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DonateScreen(),
    const RequestScreen(),
    const CommunityScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism),
            label: 'Donate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Request',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class DonateScreen extends StatelessWidget {
  const DonateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: const Text('FoodShare'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Show notifications
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const NotificationsSheet(),
                );
              },
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              SearchBar(
                hintText: 'Search for donation centers...',
                leading: const Icon(Icons.search),
                onTap: () {
                  // Implement search functionality
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Make a Difference',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  DonationCard(
                    icon: Icons.restaurant,
                    title: 'Donate Food',
                    subtitle: 'Share your excess food',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DonateFormScreen(),
                        ),
                      );
                    },
                  ),
                  DonationCard(
                    icon: Icons.attach_money,
                    title: 'Fund a Meal',
                    subtitle: 'Sponsor meals',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FundingScreen(),
                        ),
                      );
                    },
                  ),
                  DonationCard(
                    icon: Icons.delivery_dining,
                    title: 'Volunteer',
                    subtitle: 'Help in distribution',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VolunteerScreen(),
                        ),
                      );
                    },
                  ),
                  DonationCard(
                    icon: Icons.store,
                    title: 'Partner',
                    subtitle: 'Register as NGO',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PartnerScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Recent Donations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return DonationListItem(
                    package: FoodPackage(
                      id: 'id_$index',
                      title: 'Food Package ${index + 1}',
                      description: 'Fresh meals available',
                      donor: 'Restaurant ${index + 1}',
                      location: '${2 + index} km away',
                      servings: 10 + index,
                      expiryTime: DateTime.now().add(const Duration(hours: 4)),
                      imageUrl: 'https://example.com/food$index.jpg',
                    ),
                  );
                },
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class DonationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const DonationCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DonationListItem extends StatelessWidget {
  final FoodPackage package;

  const DonationListItem({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE23744),
          child: Icon(Icons.restaurant, color: Colors.white),
        ),
        title: Text(package.title),
        subtitle: Text(
          '${package.location} • ${package.servings} meals available',
        ),
        trailing: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => DonationDetailsSheet(package: package),
            );
          },
          child: const Text('Claim'),
        ),
      ),
    );
  }
}

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(floating: true, title: Text('Request Food')),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const Text(
                'Available Food Packages',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return FoodRequestCard(
                    package: FoodPackage(
                      id: 'req_$index',
                      title: 'Food Package ${index + 1}',
                      description: 'Fresh meals from local restaurant',
                      donor: 'Restaurant ${index + 1}',
                      location: '${1 + index} km away',
                      servings: 5 + index,
                      expiryTime: DateTime.now().add(const Duration(hours: 3)),
                      imageUrl: 'https://example.com/food$index.jpg',
                    ),
                  );
                },
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class FoodRequestCard extends StatelessWidget {
  final FoodPackage package;

  const FoodRequestCard({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            color: Colors.grey[300],
            child: Center(
              child: Icon(Icons.restaurant, size: 50, color: Colors.grey[600]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(package.description),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(package.location),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text('${package.servings} servings left'),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder:
                            (context) =>
                                RequestConfirmationSheet(package: package),
                      );
                    },
                    child: const Text('Request Now'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: const Text('Community'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreatePostScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return CommunityPostCard(
                    post: CommunityPost(
                      id: 'post_$index',
                      userName: 'User ${index + 1}',
                      userAvatar: 'https://example.com/avatar$index.jpg',
                      content:
                          'Donated ${10 + index} meals today! Feeling grateful to be able to help those in need. #FoodShare #Community',
                      timestamp: DateTime.now().subtract(
                        Duration(hours: index),
                      ),
                      likes: 10 + index,
                      images: ['https://example.com/post$index.jpg'],
                    ),
                  );
                },
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class CommunityPostCard extends StatelessWidget {
  final CommunityPost post;

  const CommunityPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                post.userName[0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(post.userName),
            subtitle: Text(
              '${post.timestamp.hour}h ago',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(post.content),
          ),
          const SizedBox(height: 8),
          if (post.images.isNotEmpty)
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300],
              child: Center(
                child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                Text('${post.likes}'),
                IconButton(
                  icon: const Icon(Icons.comment_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          title: Text('Profile'),
          actions: [IconButton(icon: Icon(Icons.settings), onPressed: null)],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const ProfileHeader(),
              const SizedBox(height: 24),
              const ProfileStats(),
              const SizedBox(height: 24),
              const Text(
                'My Donations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return DonationHistoryItem(
                    package: FoodPackage(
                      id: 'history_$index',
                      title: 'Food Package ${index + 1}',
                      description: 'Donated to Local Shelter',
                      donor: 'You',
                      location: 'Local Food Bank',
                      servings: 15 + index,
                      expiryTime: DateTime.now().subtract(
                        Duration(days: index),
                      ),
                      imageUrl: 'https://example.com/history$index.jpg',
                    ),
                  );
                },
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Color(0xFFE23744),
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 16),
        const Text(
          'John Doe',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Active Member since Jan 2024',
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: () {}, child: const Text('Edit Profile')),
      ],
    );
  }
}

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('Donations', '23'),
        _buildStatItem('Meals Shared', '156'),
        _buildStatItem('Impact', '200+'),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class DonationHistoryItem extends StatelessWidget {
  final FoodPackage package;

  const DonationHistoryItem({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE23744),
          child: Icon(Icons.volunteer_activism, color: Colors.white),
        ),
        title: Text(package.title),
        subtitle: Text('${package.servings} meals • ${package.location}'),
        trailing: Text(
          '${package.expiryTime.day}/${package.expiryTime.month}',
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

// Additional Screens
class DonateFormScreen extends StatelessWidget {
  const DonateFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Donate Food')),
      body: const Center(child: Text('Donate Form')),
    );
  }
}

class FundingScreen extends StatelessWidget {
  const FundingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fund a Meal')),
      body: const Center(child: Text('Funding Screen')),
    );
  }
}

class VolunteerScreen extends StatelessWidget {
  const VolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Volunteer')),
      body: const Center(child: Text('Volunteer Screen')),
    );
  }
}

class PartnerScreen extends StatelessWidget {
  const PartnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Partner with Us')),
      body: const Center(child: Text('Partner Screen')),
    );
  }
}

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: const Center(child: Text('Create Post Screen')),
    );
  }
}

class NotificationsSheet extends StatelessWidget {
  const NotificationsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Notifications',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Center(child: Text('No new notifications')),
        ],
      ),
    );
  }
}

class DonationDetailsSheet extends StatelessWidget {
  final FoodPackage package;

  const DonationDetailsSheet({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            package.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(package.description),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(package.location),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Implement donation logic
              },
              child: const Text('Confirm Donation'),
            ),
          ),
        ],
      ),
    );
  }
}

class RequestConfirmationSheet extends StatelessWidget {
  final FoodPackage package;

  const RequestConfirmationSheet({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Request ${package.title}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text('Location: ${package.location}'),
          Text('Servings: ${package.servings}'),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Implement request logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Request sent successfully!')),
                );
              },
              child: const Text('Confirm Request'),
            ),
          ),
        ],
      ),
    );
  }
}
