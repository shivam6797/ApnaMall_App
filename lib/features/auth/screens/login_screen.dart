import 'package:apnamall_ecommerce_app/config/app_routes.dart';
import 'package:apnamall_ecommerce_app/core/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _phoneC = TextEditingController();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  bool _obscure = true;
  bool _remember = false;
  bool _loading = false;

  String? _phoneErr, _emailErr, _passErr;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        if (_tabController.index == 0) {
          _emailC.clear();
        } else {
          _phoneC.clear();
        }
      }
    });

    _phoneC.addListener(() {
      setState(() => _phoneErr = Validators.validatePhone(_phoneC.text));
    });
    _emailC.addListener(() {
      setState(() => _emailErr = Validators.validateEmail(_emailC.text));
    });
    _passC.addListener(() {
      setState(() => _passErr = Validators.validatePassword(_passC.text));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneC.dispose();
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (ctx, state) {
        setState(() => _loading = state is AuthLoading);

        if (state is AuthSuccess) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Login successfully!'),
            ),
          );
          Navigator.pushNamedAndRemoveUntil(
            ctx,
            AppRoutes.routeMain,
            (_) => false,
          );
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(backgroundColor: Colors.red, content: Text(state.message)),
          );
        }
      },
      builder: (ctx, _) => SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
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
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Login to access your account",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
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
                            borderRadius: BorderRadius.circular(25),
                            child: Material(
                              color: Colors.transparent,
                              child: TabBar(
                                controller: _tabController,
                                indicator: BoxDecoration(
                                  color: const Color(0xffff650e),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                indicatorSize: TabBarIndicatorSize.tab,
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
                            controller: _tabController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _buildInputField(
                                controller: _phoneC,
                                label: "Phone Number",
                                icon: Icons.phone,
                                keyboard: TextInputType.phone,
                                validator: Validators.validatePhone,
                                errorText: _phoneErr,
                              ),
                              _buildInputField(
                                controller: _emailC,
                                label: "Email",
                                icon: Icons.email,
                                keyboard: TextInputType.emailAddress,
                                validator: Validators.validateEmail,
                                errorText: _emailErr,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  _buildPasswordField(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _remember,
                            activeColor: const Color(0xffff650e),
                            onChanged: (v) => setState(() => _remember = v!),
                          ),
                          const Text(
                            "Remember me",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forget password?",
                          style: TextStyle(
                            color: Color(0xffff650e),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  _buildLoginButton(ctx),

                  const SizedBox(height: 20),
                  const Text(
                    "Or Sign In With",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton("assets/images/googles.png"),
                      const SizedBox(width: 20),
                      _socialButton("assets/images/communication.png"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don’t have an account?",
                        style: TextStyle(fontSize: 12),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(ctx, AppRoutes.routeSignup);
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xffff650e),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType keyboard,
    required String? Function(String?) validator,
    String? errorText,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 62,
        margin: EdgeInsets.only(top: 5),
        child: TextFormField(
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          keyboardType: keyboard,
          decoration: InputDecoration(
            errorText: errorText,
            labelText: label,
            prefixIcon: Icon(icon, color: Colors.grey.shade600),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Color(0xffff650e),
                width: 1.0,
              ),
            ),
            isDense: true,
          ),
        ),
      ),
    ],
  );

  Widget _buildPasswordField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 62,
        child: TextFormField(
          controller: _passC,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: Validators.validatePassword,
          obscureText: _obscure,
          decoration: InputDecoration(
            errorText: _passErr,
            labelText: "Password",
            prefixIcon: Icon(Icons.lock, color: Colors.grey.shade600),
            suffixIcon: IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade600,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Color(0xffff650e),
                width: 1.0,
              ),
            ),
            isDense: true,
          ),
        ),
      ),
    ],
  );

  Widget _buildLoginButton(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: _loading
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                final isEmailTab = _tabController.index == 1;
                final identifier = isEmailTab
                    ? _emailC.text.trim()
                    : _phoneC.text.trim();
                context.read<AuthBloc>().add(
                  LoginRequested(identifier, _passC.text.trim()),
                );
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffff650e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: _loading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
              "Log In",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
    ),
  );

  Widget _socialButton(String asset) => Container(
    width: 50,
    height: 50,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      shape: BoxShape.circle,
    ),
    child: Image.asset(asset, height: 25, width: 25, fit: BoxFit.contain),
  );
}
