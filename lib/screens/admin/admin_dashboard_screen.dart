import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'approvals_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      body: SafeArea(
        child: Column(
          children: [


            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purple],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Admin Dashboard",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Manage your platform efficiently",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('sellers')
                    .snapshots(),
                builder: (context, snapshot) {

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }

                  final docs = snapshot.data!.docs;

                  final total = docs.length;

                  final pending = docs.where((d) {
                    final data = d.data() as Map<String, dynamic>;
                    return (data['approvalStatus'] ?? 'pending') == 'pending';
                  }).length;

                  final approved = docs.where((d) {
                    final data = d.data() as Map<String, dynamic>;
                    return (data['approvalStatus'] ?? 'pending') == 'approved';
                  }).length;

                  final rejected = docs.where((d) {
                    final data = d.data() as Map<String, dynamic>;
                    return (data['approvalStatus'] ?? 'pending') == 'rejected';
                  }).length;

                  return Row(
                    children: [
                      _statCard("Total", total, Colors.blue),
                      const SizedBox(width: 10),
                      _statCard("Pending", pending, Colors.orange),
                      const SizedBox(width: 10),
                      _statCard("Approved", approved, Colors.green),
                      const SizedBox(width: 10),
                      _statCard("Rejected", rejected, Colors.red),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 30),


            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [

                    _featureCard(
                      context,
                      "Client Approvals",
                      Icons.verified_user,
                      Colors.green,
                      const ApprovalsScreen(),
                    ),

                    _featureCard(
                      context,
                      "Client Management",
                      Icons.people,
                      Colors.blue,
                      const Placeholder(),
                    ),

                    _featureCard(
                      context,
                      "Advertisement",
                      Icons.campaign,
                      Colors.orange,
                      const Placeholder(),
                    ),

                    _featureCard(
                      context,
                      "Offer Approvals",
                      Icons.local_offer,
                      Colors.purple,
                      const Placeholder(),
                    ),

                    _featureCard(
                      context,
                      "User Management",
                      Icons.person,
                      Colors.teal,
                      const Placeholder(),
                    ),

                    _featureCard(
                      context,
                      "Reports & Analytics",
                      Icons.bar_chart,
                      Colors.indigo,
                      const Placeholder(),
                    ),

                    _featureCard(
                      context,
                      "Contact Submissions",
                      Icons.contact_mail,
                      Colors.red,
                      const Placeholder(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  static Widget _statCard(String title, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }


  static Widget _featureCard(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      Widget screen,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}