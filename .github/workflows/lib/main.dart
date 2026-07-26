import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert';
import 'dart:math';

void main() {
  runApp(const KaspiCloneApp());
}

class KaspiCloneApp extends StatefulWidget {
  const KaspiCloneApp({super.key});

  static _KaspiCloneAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_KaspiCloneAppState>();
  }

  @override
  State<KaspiCloneApp> createState() => _KaspiCloneAppState();
}

class _KaspiCloneAppState extends State<KaspiCloneApp> {
  ThemeMode _themeMode = ThemeMode.light;
  Color _primaryColor = const Color(0xFFE31E24);

  void setTheme(ThemeMode mode) => setState(() => _themeMode = mode);
  void setColor(Color color) => setState(() => _primaryColor = color);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaspi Clone',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: _primaryColor,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: AppBarTheme(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: _primaryColor,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2D2D2D),
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
      home: const DisclaimerScreen(),
    );
  }
}

// ==================== ДАННЫЕ ====================
class AppData {
  static Map<String, dynamic>? currentUser;
  static List<Map<String, dynamic>> users = [];
  static List<Map<String, dynamic>> transactions = [];
  static List<Map<String, dynamic>> shopItems = [
    {'name': 'iPhone 15 Pro', 'price': 450000, 'image': '📱'},
    {'name': 'AirPods Pro', 'price': 89990, 'image': '🎧'},
    {'name': 'MacBook Air M3', 'price': 620000, 'image': '💻'},
    {'name': 'Samsung Galaxy S25', 'price': 420000, 'image': '📱'},
  ];
  static List<Map<String, dynamic>> creditRequests = [];
  static List<Map<String, dynamic>> notifications = [];

  static String generateIIN(String name) {
    final random = Random();
    String iin = '';
    for (int i = 0; i < 12; i++) {
      iin += random.nextInt(10).toString();
    }
    return iin;
  }

  static String generateCardNumber() {
    final random = Random();
    String card = '4400';
    for (int i = 0; i < 12; i++) {
      card += random.nextInt(10).toString();
    }
    return card.replaceAllMapped(RegExp(r'.{4}'), (m) => '${m.group(0)} ').trim();
  }

  static String generateCVV() {
    return '${Random().nextInt(900) + 100}';
  }

  static String generateExpiry() {
    return '${Random().nextInt(12) + 1}/${Random().nextInt(5) + 25}';
  }
}

// ==================== ДИСКЛЕЙМЕР ====================
class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 80, color: Color(0xFFE31E24)),
              const SizedBox(height: 24),
              const Text(
                '⚠️ ВНИМАНИЕ',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    Text(
                      'Это приложение создано в развлекательных целях.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Не является настоящим банковским приложением. Все данные хранятся локально. Приложение не имеет отношения к реальному Kaspi Bank.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Это копия банка создана исключительно для эмоций и обучения. Ваши данные не передаются третьим лицам.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text('✅ Я ПОНИМАЮ И ПРИНИМАЮ'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Подробнее'),
                      content: const Text(
                        'Приложение Kaspi Clone создано для:\n'
                        '• Обучения программированию\n'
                        '• Развлечения\n'
                        '• Демонстрации возможностей Flutter\n\n'
                        'Никакие реальные финансовые операции не проводятся.',
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Понятно')),
                      ],
                    ),
                  );
                },
                child: const Text('Подробнее'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Продолжение следует...      ),

    );
  }
}
// ==================== ЭКРАН ВХОДА ====================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                    Text('Kaspi bank', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900)),
                    SizedBox(height: 20),
                    Text('Копия банка', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    SizedBox(height: 30),
                    Text('Добро пожаловать!', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w600)),
                    SizedBox(height: 8),
                    Text('Введите номер телефона', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1A1A1A) ? const Color(0xFF2D2D2D) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Ваш номер телефона',
                        hintText: '+7 777 123 45 67',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                      },
                      child: const Text('Нет аккаунта? Зарегистрироваться', style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('ПРОДОЛЖИТЬ'),
                    ),
                    const SizedBox(height: 12),
                    const Text('Версия 2.0', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    final phone = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Введите номер')));
      return;
    }
    
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users') ?? '[]';
    final users = List<Map<String, dynamic>>.from(jsonDecode(usersJson));
    
    final user = users.firstWhere(
      (u) => u['phone'] == '+$phone',
      orElse: () => {},
    );
    
    if (user.isNotEmpty) {
      AppData.currentUser = user;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PinScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Пользователь не найден')));
    }
    
    setState(() => _isLoading = false);
  }
}

