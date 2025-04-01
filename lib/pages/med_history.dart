import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MedHistory extends StatelessWidget {
  final String patientId = "P40";

  const MedHistory({super.key}); // Change this dynamically if needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Medical History")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('medHistory')
            .where('pid', isEqualTo: patientId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No records found"));
          }

          var documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var data = documents[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['doctor'] ?? 'Doctor'),
                subtitle: Text("Date: ${data['date'] ?? 'Unknown Date'}"),
                leading: Icon(Icons.medical_services, color: Colors.blue),
                tileColor: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.all(10),
                onTap: () {
                  // You can navigate to a detailed page if needed
                },
              );
            },
          );
        },
      ),
    );
  }
}