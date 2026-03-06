import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/seller.dart';

class ApprovalsScreen extends StatefulWidget {
  const ApprovalsScreen({Key? key}) : super(key: key);

  @override
  State<ApprovalsScreen> createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends State<ApprovalsScreen>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  final List<String> statuses = ['pending', 'approved', 'rejected'];

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Stream<List<Seller>> _getSellers(String status) {
    return FirebaseFirestore.instance
        .collection('sellers')
        .where('approvalStatus', isEqualTo: status)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Seller.fromMap(doc.data(), doc.id)).toList());
  }

  List<Seller> _filterSellers(List<Seller> sellers) {
    if (_searchQuery.isEmpty) return sellers;

    final query = _searchQuery.toLowerCase();

    return sellers.where((seller) {
      return seller.id.toLowerCase().contains(query) ||
          seller.sellerName.toLowerCase().contains(query) ||
          seller.businessName.toLowerCase().contains(query) ||
          seller.email.toLowerCase().contains(query) ||
          seller.phone.toLowerCase().contains(query) ||
          seller.gstNumber.toLowerCase().contains(query) ||
          seller.aadharNumber.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _confirmStatusChange(Seller seller, String newStatus) async {

    if (newStatus == 'rejected') {

      final TextEditingController reasonController = TextEditingController();

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Reject Seller"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Please enter rejection reason"),
              const SizedBox(height: 12),
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Enter reason...",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {

                if (reasonController.text.trim().isEmpty) return;

                Navigator.pop(context);

                await FirebaseFirestore.instance
                    .collection('sellers')
                    .doc(seller.id)
                    .update({
                  'approvalStatus': 'rejected',
                  'rejectionReason': reasonController.text.trim(),
                });
              },
              child: const Text("Reject"),
            )
          ],
        ),
      );

    } else {

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Approve Seller"),
          content: const Text("Are you sure you want to approve this seller?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                Navigator.pop(context);

                await FirebaseFirestore.instance
                    .collection('sellers')
                    .doc(seller.id)
                    .update({
                  'approvalStatus': 'approved',
                  'rejectionReason': '',
                });
              },
              child: const Text("Approve"),
            )
          ],
        ),
      );
    }
  }

  void _showDetails(Seller seller) {
    DateTime? created = seller.createdAt;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  seller.businessName,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                _infoRow("Client ID", seller.id),
                _infoRow("Seller Name", seller.sellerName),
                _infoRow("Email", seller.email),
                _infoRow("Phone", seller.phone),
                _infoRow("Address", seller.businessAddress),
                _infoRow("GST", seller.gstNumber),
                _infoRow("Aadhar", seller.aadharNumber),

                const SizedBox(height: 10),

                Text(
                  "Created At: ${created != null ? DateFormat('dd MMM yyyy, hh:mm a').format(created) : 'N/A'}",
                ),

                if (seller.approvalStatus == 'rejected' &&
                    seller.rejectionReason.isNotEmpty) ...[
                  const SizedBox(height: 15),
                  const Text(
                    "Rejection Reason",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    seller.rejectionReason,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],

                const SizedBox(height: 25),

                const Text(
                  "Documents",
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                if (seller.selfieUrl.isNotEmpty)
                  _documentImage("Selfie", seller.selfieUrl),
                if (seller.aadharFrontUrl.isNotEmpty)
                  _documentImage("Aadhar Front", seller.aadharFrontUrl),
                if (seller.aadharBackUrl.isNotEmpty)
                  _documentImage("Aadhar Back", seller.aadharBackUrl),
                if (seller.gstCertificateUrl.isNotEmpty)
                  _documentImage("GST Certificate", seller.gstCertificateUrl),

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text("$title: $value"),
    );
  }

  Widget _documentImage(String title, String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            url,
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
            const Text("Image not available"),
          ),
        ),
      ],
    );
  }

  Widget _buildSellerCard(Seller seller) {
    return Card(
      elevation: 5,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              seller.businessName,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text("Owner: ${seller.sellerName}"),
            Text("Email: ${seller.email}"),
            Text("Phone: ${seller.phone}"),
            const SizedBox(height: 14),

            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey),
                  onPressed: () => _showDetails(seller),
                  child: const Text("View Details"),
                ),

                if (seller.approvalStatus == 'pending') ...[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green),
                    onPressed: () =>
                        _confirmStatusChange(seller, 'approved'),
                    child: const Text("Approve"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red),
                    onPressed: () =>
                        _confirmStatusChange(seller, 'rejected'),
                    child: const Text("Reject"),
                  ),
                ],

                if (seller.approvalStatus == 'approved')
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red),
                    onPressed: () =>
                        _confirmStatusChange(seller, 'rejected'),
                    child: const Text("Reject"),
                  ),

                if (seller.approvalStatus == 'rejected')
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green),
                    onPressed: () =>
                        _confirmStatusChange(seller, 'approved'),
                    child: const Text("Approve"),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String status) {
    return StreamBuilder<List<Seller>>(
      stream: _getSellers(status),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No Sellers Found"));
        }

        final filteredList = _filterSellers(snapshot.data!);

        if (filteredList.isEmpty) {
          return const Center(child: Text("No Matching Results"));
        }

        return ListView(
          children:
          filteredList.map((seller) => _buildSellerCard(seller)).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Client Approvals"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Approved"),
            Tab(text: "Rejected"),
          ],
        ),
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search client...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
                    : null,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTab(statuses[0]),
                _buildTab(statuses[1]),
                _buildTab(statuses[2]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}