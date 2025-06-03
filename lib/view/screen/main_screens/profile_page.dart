
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:z_organizer/view/widget/edit_profile.dart';

// class UserProfileScreen extends StatelessWidget {
//   const UserProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         backgroundColor: Colors.deepPurple.shade600,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         actions: [InkWell(onTap: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => OrganizerEditProfilePage()));
//         },
//           child: Icon(Icons.edit, color: Colors.white))],
//       ),
//       backgroundColor: Colors.white,
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.white,
//               Colors.deepPurple.shade50.withOpacity(0.3),
//             ],
//           ),
//         ),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Profile Avatar
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundColor: Colors.deepPurple.shade200,
//                     child: user?.photoURL != null
//                         ? ClipOval(
//                             child: Image.network(
//                               user!.photoURL!,
//                               width: 100,
//                               height: 100,
//                               fit: BoxFit.cover,
//                             ),
//                           )
//                         : Icon(
//                             Icons.person,
//                             size: 50,
//                             color: Colors.deepPurple.shade700,
//                           ),
//                   ),
//                   const SizedBox(height: 16),
//                   // User Name
//                   Text(
//                     user?.displayName ?? 'Anonymous',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.deepPurple.shade700,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   // User Email
//                   Text(
//                     user?.email ?? 'No email',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   const SizedBox(height: 32),
//                   // Logout Button
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.deepPurple.shade600,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 32,
//                         vertical: 12,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     onPressed: () async {
//                       await FirebaseAuth.instance.signOut();
//                       // TODO: Navigate to login screen
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Logged out')),
//                       );
//                     },
//                     child: const Text(
//                       'Log Out',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                   const SizedBox(height: 40),

//                   Column(
//   crossAxisAlignment: CrossAxisAlignment.stretch,
//   children: [
//     ExpansionTile(
//       title: Text(
//         'About Us',
//         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
//       ),
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           child: Text(
//             'We are committed to providing the best service to our users. Our mission is to create seamless and user-friendly experiences.',
//           ),
//         ),
//       ],
//     ),
//     ExpansionTile(
//       title: Text(
//         'Terms and Conditions',
//         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
//       ),
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           child: Text(
//             'By using this service, you agree to our terms and conditions. Please read them carefully before proceeding.',
//           ),
//         ),
//       ],
//     ),
//     ExpansionTile(
//       title: Text(
//         'Privacy Policy',
//         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
//       ),
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           child: Text(
//             'Your privacy is important to us. We ensure that your data is handled securely and responsibly.',
//           ),
//         ),
//       ],
//     ),
//   ],
// ),

//                  const  SizedBox(height: 24),

//                   // Version Footer
//                   Text(
//                     'Version 1.0',
//                     style: TextStyle(
//                       color: Colors.grey.shade500,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SectionCard extends StatelessWidget {
//   final String title;
//   final String content;
//   final String? linkLabel;
//   final VoidCallback? onLinkTap;

//   const SectionCard({
//     super.key,
//     required this.title,
//     required this.content,
//     this.linkLabel,
//     this.onLinkTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0,
//       color: Colors.white.withOpacity(0.95),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//         side: BorderSide(color: Colors.deepPurple.shade50),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(14.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.deepPurple.shade700,
//                 fontSize: 18,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               content,
//               style: TextStyle(
//                 color: Colors.grey.shade800,
//                 fontSize: 15,
//               ),
//             ),
//             if (linkLabel != null && onLinkTap != null)
//               TextButton(
//                 onPressed: onLinkTap,
//                 style: TextButton.styleFrom(
//                   foregroundColor: Colors.deepPurple,
//                   padding: EdgeInsets.zero,
//                 ),
//                 child: Text(linkLabel!),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:z_organizer/view/widget/edit_profile.dart';
import 'package:z_organizer/view/widget/profile/about_us.dart';
import 'package:z_organizer/view/widget/profile/privacy_policy.dart';
import 'package:z_organizer/view/widget/profile/terms_condition.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurple.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrganizerEditProfilePage()),
                );
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
                    child: Column(
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
                            child: user?.photoURL != null
                                ? ClipOval(
                                    child: Image.network(
                                      user!.photoURL!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.deepPurple.shade700,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // User Name
                        Text(
                          user?.displayName ?? 'Anonymous',
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
                            user?.email ?? 'No email',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Logged out')),
                        );
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
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade600,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            'About Us',
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
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) =>  AboutUsScreen()),
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey.shade200),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.description_outlined,
                              color: Colors.orange.shade600,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            'Terms and Conditions',
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
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TermsAndConditions()),
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey.shade200),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.privacy_tip_outlined,
                              color: Colors.green.shade600,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            'Privacy Policy',
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
}

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
