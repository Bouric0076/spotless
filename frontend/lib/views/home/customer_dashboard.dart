import 'package:flutter/material.dart';

class CustomerDashboard extends StatelessWidget {
  final String username;

  const CustomerDashboard({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Welcome Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.green[700],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, $username 👋',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Here’s what’s happening today',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Quick Actions Grid
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _DashboardCard(
                    icon: Icons.cleaning_services_rounded,
                    label: 'Book Cleaning',
                    onTap: () {
                      // TODO: Navigate to booking page
                      print('Navigate to Book Cleaning');
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.calendar_today,
                    label: 'My Bookings',
                    onTap: () {
                      // TODO: Navigate to bookings
                      print('Navigate to My Bookings');
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.chat,
                    label: 'Support Chat',
                    onTap: () {
                      // TODO: Navigate to chat
                      print('Navigate to Chat');
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.person,
                    label: 'Profile',
                    onTap: () {
                      // TODO: Navigate to profile
                      print('Navigate to Profile');
                    },
                  ),
                ],
              ),
            ),

            const Divider(),

            // Status Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _StatusTile(
                    title: 'Upcoming Booking',
                    subtitle: 'Tuesday, 10 AM',
                    icon: Icons.schedule,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 10),
                  _StatusTile(
                    title: 'Messages from Support',
                    subtitle: '2 unread',
                    icon: Icons.message,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Dashboard Action Card
class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.green[700]),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Status Tile Widget
class _StatusTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatusTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => print('$title tapped'),
      ),
    );
  }
}
