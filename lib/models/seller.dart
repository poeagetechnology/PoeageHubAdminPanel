import 'package:cloud_firestore/cloud_firestore.dart';

class Seller {
  final String id;
  final String sellerName;
  final String businessName;
  final String businessAddress;
  final String phone;
  final String email;
  final String gstNumber;
  final String aadharNumber;

  final String selfieUrl;
  final String aadharFrontUrl;
  final String aadharBackUrl;
  final String gstCertificateUrl;

  final String approvalStatus; // pending / approved / rejected
  final DateTime? createdAt;
  final String rejectionReason;

  Seller({
    required this.id,
    required this.sellerName,
    required this.businessName,
    required this.businessAddress,
    required this.phone,
    required this.email,
    required this.gstNumber,
    required this.aadharNumber,
    required this.selfieUrl,
    required this.aadharFrontUrl,
    required this.aadharBackUrl,
    required this.gstCertificateUrl,
    required this.approvalStatus,
    this.createdAt,
    this.rejectionReason = '',
  });


  factory Seller.fromMap(Map<String, dynamic> map, String docId) {
    return Seller(
      id: docId,
      sellerName: map['sellerName'] ?? '',
      businessName: map['businessName'] ?? '',
      businessAddress: map['businessAddress'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      gstNumber: map['gstNumber'] ?? '',
      aadharNumber: map['aadharNumber'] ?? '',
      selfieUrl: map['selfieUrl'] ?? '',
      aadharFrontUrl: map['aadharFrontUrl'] ?? '',
      aadharBackUrl: map['aadharBackUrl'] ?? '',
      gstCertificateUrl: map['gstCertificateUrl'] ?? '',
      approvalStatus: map['approvalStatus'] ?? 'pending',


      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      rejectionReason: map['rejectionReason'] ?? '',
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'sellerName': sellerName,
      'businessName': businessName,
      'businessAddress': businessAddress,
      'phone': phone,
      'email': email,
      'gstNumber': gstNumber,
      'aadharNumber': aadharNumber,
      'selfieUrl': selfieUrl,
      'aadharFrontUrl': aadharFrontUrl,
      'aadharBackUrl': aadharBackUrl,
      'gstCertificateUrl': gstCertificateUrl,
      'approvalStatus': approvalStatus,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'rejectionReason': rejectionReason,
    };
  }

  Seller copyWith({
    String? approvalStatus,
    String? rejectionReason,
  }) {
    return Seller(
      id: id,
      sellerName: sellerName,
      businessName: businessName,
      businessAddress: businessAddress,
      phone: phone,
      email: email,
      gstNumber: gstNumber,
      aadharNumber: aadharNumber,
      selfieUrl: selfieUrl,
      aadharFrontUrl: aadharFrontUrl,
      aadharBackUrl: aadharBackUrl,
      gstCertificateUrl: gstCertificateUrl,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      createdAt: createdAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}