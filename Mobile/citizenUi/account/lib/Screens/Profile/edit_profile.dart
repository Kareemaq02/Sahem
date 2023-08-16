// // ignore_for_file: library_private_types_in_public_api, deprecated_member_use// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, avoid_print

// import 'package:account/Screens/Profile/profile1.dart';
// import 'package:flutter/material.dart';
// import 'package:account/API/edit_user_info_request.dart';

// class EditProfilePage extends StatefulWidget {
//  final String username;
//  final  String email;
//  final  String phone;
//  // String location;
//  // String password;
  


//    const EditProfilePage({Key? key,required this.username,required this.email,required this.phone}) : super(key: key); // Added "Key?" type to the key parameter

//   @override
//   _EditProfilePageState createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   bool showPassword = false;
//   TextEditingController newUsername = TextEditingController();
//   TextEditingController newEmail = TextEditingController();
//   TextEditingController newPhone = TextEditingController();
//   TextEditingController newLocation = TextEditingController();
//   TextEditingController newPassword = TextEditingController();
   

//   @override
//   Widget build(BuildContext context) {
//     print(newUsername.text);
   
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         elevation: 1,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Color(0xff6f407d),
//           ),
//           onPressed: () {
//               Navigator.of(context).push(MaterialPageRoute(
//                 builder: (BuildContext context) => const XDProfile()));
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(
//               Icons.settings,
//               color: Color(0xff6f407d),
//             ),
//             onPressed: () {
            
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
//         child: GestureDetector(
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//           child: ListView(
//             children: [
//               const Text(
//                 "Edit Profile",
//                 style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
//               ),
         
//               const SizedBox(
//                 height: 35,
//               ),
//               buildTextField("Username", widget.username, false, newUsername),
//               buildTextField("E-mail", "ruba@gmail.com", false, newEmail),
//               buildTextField("Phone Number",widget.phone, false, newPhone),
//               buildTextField("Password", "********", true, newPassword),
//               buildTextField("Location", "Amman-Jordan", false, newLocation),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   OutlinedButton(
//                     onPressed: () {
//                        Navigator.of(context).push(MaterialPageRoute(
//                       builder: (BuildContext context) => const XDProfile()));
//                     },
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(horizontal: 50),
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                       ),
//                     ),
//                     child: const Text(
//                       "CANCEL",
//                       style: TextStyle(
//                         fontSize: 14,
//                         letterSpacing: 2.2,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       EditInfo edit = EditInfo();
//                       edit.updateAccount(
//                         newUsername.text,
//                         newEmail.text,
//                         newPassword.text,
//                         newPhone.text,
//                         newLocation.text,
//                       );
//                        print(newPhone.text);
//                  Navigator.of(context).push(MaterialPageRoute(
//                 builder: (BuildContext context) => const XDProfile()));
//                     },
//                     style: ElevatedButton.styleFrom(primary: const Color(0xff6f407d),),
//                     child: const Text(
//                       "SAVE",
//                       style: TextStyle(
//                         fontSize: 14,
//                         letterSpacing: 2.2,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildTextField(
//     String labelText,
//     String placeholder,
//     bool isPasswordTextField,
//     TextEditingController textController,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 35.0),
//       child: TextField(
//         controller: textController,
//         obscureText: isPasswordTextField ? showPassword : false,
//         decoration: InputDecoration(
//           suffixIcon: isPasswordTextField
//               ? IconButton(
//                   onPressed: () {
//                     setState(() {
//                       showPassword = !showPassword;
//                     });
//                   },
//                   icon: const Icon(
//                     Icons.remove_red_eye,
//                     color: Colors.grey,
//                   ),
//                 )
//               : null,
//           contentPadding: const EdgeInsets.only(bottom: 3),
//           labelText: labelText,
//           floatingLabelBehavior: FloatingLabelBehavior.always,
//           hintText: placeholder,
//           hintStyle: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//       ),
//     );
//   }
// }
