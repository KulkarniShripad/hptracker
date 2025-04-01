import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hptracker/constants/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? patientData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPatientData();
  }

  Future<void> fetchPatientData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('patients')
          .doc('P40')
          .get();
      if (doc.exists) {
        setState(() {
          patientData = doc.data() as Map<String, dynamic>?;
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching data: ${e.toString()}")),
      );
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          title: const Text("Personal Info", style: TextStyle(fontSize: 20)),
          elevation: 0,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : patientData == null
                ? const Center(child: Text("No data found"))
                : Padding(
                    padding: EdgeInsets.all(width * 0.045),
                    child: ListView(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: width * 0.14,
                          child: Icon(Icons.person, size: width * 0.2, color: Colors.black),
                        ),
                        SizedBox(height: width * 0.045),
                        Center(
                          child: Text(
                            patientData!["name"] ?? "Unknown",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        SizedBox(height: height * 0.026),
                        _buildProfileInfo(Icons.phone, "Mobile No.", patientData!["mobile"] ?? "N/A", height, width),
                        _buildProfileInfo(Icons.email, "Email Id", patientData!["email"] ?? "N/A", height, width),
                        _buildProfileInfo(
                            patientData!["gender"] == "Male" ? Icons.man : Icons.woman_rounded,
                            "Gender",
                            patientData!["gender"] ?? "N/A",
                            height,
                            width),
                        _buildProfileInfo(Icons.cake, "Age", patientData!["age"]?.toString() ?? "N/A", height, width),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildProfileInfo(IconData icon, String title, String value, double height, double width) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: width * 0.023),
      child: Container(
        padding: EdgeInsets.all(height * 0.013),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: width * 0.07, color: accent),
            SizedBox(width: width * 0.028),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    value,
                    softWrap: true,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}