// ==================== РЕГИСТРАЦИЯ ====================
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _pinController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.person_add, size: 60, color: Color(0xFFE31E24)),
            const SizedBox(height: 20),
            const Text('Создайте аккаунт', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Имя для отображения',
                hintText: 'Ваше имя',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Номер телефона',
                hintText: '+7 777 123 45 67',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Электронная почта',
                hintText: 'example@mail.ru',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              obscureText: true,
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Придумайте PIN (4 цифры)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleRegister,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('ЗАРЕГИСТРИРОВАТЬСЯ'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleRegister() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty || 
        _emailController.text.isEmpty || _pinController.text.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Заполните все поля')));
      return;
    }

    setState(() => _isLoading = true);
    
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users') ?? '[]';
    final users = List<Map<String, dynamic>>.from(jsonDecode(usersJson));
    
    final newUser = {
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
      'pin': _pinController.text,
      'balance': 0.0,
      'bonus': 0,
      'cardNumber': AppData.generateCardNumber(),
      'cvv': AppData.generateCVV(),
      'expiry': AppData.generateExpiry(),
      'iin': AppData.generateIIN(_nameController.text.trim()),
      'role': 'user',
      'avatar': _nameController.text[0].toUpperCase(),
      'registeredAt': DateTime.now().toString(),
    };
    
    users.add(newUser);
    await prefs.setString('users', jsonEncode(users));
    
    AppData.currentUser = newUser;
    
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('✅ Регистрация успешна!'),
      backgroundColor: Colors.green,
    ));
    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const PinScreen()),
      (route) => false,
    );
  }
}

// ==================== PIN ЭКРАН ====================
class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String _pin = '';
  String _message = 'Введите PIN-код';
  final LocalAuthentication _auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  void _checkBiometrics() async {
    final canCheck = await _auth.canCheckBiometrics;
    if (canCheck) {
      try {
        final authenticated = await _auth.authenticate(
          localizedReason: 'Войдите по отпечатку пальца',
        );
        if (authenticated && mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
            (route) => false,
          );
        }
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Введите PIN'), backgroundColor: Colors.transparent, foregroundColor: Theme.of(context).textTheme.bodyLarge?.color),
      body: Column(
        children: [
          const Spacer(flex: 2),
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
            child: Center(
              child: Text(
                AppData.currentUser?['name']?[0]?.toUpperCase() ?? '?',
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(AppData.currentUser?['name'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 16, height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < _pin.length ? const Color(0xFFE31E24) : Colors.transparent,
                border: Border.all(color: i < _pin.length ? const Color(0xFFE31E24) : Colors.grey),
              ),
            )),
          ),
          const SizedBox(height: 12),
          Text(_message, style: TextStyle(color: _message.contains('✓') ? Colors.green : Colors.grey)),
          const Spacer(),
          _buildKeyboard(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildKeyboard() {
    return Column(
      children: [
        for (var row in [['1','2','3'], ['4','5','6'], ['7','8','9']])
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: row.map((d) => _keyButton(d)).toList()),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                final canCheck = await _auth.canCheckBiometrics;
                if (canCheck) {
                  final authenticated = await _auth.authenticate(localizedReason: 'Войдите по отпечатку');
                  if (authenticated && mounted) {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DashboardScreen()), (route) => false);
                  }
                }
              },
              child: Container(width: 65, height: 65, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey)),
                child: const Icon(Icons.fingerprint, color: Colors.grey)),
            ),
            const SizedBox(width: 20),
            _keyButton('0'),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () { if (_pin.isNotEmpty) setState(() => _pin = _pin.substring(0, _pin.length - 1)); },
              child: Container(width: 65, height: 65, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey)),
                child: const Icon(Icons.backspace, color: Colors.grey)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _keyButton(String digit) {
    return GestureDetector(
      onTap: () {
        if (_pin.length < 4) {
          setState(() => _pin += digit);
          if (_pin.length == 4) {
            if (_pin == AppData.currentUser?['pin']) {
              setState(() => _message = '✓ Верно!');
              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DashboardScreen()), (route) => false);
              });
            } else {
              setState(() { _message = 'Неверный PIN'; _pin = ''; });
              Future.delayed(const Duration(seconds: 1), () => setState(() => _message = 'Введите PIN-код'));
            }
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 65, height: 65,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey[300]!)),
        child: Center(child: Text(digit, style: const TextStyle(fontSize: 24))),
      ),
    );
  }
}
