

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/view/widget/edit_profile.dart';
import 'package:z_organizer/view/widget/profile/about_us.dart';
import 'package:z_organizer/view/widget/profile/privacy_policy.dart';
import 'package:z_organizer/view/widget/profile/terms_condition.dart';


final currentUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Provider for user profile data from Firestore
final userProfileProvider = StreamProvider.family<Map<String, dynamic>?, String?>((ref, userId) {
  if (userId == null) return Stream.value(null);
  
  return FirebaseFirestore.instance
      .collection('organizers')
      .doc(userId)
      .snapshots()
      .map((doc) {
        if (doc.exists) {
          return doc.data();
        }
        return null;
      });
});

// Combined provider that merges Firebase Auth and Firestore data
final combinedUserDataProvider = Provider<AsyncValue<Map<String, dynamic>?>>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  
  return userAsync.when(
    data: (user) {
      if (user == null) return const AsyncData(null);
      
      final profileAsync = ref.watch(userProfileProvider(user.uid));
      return profileAsync.when(
        data: (firestoreData) {
          // Combine Firebase Auth data with Firestore data
          final combinedData = <String, dynamic>{
            'displayName': firestoreData?['displayName'] ?? user.displayName ?? 'Anonymous',
            'email': user.email ?? 'No email',
            'photoUrl': firestoreData?['photoUrl'] ?? user.photoURL,
            'bio': firestoreData?['bio'] ?? '',
            'uid': user.uid,
          };
          return AsyncData(combinedData);
        },
        loading: () => const AsyncLoading(),
        error: (error, stack) {
          // Fallback to Firebase Auth data on error
          final fallbackData = <String, dynamic>{
            'displayName': user.displayName ?? 'Anonymous',
            'email': user.email ?? 'No email',
            'photoUrl': user.photoURL,
            'bio': '',
            'uid': user.uid,
          };
          return AsyncData(fallbackData);
        },
      );
    },
    loading: () => const AsyncLoading(),
    error: (error, stack) => AsyncError(error, stack),
  );
});

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsync = ref.watch(combinedUserDataProvider);
    final currentUser = ref.watch(currentUserProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.deepPurple.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () async {
                // Navigate to edit page and refresh data when returning
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrganizerEditProfilePage(),
                  ),
                );
                
                // Invalidate providers to refresh data
                ref.invalidate(userProfileProvider);
                ref.invalidate(combinedUserDataProvider);
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.deepPurple.shade50.withOpacity(0.3),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Enhanced Profile Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: userDataAsync.when(
                      data: (userData) {
                        if (userData == null) {
                          return const Column(
                            children: [
                              Icon(Icons.person, size: 100),
                              SizedBox(height: 16),
                              Text('No user data available'),
                            ],
                          );
                        }
                        
                        return Column(
                          children: [
                            // Profile Avatar with enhanced styling
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple.withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.deepPurple.shade200,
                                child: _buildProfileImage(userData['photoUrl']),
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // User Name
                            Text(
                              userData['displayName'] ?? 'Anonymous',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            
                            // User Email with styling
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                userData['email'] ?? 'No email',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            
                            // Bio Section
                            if (userData['bio'] != null && 
                                userData['bio'].toString().isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  userData['bio'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.deepPurple.shade700,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                      loading: () => Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: 150,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 200,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      error: (error, stack) => Column(
                        children: [
                          Icon(Icons.error, size: 100, color: Colors.red.shade400),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading profile',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              ref.invalidate(combinedUserDataProvider);
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Enhanced Logout Button
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logged out')),
                          );
                        }
                      },
                      child: const Text(
                        'Log Out',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Enhanced Settings Section with Navigation
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSettingsItem(
                          context: context,
                          icon: Icons.info_outline,
                          iconColor: Colors.blue.shade600,
                          backgroundColor: Colors.blue.shade50,
                          title: 'About Us',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AboutUsScreen()),
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey.shade200),
                        _buildSettingsItem(
                          context: context,
                          icon: Icons.description_outlined,
                          iconColor: Colors.orange.shade600,
                          backgroundColor: Colors.orange.shade50,
                          title: 'Terms and Conditions',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TermsAndConditions()),
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey.shade200),
                        _buildSettingsItem(
                          context: context,
                          icon: Icons.privacy_tip_outlined,
                          iconColor: Colors.green.shade600,
                          backgroundColor: Colors.green.shade50,
                          title: 'Privacy Policy',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => PrivacyPolicy()),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Version Footer
                  Text(
                    'Version 1.0',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(String? photoUrl) {
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          photoUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.person,
              size: 50,
              color: Colors.deepPurple.shade700,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      );
    } else {
      return Icon(
        Icons.person,
        size: 50,
        color: Colors.deepPurple.shade700,
      );
    }
  }

  Widget _buildSettingsItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple.shade700,
          fontSize: 16,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey.shade400,
      ),
      onTap: onTap,
    );
  }
}

// Remove the SectionCard class as it's not being used
class SectionCard extends StatelessWidget {
  final String title;
  final String content;
  final String? linkLabel;
  final VoidCallback? onLinkTap;

  const SectionCard({
    super.key,
    required this.title,
    required this.content,
    this.linkLabel,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white.withOpacity(0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.deepPurple.shade50),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              content,
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 15,
              ),
            ),
            if (linkLabel != null && onLinkTap != null)
              TextButton(
                onPressed: onLinkTap,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.deepPurple,
                  padding: EdgeInsets.zero,
                ),
                child: Text(linkLabel!),
              ),
          ],
        ),
      ),
    );
  }
}