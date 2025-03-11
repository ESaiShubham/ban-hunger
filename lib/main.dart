import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'services/ai_service.dart';
import 'package:intl/intl.dart';

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
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          displayLarge: GoogleFonts.playfairDisplay(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 16,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 14,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
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
  final TextEditingController _promptController = TextEditingController();
  final AiService _aiService = AiService();
  String? _aiResponse;
  bool _isLoading = false;

  final List<Widget> _screens = [
    const DonateScreen(),
    const RequestScreen(),
    const CommunityScreen(),
    const ProfileScreen(),
  ];

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _getAiResponse() async {
    if (_promptController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final response = await _aiService.getResponse(_promptController.text);

    setState(() {
      _aiResponse = response;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show AI assistant dialog
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (context, setState) => Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: const Icon(
                              Icons.restaurant_menu,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Food Assistant',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('How can I help you with food donations today?'),
                      const SizedBox(height: 16),
                      if (_aiResponse != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(_aiResponse!),
                        ),
                        const SizedBox(height: 16),
                      ],
                      TextField(
                        controller: _promptController,
                        decoration: const InputDecoration(
                          hintText: 'Ask me about donations, food, or assistance...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        minLines: 1,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : () async {
                            await _getAiResponse();
                            setState(() {}); // Update the bottom sheet UI
                          },
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Send'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.restaurant_menu,
          color: Colors.white,
        ),
      ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
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
          title: const Text('Ban Hunger'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
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
              // Emergency Food Request Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.error,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.priority_high,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Urgent Food Requests',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '3 families nearby need immediate food assistance',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to urgent requests
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Help Now'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  DonationCard(
                    icon: Icons.restaurant,
                    title: 'Share Food',
                    subtitle: 'Donate cooked or packaged food',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DonateFormScreen(),
                        ),
                      );
                    },
                    index: 0,
                  ),
                  DonationCard(
                    icon: Icons.delivery_dining,
                    title: 'Pickup Request',
                    subtitle: 'Request food pickup from your location',
                    onTap: () {
                      // Implement pickup request
                    },
                    index: 1,
                  ),
                  DonationCard(
                    icon: Icons.groups,
                    title: 'Community Kitchen',
                    subtitle: 'Cook for the community',
                    onTap: () {
                      // Navigate to community kitchen screen
                    },
                    index: 2,
                  ),
                  DonationCard(
                    icon: Icons.store,
                    title: 'Restaurant Partner',
                    subtitle: 'Register restaurant/store',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PartnerScreen(),
                        ),
                      );
                    },
                    index: 3,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available Food',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // View all donations
                    },
                    child: const Text('View All'),
                  ),
                ],
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
                      title: 'Fresh Meals',
                      description: 'Freshly cooked meals available for immediate pickup',
                      donor: 'Community Kitchen ${index + 1}',
                      location: '${2 + index} km away',
                      servings: 10 + index,
                      expiryTime: DateTime.now().add(const Duration(hours: 4)),
                      imageUrl: 'https://example.com/food$index.jpg',
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Impact Stats',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildImpactStat(
                          context,
                          '1.2K',
                          'Meals Shared',
                          Icons.restaurant,
                        ),
                        _buildImpactStat(
                          context,
                          '320',
                          'Families Helped',
                          Icons.people,
                        ),
                        _buildImpactStat(
                          context,
                          '45',
                          'Active Donors',
                          Icons.volunteer_activism,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildImpactStat(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
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
  final int index;

  const DonationCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: Duration(milliseconds: 100 * index),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          child: Container(
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
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ).animate()
        .fadeIn(duration: const Duration(milliseconds: 500))
        .scale(delay: Duration(milliseconds: 100 * index)),
    );
  }
}

class DonationListItem extends StatelessWidget {
  final FoodPackage package;

  const DonationListItem({
    super.key,
    required this.package,
  });

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
        subtitle: Text('${package.location} • ${package.servings} meals available'),
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
        const SliverAppBar(
          floating: true,
          title: Text('Request Food'),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const Text(
                'Available Food Packages',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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

  const FoodRequestCard({
    super.key,
    required this.package,
  });

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
              child: Icon(
                Icons.restaurant,
                size: 50,
                color: Colors.grey[600],
              ),
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
                    Icon(Icons.location_on,
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
                        builder: (context) => RequestConfirmationSheet(
                          package: package,
                        ),
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
                      content: 'Donated ${10 + index} meals today! Feeling grateful to be able to help those in need. #FoodShare #Community',
                      timestamp: DateTime.now().subtract(Duration(hours: index)),
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

  const CommunityPostCard({
    super.key,
    required this.post,
  });

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
                child: Icon(
                  Icons.image,
                  size: 50,
                  color: Colors.grey[600],
                ),
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
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: null,
            ),
          ],
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
                      expiryTime: DateTime.now().subtract(Duration(days: index)),
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
          child: Icon(
            Icons.person,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Sita Rama',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Active Member since Jan 2024',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Edit Profile'),
        ),
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
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class DonationHistoryItem extends StatelessWidget {
  final FoodPackage package;

  const DonationHistoryItem({
    super.key,
    required this.package,
  });

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
class DonateFormScreen extends StatefulWidget {
  const DonateFormScreen({super.key});

  @override
  State<DonateFormScreen> createState() => _DonateFormScreenState();
}

class _DonateFormScreenState extends State<DonateFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _servingsController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime _expiryTime = DateTime.now().add(const Duration(hours: 4));
  bool _canProvideDelivery = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _servingsController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Food'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FadeInDown(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Food Safety Guidelines',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• Ensure food is properly packaged\n• Include expiry date\n• Maintain proper temperature\n• List all ingredients',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInLeft(
                delay: const Duration(milliseconds: 200),
                child: TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Food Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              FadeInLeft(
                delay: const Duration(milliseconds: 300),
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              FadeInLeft(
                delay: const Duration(milliseconds: 400),
                child: TextFormField(
                  controller: _servingsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Number of Servings',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of servings';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              FadeInLeft(
                delay: const Duration(milliseconds: 500),
                child: TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Pickup Location',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pickup location';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              FadeInRight(
                delay: const Duration(milliseconds: 600),
                child: ListTile(
                  title: const Text('Best Before Time'),
                  subtitle: Text(
                    DateFormat('MMM dd, yyyy HH:mm').format(_expiryTime),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_expiryTime),
                      );
                      if (time != null) {
                        setState(() {
                          _expiryTime = DateTime(
                            _expiryTime.year,
                            _expiryTime.month,
                            _expiryTime.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInRight(
                delay: const Duration(milliseconds: 700),
                child: SwitchListTile(
                  title: const Text('Can Provide Delivery'),
                  value: _canProvideDelivery,
                  onChanged: (bool value) {
                    setState(() {
                      _canProvideDelivery = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                delay: const Duration(milliseconds: 800),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Submit Donation'),
                  ),
                ).animate(
                  target: _canProvideDelivery ? 1.0 : 0.0,
                ).scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement form submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for sharing food!')),
      );
      Navigator.pop(context);
    }
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
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

  const DonationDetailsSheet({
    super.key,
    required this.package,
  });

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
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
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

  const RequestConfirmationSheet({
    super.key,
    required this.package,
  });

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
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
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
                  const SnackBar(
                    content: Text('Request sent successfully!'),
                  ),
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
