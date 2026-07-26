import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isRegistering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE31E24), Color(0xFFC41A1F)],
                ),
              ),
              child: const Column(
                children: [
                  Text('Kaspi bank',
                    style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900)),
                  SizedBox(height: 30),
                  Text('Добро пожаловать!',
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (_isRegistering) ...[
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Имя в Kaspi',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Почта',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Номер телефона',
                      hintText: '+7 777 123 45 67',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE31E24),
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                    },
                    child: Text(_isRegistering ? 'Зарегистрироваться' : 'Продолжить'),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _isRegistering = !_isRegistering),
                    child: Text(_isRegistering ? 'Войти' : 'Регистрация'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kaspi'),
        backgroundColor: const Color(0xFFE31E24),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🏦', style: TextStyle(fontSize: 80)),
            SizedBox(height: 20),
            Text('Добро пожаловать!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Ваш баланс: 453 200 ₸', style: TextStyle(fontSize: 20, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
