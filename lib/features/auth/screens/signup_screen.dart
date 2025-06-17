//  lib/features/auth/screens/signup_screen.dart
import 'package:apnamall_ecommerce_app/core/utils/validators.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  // ---------------- controllers ----------------
  final _firstNameC = TextEditingController();
  final _lastNameC = TextEditingController();
  final _emailC = TextEditingController();
  final _dateC = TextEditingController();
  final _phoneC = TextEditingController();
  final _passC = TextEditingController();
  final _confirmPassC = TextEditingController();

  // ---------------- misc ----------------
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  bool _obscure = true;
  bool _loading = false;
  String countryCode = "+91";

  // ---------------- error String ----------------
  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _dobError;
  String? _phoneError;
  String? _passError;
  String? _confirmPassError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _firstNameC.addListener(() {
      final error = Validators.validateName(
        _firstNameC.text,
        fieldName: "First name",
      );
      setState(() => _firstNameError = error);
    });

    _lastNameC.addListener(() {
      final error = Validators.validateName(
        _lastNameC.text,
        fieldName: "Last name",
      );
      setState(() => _lastNameError = error);
    });

    _emailC.addListener(() {
      final error = Validators.validateEmail(_emailC.text);
      setState(() => _emailError = error);
    });

    _dateC.addListener(() {
      final error = Validators.validateDOB(_dateC.text);
      setState(() => _dobError = error);
    });

    _phoneC.addListener(() {
      final error = Validators.validatePhone(_phoneC.text);
      setState(() => _phoneError = error);
    });

    _passC.addListener(() {
      final error = Validators.validatePassword(_passC.text);
      setState(() => _passError = error);
    });

    _confirmPassC.addListener(() {
      final error = Validators.validateConfirmPassword(
        _confirmPassC.text,
        _passC.text,
      );
      setState(() => _confirmPassError = error);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _firstNameC.dispose();
    _lastNameC.dispose();
    _emailC.dispose();
    _dateC.dispose();
    _phoneC.dispose();
    _passC.dispose();
    _confirmPassC.dispose();
    super.dispose();
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        setState(() => _loading = state is AuthLoading);
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text("User Register Successfully!")));
          Navigator.pop(context);
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(state.message)));
        }
      },
      builder: (context, _) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body: LayoutBuilder(
              builder: (ctx, cons) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: cons.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 60),
                          const Text(
                            "Get Started Now",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Create an account or log in to explore\nabout our app",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontFamily: "Poppins",
                            ),
                          ),
                          const SizedBox(height: 15),
                          _buildToggleButtons(),
                          const SizedBox(height: 30),
                          _buildNameFields(),
                          const SizedBox(height: 25),
                          _buildTextField(
                            label: "Email",
                            controller: _emailC,
                            icon: Icons.email,
                            keyboard: TextInputType.emailAddress,
                            validator: Validators.validateEmail,
                            errorText: _emailError,
                          ),
                          const SizedBox(height: 25),
                          _buildDatePicker(),
                          const SizedBox(height: 25),
                          _buildPhoneField(),
                          const SizedBox(height: 25),
                          _buildPasswordField(
                            label: "Set Password",
                            controller: _passC,
                            validator: (v) =>
                                Validators.validatePassword(_passC.text),
                            errorText: _passError,
                          ),
                          const SizedBox(height: 25),
                          _buildPasswordField(
                            label: "Confirm Password",
                            controller: _confirmPassC,
                            validator: (v) =>
                                Validators.validateConfirmPassword(
                                  v,
                                  _passC.text,
                                ),
                              errorText: _confirmPassError,    
                          ),
                          const SizedBox(height: 35),
                          _buildSignUpButton(context),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------- individual widgets ----------------
  Widget _buildToggleButtons() => Container(
    height: 45,
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(25),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: const Color(0xffff650e),
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelColor: Colors.black,
        tabs: const [
          Tab(text: "Sign Up"),
          Tab(text: "Log In"),
        ],
        onTap: (i) {
          if (i == 1) Navigator.pop(context);
        },
      ),
    ),
  );

  Widget _buildNameFields() => Row(
    children: [
      Expanded(
        child: _buildTextField(
          label: "First Name",
          controller: _firstNameC,
          icon: Icons.person,
          errorText: _firstNameError,
          validator: (v) => Validators.validateName(v, fieldName: "First name"),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _buildTextField(
          label: "Last Name",
          controller: _lastNameC,
          icon: Icons.person,
          errorText: _lastNameError,
          validator: (v) => Validators.validateName(v, fieldName: "Last name"),
        ),
      ),
    ],
  );

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
    String? errorText,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        labelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, color: Colors.black54),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xffff650e), width: 1.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    String? errorText,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: _obscure,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        labelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xffff650e), width: 1.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildDatePicker() => GestureDetector(
    onTap: _pickDate,
    child: AbsorbPointer(
      child: _buildTextField(
        label: "Birth of Date",
        controller: _dateC,
        icon: FontAwesomeIcons.calendar,
        errorText: _dobError,
        validator: (v) => v == null || v.isEmpty ? "Select DOB" : null,
      ),
    ),
  );

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dateC.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  Widget _buildPhoneField() => TextFormField(
    controller: _phoneC,
    keyboardType: TextInputType.phone,
    validator: (v) => v == null || v.isEmpty ? "Phone required" : null,
    decoration: InputDecoration(
      labelText: "Phone Number",
      errorText: _phoneError,
      labelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: GestureDetector(
        onTap: _showCustomCountryPicker,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            countryCode,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xffff650e), width: 1.0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    ),
  );

  // country picker remains unchanged
  void _showCustomCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        TextEditingController searchC = TextEditingController();
        List<Country> all = CountryService().getAll();
        List<Country> filtered = List.from(all);

        return StatefulBuilder(
          builder: (ctx, setModal) {
            void filter(String q) {
              setModal(() {
                filtered = all
                    .where(
                      (c) =>
                          c.name.toLowerCase().contains(q.toLowerCase()) ||
                          c.phoneCode.contains(q),
                    )
                    .toList();
              });
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Center(
                    child: Container(
                      width: 80,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Select Your Country",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 45,
                    child: TextField(
                      controller: searchC,
                      onChanged: filter,
                      decoration: InputDecoration(
                        hintText: "Search country…",
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xffff650e),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final c = filtered[i];
                        return ListTile(
                          leading: Text(
                            c.flagEmoji,
                            style: const TextStyle(fontSize: 25),
                          ),
                          title: Text(c.name),
                          subtitle: Text("+${c.phoneCode}"),
                          onTap: () {
                            setState(() => countryCode = "+${c.phoneCode}");
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSignUpButton(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: _loading
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(
                  SignUpRequested(
                    _firstNameC.text.trim(),
                    _lastNameC.text.trim(),
                    _emailC.text.trim(),
                    _passC.text.trim(),
                    _phoneC.text.trim(),
                  ),
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
              "Sign Up",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    ),
  );
}
