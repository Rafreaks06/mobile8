import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobile8/fcm_token_card.dart';

class UserInfoScreen extends StatefulWidget {
  final User user;

  const UserInfoScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  bool _isSubscribed = true; // aplikasi sudah auto-subscribe topic 'kelas' saat start

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _subscribe() async {
    await FirebaseMessaging.instance.subscribeToTopic('kelas');
    setState(() {
      _isSubscribed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard User'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.account_circle, size: 100, color: Colors.blue),
                const SizedBox(height: 24),
                const Text(
                  'Login Berhasil!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('UID: ${widget.user.uid}',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Email: ${widget.user.email ?? "Tidak ada email"}'),
                        const SizedBox(height: 8),
                        Text('Email Terverifikasi: ${widget.user.emailVerified ? "Ya" : "Tidak"}'),
                        const SizedBox(height: 8),
                        Text('Terakhir Login: ${widget.user.metadata.lastSignInTime.toString()}'),
                        const SizedBox(height: 16),
                        const FcmTokenCard(), // Menampilkan FCM Token
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Status topic kelas: ${_isSubscribed ? 'Berlangganan' : 'Berhenti berlangganan'}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _subscribe,
                  child: const Text('Subscribe Topic Kelas'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
