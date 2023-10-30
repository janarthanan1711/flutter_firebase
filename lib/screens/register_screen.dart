import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/home_screen.dart';
import 'package:flutter_firebase/screens/login_screen.dart';
import 'package:flutter_firebase/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Screen"),
        centerTitle: true,
        backgroundColor: Colors.orange,
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
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                  labelText: "Confirm Password", border: OutlineInputBorder()),
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
                  child:isLoading ? CircularProgressIndicator() : Text("Submit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                ),
              ),
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                if(emailController.text == "" || passwordController.text==""){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required!"),backgroundColor: Colors.red,));
                }else if(passwordController.text != confirmPasswordController.text){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("password does not match"),backgroundColor: Colors.red,));
                }else{
                  User? result = await AuthService().register(emailController.text, passwordController.text,context);
                  if(result != null){
                    print("Success");
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen(result)), (route) => false);
                  }
                }
                setState(() {
                  isLoading = false;
                  emailController.clear();
                  passwordController.clear();
                  confirmPasswordController.clear();
                });
              },
            ),
            const SizedBox(height: 20,),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
            }, child: const Text("Already have an account? Login here",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 14),))
          ],
        ),
      ),
    );
  }
}
