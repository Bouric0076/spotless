import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerDashboard extends StatefulWidget {
  final String username;

  const CustomerDashboard({super.key, required this.username});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

// ------------------- Home Screen -------------------
class _HomeScreen extends StatelessWidget {
  final String username;
  final VoidCallback onLogout;

  const _HomeScreen({Key? key, required this.username, required this.onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spotless Dashboard', style: GoogleFonts.roboto(color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onLogout,
            tooltip: 'Logout',
            color: Colors.white,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Welcome back, $username!',
                style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.cleaning_services, color: Colors.blue),
                title: const Text('Next Booking'),
                subtitle: const Text('Friday, 24 May at 10:00 AM'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            const SizedBox(height: 16),
            Text("Quick Actions", style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _QuickActionCard(icon: Icons.add, label: 'New Booking', color: Colors.blue),
                _QuickActionCard(icon: Icons.schedule, label: 'Schedule', color: Colors.blue.shade300),
                _QuickActionCard(icon: Icons.star, label: 'Rate Us', color: Colors.blue.shade100),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickActionCard({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 100,
        height: 100,
        child: InkWell(
          onTap: () {}, // Add navigation or actions here
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(height: 8),
              Text(label, style: GoogleFonts.roboto(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------- Bookings Screen -------------------
class _BookingsScreen extends StatelessWidget {
  const _BookingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _BookingCard(service: 'Deep Cleaning', date: 'May 24, 2025', time: '10:00 AM'),
          _BookingCard(service: 'Sofa Shampoo', date: 'June 2, 2025', time: '2:00 PM'),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final String service, date, time;

  const _BookingCard({required this.service, required this.date, required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.cleaning_services, color: Colors.blue),
        title: Text(service),
        subtitle: Text('$date at $time'),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}

// ------------------- Support Screen -------------------
class _SupportScreen extends StatelessWidget {
  const _SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.message, color: Colors.blue),
            title: const Text('Chat with Support'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.blue),
            title: const Text('Email Us'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.blue),
            title: const Text('FAQs'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// ------------------- Profile Screen -------------------
class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(radius: 40, backgroundImage: AssetImage('assets/avatar.png')),
            const SizedBox(height: 16),
            Text('Name: Jane Doe', style: GoogleFonts.roboto(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Email: jane@example.com', style: GoogleFonts.roboto(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Phone: +254 712 345678', style: GoogleFonts.roboto(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

// ------------------- Main Dashboard State -------------------
class _CustomerDashboardState extends State<CustomerDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      _HomeScreen(username: widget.username, onLogout: _handleLogout),
      const _BookingsScreen(),
      const _SupportScreen(),
      const _ProfileScreen(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: Colors.blue.shade100,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.calendar_today), label: 'Bookings'),
          NavigationDestination(icon: Icon(Icons.support_agent), label: 'Support'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  void _handleLogout() {
    // Replace with actual logout logic (e.g., clearing tokens, navigating to login page)
    Navigator.of(context).pop(); // Temporarily go back to previous screen
  }
}
