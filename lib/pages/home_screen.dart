import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hptracker/constants/colors.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String patientId = "P40"; // Change dynamically if needed
  String patientName = "Patient"; // Default value

  @override
  void initState() {
    super.initState();
    fetchPatientName();
  }

  Future<void> fetchPatientName() async {
    try {
      DocumentSnapshot patientDoc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(patientId)
          .get();

      if (patientDoc.exists) {
        setState(() {
          patientName = patientDoc['name'] ?? "Patient";
        });
      }
    } catch (e) {
      print("Error fetching patient name: $e");
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
          toolbarHeight: height * 0.08,
          backgroundColor: Colors.white,
          title: Text("HP Tracker", style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 1,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/images/logo2.jpeg",
              fit: BoxFit.contain,
              height: height * 0.06, // Adjust height dynamically
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/profileScreen");
              },
              icon: Icon(
                Icons.account_circle,
                size: width * 0.1,
                color: accent,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Section
              Text(
                "Hello, $patientName 👋",
                style: TextStyle(
                  fontSize: width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),

              Text(
                "Your Medical History",
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 10),

              // Medical History List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('medHistory')
                      .where('pid', isEqualTo: patientId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("No medical records found"));
                    }

                    var documents = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        var data = documents[index].data() as Map<String, dynamic>;

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(12),
                            title: Text(
                              data['doctor'] ?? 'Unknown Doctor',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.045,
                              ),
                            ),
                            subtitle: Text(
                              "Date: ${data['date'] ?? 'Unknown Date'}",
                              style: TextStyle(color: Colors.black54),
                            ),
                            leading: Icon(Icons.medical_services, color: Colors.blue),
                            tileColor: Colors.white,
                            onTap: () {
                              // Handle tap event if needed
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
