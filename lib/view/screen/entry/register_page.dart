// import 'package:flutter/material.dart';
// import 'package:glassmorphism/glassmorphism.dart';
// import 'package:z_organizer/constant/color.dart';
// import 'package:z_organizer/view/widget/custom_appbar.dart';

// class RegisterForm extends StatelessWidget {
//   const RegisterForm({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title:  'Register Account',
       
//       ),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               AppColors.second,
//               Colors.white,
              
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             child: GlassmorphicContainer(
//               width: MediaQuery.of(context).size.width * 0.9,
//               height: MediaQuery.of(context).size.height * 0.8,
//               borderRadius: 20,
//               blur: 20,
//               alignment: Alignment.center,
//               border: 2,
//               borderGradient: const LinearGradient(
//                 colors: [
//                   Colors.white70,
//                   Colors.white10,
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               linearGradient: const LinearGradient(
//                 colors: [
//                   Colors.white24,
//                   Colors.white10,
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(15.5),
//                 child: Form(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
                      
//                       TextFormField(
//                         decoration: const InputDecoration(
//                           labelText: 'Full Name',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 16.0),

                  
//                       TextFormField(
//                         decoration: const InputDecoration(
//                           labelText: 'Email',
//                           border: OutlineInputBorder(),
//                         ),
//                         keyboardType: TextInputType.emailAddress,
//                       ),
//                       const SizedBox(height: 16.0),

                     
//                       TextFormField(
//                         decoration: const InputDecoration(
//                           labelText: 'Phone Number',
//                           border: OutlineInputBorder(),
//                         ),
//                         keyboardType: TextInputType.phone,
//                       ),
//                       const SizedBox(height: 16.0),

                     
//                       DropdownButtonFormField<String>(
//                         decoration: const InputDecoration(
//                           labelText: 'Organizer Type',
//                           border: OutlineInputBorder(),
//                         ),
//                         items: [
//                           DropdownMenuItem(
//                             value: 'Type A',
//                             child: Text('Type A'),
//                           ),
//                           DropdownMenuItem(
//                             value: 'Type B',
//                             child: Text('Type B'),
//                           ),
//                           DropdownMenuItem(
//                             value: 'Type C',
//                             child: Text('Type C'),
//                           ),
//                         ],
//                         onChanged: (value) {
                        
//                         },
//                       ),
//                       const SizedBox(height: 16.0),

                      
//                       TextFormField(
//                         decoration: const InputDecoration(
//                           labelText: 'Organization Name',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 16.0),

                     
//                       TextFormField(
//                         decoration: const InputDecoration(
//                           labelText: 'Organization Address',
//                           border: OutlineInputBorder(),
//                         ),
//                         maxLines: 3,
//                       ),
//                       const SizedBox(height: 18.0),

                      
//                       ElevatedButton.icon(
//                         onPressed: () {
                        
//                         },
//                         icon: const Icon(Icons.upload_file,color: Colors.white),
//                         label: const Text('Upload Document',style: TextStyle(color: Colors.white),),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary,
                          
//                         ),
//                       ),
//                       const SizedBox(height: 17.5),

                      
//                       ElevatedButton(
//                         onPressed: () {
                         
//                         },
//                         child: const Text('Register',style: const TextStyle(color: Colors.white)),
//                         style: ElevatedButton.styleFrom(
                        
//                         backgroundColor: AppColors.primary,
                          
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:z_organizer/constant/color.dart';
import 'package:z_organizer/view/widget/custom_appbar.dart';
import 'package:z_organizer/view/widget/custom_feild.dart';
import 'package:z_organizer/view/widget/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Register Account',
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.second,
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: GlassmorphicContainer(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              borderRadius: 20,
              blur: 20,
              alignment: Alignment.center,
              border: 2,
              borderGradient: const LinearGradient(
                colors: [
                  Colors.white70,
                  Colors.white10,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              linearGradient: const LinearGradient(
                colors: [
                  Colors.white24,
                  Colors.white10,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              child:  Padding(
                padding: EdgeInsets.all(15.5),
                child: RegisterFormWidget(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
