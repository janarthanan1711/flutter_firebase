import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/register_screen.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  labelText: "Email", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                  labelText: "Password", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              child: Container(
                color: Colors.orange,
                height: 50,
                width: MediaQuery.of(context).size.width,
                child:  Center(
                  child:isLoading ? CircularProgressIndicator(): Text("Submit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                ),
              ),
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                if(emailController.text == "" || passwordController.text==""){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required!"),backgroundColor: Colors.red,));
                }else{
                  User? result = await AuthService().login(emailController.text, passwordController.text,context);
                  if(result != null){
                    print("Success");
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen(result)), (route) => false);
                  }
                }
                setState(() {
                  isLoading = false;
                  emailController.clear();
                  passwordController.clear();
                });
              },
            ),
            const SizedBox(height: 20,),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
            }, child: const Text("Dont have an Account? Register here",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 14),))
          ],
        ),
      ),
    );
  }
}
