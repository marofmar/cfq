import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cfq/firebase_options.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool _isUploading = false;
  String _statusMessage = '';

  Future<void> uploadRecordsByDate() async {
    try {
      setState(() {
        _isUploading = true;
        _statusMessage = 'Uploading...';
      });

      final firestore = FirebaseFirestore.instance;
      final jsonString = await rootBundle.loadString(
          '/Users/yujinchung/Projects/cfq/mock_data/mock_records.json');
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      final recordsCollection = firestore.collection('records');

      for (var entry in jsonData.entries) {
        final date = entry.key;
        final records = entry.value;
        final docRef = recordsCollection.doc(date);
        await docRef.set(records);
      }

      setState(() {
        _statusMessage = 'Data successfully uploaded to Firestore!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error occurred: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Records'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isUploading ? null : uploadRecordsByDate,
              child: const Text('Upload Data'),
            ),
            const SizedBox(height: 20),
            Text(_statusMessage),
          ],
        ),
      ),
    );
  }
}
