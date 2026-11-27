import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Kartu untuk menampilkan FCM Token + tombol salin.
/// Token ini yang nanti ditempel di Postman.
/// Token juga disimpan ke Firestore (users/{uid}) setelah login.
class FcmTokenCard extends StatefulWidget {
  const FcmTokenCard({super.key});

  @override
  State<FcmTokenCard> createState() => _FcmTokenCardState();
}

class _FcmTokenCardState extends State<FcmTokenCard> {
  late final Future<String?> _tokenFuture;

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    _tokenFuture = FirebaseMessaging.instance.getToken().then((token) async {
      if (token != null) {
        await _saveTokenToFirestore(token);
      }
      return token;
    });
  }

  Future<void> _saveTokenToFirestore(String token) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance.collection('users').doc(uid).set(
      {'fcmToken': token, 'updatedAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _tokenFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final token = snapshot.data ?? 'Token tidak tersedia';
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FCM Token:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SelectableText(token, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Salin Token'),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: token));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Token disalin!')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

