import 'package:apnamall_ecommerce_app/config/app_routes.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;
  bool _isObscured = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Login to access your account",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Poppins",
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              DefaultTabController(
                length: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ClipRRect(
                        // <- add this
                        borderRadius: BorderRadius.circular(25),
                        child: Material(
                          elevation: 0,
                          color: Colors.transparent,
                          child: TabBar(
                            onTap: (index) {
                            
                            },
                            indicator: BoxDecoration(
                              color: Color(0xffff650e),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorWeight: 3, // ya jitna chahiye
                            indicatorColor: Colors.transparent,
                            indicatorPadding: EdgeInsets.zero,
                            labelPadding: EdgeInsets.zero,
                            labelStyle: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.black,
                            tabs: const [
                              Tab(text: "Phone Number"),
                              Tab(text: "Email"),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      height: 75,
                      child: TabBarView(
                        children: [
                          _buildTextField(
                            "Phone Number",
                            Icons.phone,
                            false,
                            phoneController,
                          ),
                          _buildTextField(
                            "Email",
                            Icons.email,
                            false,
                            emailController,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildTextField("Password", Icons.lock, true, passwordController),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        activeColor: Color(0xffff650e),
                        onChanged: (bool? value) {
                          setState(() {
                            rememberMe = value ?? false;
                          });
                        },
                      ),
                      const Text(
                        "Remember me",
                        style: TextStyle(fontSize: 12, fontFamily: "Poppins"),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forget password?",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: Color(0xffff650e),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.routeMain);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffff650e),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Log In",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Or Sign In With",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialButton("assets/images/googles.png", Colors.red),
                  const SizedBox(width: 20),
                  _socialButton("assets/images/communication.png", Colors.blue),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t have an account?",
                    style: TextStyle(fontSize: 12, fontFamily: "Poppins"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.routeSignup);
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        color: Color(0xffff650e),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon,
    bool isPassword,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 45,
          margin: EdgeInsets.only(top: 5),
          child: TextField(
            controller: controller,
            obscureText: isPassword ? _isObscured : false,
            onChanged: (value) {},
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: Colors.grey.shade600,
                fontFamily: "Poppins",
                fontSize: 14,
              ),
              prefixIcon: Icon(icon, color: Colors.grey.shade600),
              suffixIcon: Icon(
                _isObscured ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade600,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade200 ,width: 0.1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade200, width: 0.1),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _socialButton(String image, Color color) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Image.asset(image, fit: BoxFit.contain, height: 25, width: 25),
    );
  }
}
