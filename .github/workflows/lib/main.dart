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
// ==================== ГЛАВНЫЙ ЭКРАН ====================
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  late double _balance;
  late int _bonus;
  late String _cardNumber;
  late String _cvv;
  late String _expiry;
  late String _role;
  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final user = AppData.currentUser!;
    _balance = (user['balance'] as num).toDouble();
    _bonus = user['bonus'] ?? 0;
    _cardNumber = user['cardNumber'] ?? AppData.generateCardNumber();
    _cvv = user['cvv'] ?? AppData.generateCVV();
    _expiry = user['expiry'] ?? AppData.generateExpiry();
    _role = user['role'] ?? 'user';
    
    _transactions = List<Map<String, dynamic>>.from(
      (user['transactions'] as List<dynamic>?) ?? [
        {'icon': '↓', 'title': 'Пополнение', 'amount': '+50 000 ₸', 'isIncome': true, 'date': 'Сегодня'},
        {'icon': '↑', 'title': 'Перевод', 'amount': '-12 500 ₸', 'isIncome': false, 'date': 'Вчера'},
        {'icon': '🛒', 'title': 'Магазин', 'amount': '-8 750 ₸', 'isIncome': false, 'date': '25 июля'},
        {'icon': '💰', 'title': 'Зарплата', 'amount': '+320 000 ₸', 'isIncome': true, 'date': '20 июля'},
      ],
    );
  }

  void _updateBalance(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users') ?? '[]';
    final users = List<Map<String, dynamic>>.from(jsonDecode(usersJson));
    
    final index = users.indexWhere((u) => u['phone'] == AppData.currentUser!['phone']);
    if (index != -1) {
      users[index]['balance'] = (users[index]['balance'] as num).toDouble() + amount;
      AppData.currentUser = users[index];
      await prefs.setString('users', jsonEncode(users));
      setState(() => _balance = users[index]['balance']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildDashboard(),
      _buildQRScanner(),
      _buildShop(),
      _buildBank(),
    ];

    return Scaffold(
      body: SafeArea(child: screens[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: const Color(0xFFE31E24),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Магазин'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: 'Банк'),
        ],
      ),
    );
  }

  // ГЛАВНЫЙ ЭКРАН
  Widget _buildDashboard() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // КАРТА KASPI GOLD
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1A1A1A), Color(0xFF333333)]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Kaspi Gold', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600)),
                    Image.asset('assets/logo.png', width: 40, height: 40, errorBuilder: (_, __, ___) => const Icon(Icons.credit_card, color: Colors.gold, size: 40)),
                  ],
                ),
                const SizedBox(height: 20),
                Text(_cardNumber, style: const TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 3, fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Срок', style: TextStyle(color: Colors.grey, fontSize: 10)),
                        Text(_expiry, style: const TextStyle(color: Colors.white, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(width: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('CVV', style: TextStyle(color: Colors.grey, fontSize: 10)),
                        Text(_cvv, style: const TextStyle(color: Colors.white, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Баланс', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('${_balance.toStringAsFixed(0)} ₸', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Бонусы', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('🔥 $_bonus', style: const TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // БЫСТРЫЕ ДЕЙСТВИЯ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickAction('📤', 'Перевести', () => _showTransferDialog()),
                _buildQuickAction('📷', 'Мой QR', () => _showMyQR()),
                _buildQuickAction('🛒', 'Платежи', () => _showPayments()),
                _buildQuickAction(_getRoleMenuIcon(), _getRoleMenuName(), _showRoleMenu),
              ],
            ),
          ),

          // БАЛАНС И ДЕЙСТВИЯ
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _updateBalance(5000),
                    icon: const Text('💰'),
                    label: const Text('Пополнить'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showTransferDialog(),
                    icon: const Text('💸'),
                    label: const Text('Перевести'),
                  ),
                ),
              ],
            ),
          ),

          // ИСТОРИЯ
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('История операций', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Все ›', style: TextStyle(color: Color(0xFFE31E24))),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: _transactions.length,
            itemBuilder: (context, i) {
              final t = _transactions[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: (t['isIncome'] as bool) ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    child: Text(t['icon'] as String, style: const TextStyle(fontSize: 20)),
                  ),
                  title: Text(t['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(t['date'] as String, style: const TextStyle(fontSize: 12)),
                  trailing: Text(
                    t['amount'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: (t['isIncome'] as bool) ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // QR СКАНЕР
  Widget _buildQRScanner() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text('Сканер QR', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Expanded(
          child: MobileScanner(
            onDetect: (capture) {
              final barcode = capture.barcodes.first;
              if (barcode.rawValue != null) {
                _processQR(barcode.rawValue!);
              }
            },
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  // МАГАЗИН
  Widget _buildShop() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text('Kaspi Магазин', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 12, mainAxisSpacing: 12),
            itemCount: AppData.shopItems.length,
            itemBuilder: (context, i) {
              final item = AppData.shopItems[i];
              return Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item['image'] as String, style: const TextStyle(fontSize: 50)),
                    const SizedBox(height: 8),
                    Text(item['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text('${(item['price'] as int)} ₸', style: const TextStyle(color: Color(0xFFE31E24), fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    ElevatedButton(onPressed: () => _buyItem(item), child: const Text('Купить', style: TextStyle(fontSize: 12))),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  // МОЙ БАНК
  Widget _buildBank() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text('Мой Банк', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildBankCard('💰', 'Депозиты', 'Откройте депозит под 16.5%', () {}),
          _buildBankCard('💳', 'Кредиты', 'До 5 000 000 ₸', _showCreditDialog),
          _buildBankCard('🛍️', 'Kaspi Red', 'Рассрочка 0-0-12', () {}),
          _buildBankCard('📊', 'История', 'Все операции', () {}),
          _buildBankCard('⚙️', 'Профиль', _role.toUpperCase(), () => _showProfile()),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ
  Widget _buildQuickAction(String emoji, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildBankCard(String icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Text(icon, style: const TextStyle(fontSize: 30)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  String _getRoleMenuIcon() {
    switch (_role) {
      case 'owner': return '👑';
      case 'moderator': return '🛡️';
      default: return '👤';
    }
  }

  String _getRoleMenuName() {
    switch (_role) {
      case 'owner': return 'Admin';
      case 'moderator': return 'Moder';
      default: return 'Меню';
    }
  }

  void _showRoleMenu() {
    if (_role == 'owner') {
      _showAdminPanel();
    } else if (_role == 'moderator') {
      _showModerPanel();
    } else {
      _showUserMenu();
    }
  }

  void _showUserMenu() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('👤 User Menu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('💰'),
              title: const Text('Выдача денег (0-15 000 ₸)'),
              onTap: () {
                Navigator.pop(context);
                _showMoneyDialog(15000);
              },
            ),
            ListTile(
              leading: const Text('🎁'),
              title: const Text('Ежедневный бонус'),
              onTap: () {
                Navigator.pop(context);
                _updateBalance(1000);
                ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(content: Text('🎁 +1000 ₸ бонус!')));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showModerPanel() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🛡️ Moder Menu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('➕'),
              title: const Text('Добавить товар'),
              onTap: () {
                Navigator.pop(context);
                _addShopItem();
              },
            ),
            ListTile(
              leading: const Text('📋'),
              title: const Text('Все товары'),
              onTap: () {
                Navigator.pop(context);
                _showAllItems();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAdminPanel() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('👑 Admin Panel'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('💰'),
              title: const Text('Выдача денег'),
              onTap: () {
                Navigator.pop(context);
                _showMoneyDialog(999999999);
              },
            ),
            ListTile(
              leading: const Text('👥'),
              title: const Text('Пользователи'),
              onTap: () {
                Navigator.pop(context);
                _showAllUsers();
              },
            ),
            ListTile(
              leading: const Text('👑'),
              title: const Text('Назначить роль'),
              onTap: () {
                Navigator.pop(context);
                _showRoleAssignment();
              },
            ),
            ListTile(
              leading: const Text('💳'),
              title: const Text('Заявки на кредиты'),
              onTap: () {
                Navigator.pop(context);
                _showCreditRequests();
              },
            ),
          ],
        ),
      ),
    );
  }
  void _showMoneyDialog(int maxAmount) {
    final phoneCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('💰 Выдача денег (до $maxAmount ₸)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Номер получателя', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Сумма', border: OutlineInputBorder())),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountCtrl.text) ?? 0;
              if (amount > 0 && amount <= maxAmount) {
                Navigator.pop(context);
                // Начисляем указанному пользователю
                final prefs = await SharedPreferences.getInstance();
                final usersJson = prefs.getString('users') ?? '[]';
                final users = List<Map<String, dynamic>>.from(jsonDecode(usersJson));
                
                final index = users.indexWhere((u) => u['phone'] == phoneCtrl.text);
                if (index != -1) {
                  users[index]['balance'] = (users[index]['balance'] as num).toDouble() + amount;
                  await prefs.setString('users', jsonEncode(users));
                  ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('✅ Выдано ${amount.toInt()} ₸!'), backgroundColor: Colors.green));
                } else {
                  ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(content: Text('Пользователь не найден'), backgroundColor: Colors.red));
                }
              }
            },
            child: const Text('Выдать'),
          ),
        ],
      ),
    );
  }

  void _addShopItem() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('➕ Добавить товар'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Название', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Цена', border: OutlineInputBorder())),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () {
              final price = int.tryParse(priceCtrl.text) ?? 0;
              if (nameCtrl.text.isNotEmpty && price > 0) {
                setState(() {
                  AppData.shopItems.add({'name': nameCtrl.text, 'price': price, 'image': '🛍️'});
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  void _showAllItems() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📋 Все товары'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: AppData.shopItems.length,
            itemBuilder: (context, i) {
              final item = AppData.shopItems[i];
              return ListTile(
                leading: Text(item['image'] as String, style: const TextStyle(fontSize: 30)),
                title: Text(item['name'] as String),
                subtitle: Text('${item['price']} ₸'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() => AppData.shopItems.removeAt(i));
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users') ?? '[]';
    final users = List<Map<String, dynamic>>.from(jsonDecode(usersJson));
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('👥 Пользователи (${users.length})'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (context, i) {
              final u = users[i];
              return ListTile(
                leading: CircleAvatar(child: Text(u['name'][0])),
                title: Text(u['name']),
                subtitle: Text('${u['phone']} • ${u['role']} • ${u['balance']} ₸'),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showRoleAssignment() async {
    final phoneCtrl = TextEditingController();
    String selectedRole = 'user';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('👑 Назначить роль'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Номер телефона', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: const InputDecoration(labelText: 'Роль', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'user', child: Text('👤 User')),
                  DropdownMenuItem(value: 'moderator', child: Text('🛡️ Moderator')),
                  DropdownMenuItem(value: 'owner', child: Text('👑 Owner')),
                ],
                onChanged: (v) => setDialogState(() => selectedRole = v!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final usersJson = prefs.getString('users') ?? '[]';
                final users = List<Map<String, dynamic>>.from(jsonDecode(usersJson));
                
                final index = users.indexWhere((u) => u['phone'] == phoneCtrl.text);
                if (index != -1) {
                  users[index]['role'] = selectedRole;
                  await prefs.setString('users', jsonEncode(users));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(content: Text('✅ Роль обновлена!'), backgroundColor: Colors.green));
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreditRequests() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('💳 Заявки (${AppData.creditRequests.length})'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: AppData.creditRequests.length,
            itemBuilder: (context, i) {
              final req = AppData.creditRequests[i];
              return ListTile(
                title: Text('${req['name']}'),
                subtitle: Text('${req['amount']} ₸ • ${req['status']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () {
                      AppData.creditRequests[i]['status'] = 'approved';
                      Navigator.pop(context);
                    }),
                    IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: () {
                      AppData.creditRequests[i]['status'] = 'rejected';
                      Navigator.pop(context);
                    }),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(updateTheme: () {})));
  }

  void _buyItem(Map<String, dynamic> item) {
    final price = (item['price'] as int).toDouble();
    if (price <= _balance) {
      _updateBalance(-price);
      _addTransaction('🛒', 'Покупка: ${item['name']}', '-${price.toInt()} ₸', false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ Куплено: ${item['name']}!'), backgroundColor: Colors.green));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Недостаточно средств'), backgroundColor: Colors.red));
    }
  }

  void _addTransaction(String icon, String title, String amount, bool isIncome) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users') ?? '[]';
    final users = List<Map<String, dynamic>>.from(jsonDecode(usersJson));
    
    final index = users.indexWhere((u) => u['phone'] == AppData.currentUser!['phone']);
    if (index != -1) {
      final transactions = List<Map<String, dynamic>>.from(users[index]['transactions'] ?? []);
      transactions.insert(0, {
        'icon': icon,
        'title': title,
        'amount': amount,
        'isIncome': isIncome,
        'date': 'Сегодня',
      });
      users[index]['transactions'] = transactions;
      AppData.currentUser = users[index];
      await prefs.setString('users', jsonEncode(users));
    }
  }

  void _sendNotification(String toPhone, double amount) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users') ?? '[]';
    final users = List<Map<String, dynamic>>.from(jsonDecode(usersJson));
    
    final index = users.indexWhere((u) => u['phone'] == toPhone);
    if (index != -1) {
      final notifications = List<Map<String, dynamic>>.from(users[index]['notifications'] ?? []);
      notifications.insert(0, {
        'title': '💰 Перевод',
        'message': '${AppData.currentUser!['name']} перевёл вам ${amount.toInt()} ₸',
        'date': DateTime.now().toString(),
        'read': false,
      });
      users[index]['notifications'] = notifications;
      await prefs.setString('users', jsonEncode(users));
    }
  }
}
// ==================== ПРОФИЛЬ ====================
class ProfileScreen extends StatelessWidget {
  final Function updateTheme;
  const ProfileScreen({super.key, required this.updateTheme});

  @override
  Widget build(BuildContext context) {
    final user = AppData.currentUser!;
    final role = user['role'] ?? 'user';
    
    String roleEmoji;
    String roleName;
    switch (role) {
      case 'owner':
        roleEmoji = '👑';
        roleName = 'Owner';
        break;
      case 'moderator':
        roleEmoji = '🛡️';
        roleName = 'Moderator';
        break;
      default:
        roleEmoji = '👤';
        roleName = 'User';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Аватар
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFFE31E24),
              child: Text(
                user['name'][0].toUpperCase(),
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(user['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: role == 'owner' ? Colors.amber.withOpacity(0.2) : 
                       role == 'moderator' ? Colors.blue.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('$roleEmoji $roleName', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 30),
            
            // Информация
            _buildInfoCard(context),
            
            const SizedBox(height: 20),
            
            // Настройки
            _buildSettingsCard(context),
            
            const SizedBox(height: 20),
            
            // Выход
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  AppData.currentUser = null;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('🚪 ВЫЙТИ', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final user = AppData.currentUser!;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow('📱', 'Номер', user['phone']),
            const Divider(),
            _buildInfoRow('📧', 'Почта', user['email']),
            const Divider(),
            _buildInfoRow('🪪', 'ИИН', user['iin']),
            const Divider(),
            _buildInfoRow('💳', 'Карта', user['cardNumber']),
            const Divider(),
            _buildInfoRow('💰', 'Баланс', '${user['balance']} ₸'),
            const Divider(),
            _buildInfoRow('🔥', 'Бонусы', '${user['bonus']}'),
            const Divider(),
            _buildInfoRow('📅', 'Зарегистрирован', (user['registeredAt'] as String?)?.substring(0, 10) ?? 'Сегодня'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Text('$label:', style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.lock, color: Color(0xFFE31E24)),
            title: const Text('Сменить PIN'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _changePin(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.color_lens, color: Color(0xFFE31E24)),
            title: const Text('Тема оформления'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemePicker(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.notifications, color: Color(0xFFE31E24)),
            title: const Text('Уведомления'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🔔 Уведомления включены')),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info, color: Color(0xFFE31E24)),
            title: const Text('О приложении'),
            subtitle: const Text('Версия 2.0.0'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Kaspi Clone v2.0'),
                  content: const Text(
                    'Приложение создано в развлекательных целях.\n\n'
                    'Функции:\n'
                    '• Регистрация и авторизация\n'
                    '• Переводы по номеру и QR\n'
                    '• NFC переводы (Kaspi Tap)\n'
                    '• Платежи и магазин\n'
                    '• Кредиты и депозиты\n'
                    '• Система ролей\n'
                    '• Telegram интеграция\n\n'
                    'Не является настоящим банком!',
                  ),
                  actions: [
                    ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _changePin(BuildContext context) {
    final oldPinCtrl = TextEditingController();
    final newPinCtrl = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Сменить PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: oldPinCtrl, obscureText: true, maxLength: 4, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Старый PIN', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: newPinCtrl, obscureText: true, maxLength: 4, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Новый PIN', border: OutlineInputBorder())),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () async {
              if (oldPinCtrl.text == AppData.currentUser!['pin'] && newPinCtrl.text.length == 4) {
                final prefs = await SharedPreferences.getInstance();
                final usersJson = prefs.getString('users') ?? '[]';
                final users = List<Map<String, dynamic>>.from(jsonDecode(usersJson));
                
                final index = users.indexWhere((u) => u['phone'] == AppData.currentUser!['phone']);
                if (index != -1) {
                  users[index]['pin'] = newPinCtrl.text;
                  AppData.currentUser = users[index];
                  await prefs.setString('users', jsonEncode(users));
                }
                
                Navigator.pop(context);
                ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(content: Text('✅ PIN изменён!'), backgroundColor: Colors.green));
              } else {
                ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(content: Text('❌ Неверный старый PIN'), backgroundColor: Colors.red));
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _showThemePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎨 Выбор темы'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(context, 'Светлая', Brightness.light, Colors.white),
            _buildThemeOption(context, 'Тёмная', Brightness.dark, const Color(0xFF1A1A1A)),
            _buildThemeOption(context, 'Красная', Brightness.light, const Color(0xFFE31E24)),
            _buildThemeOption(context, 'Синяя', Brightness.light, const Color(0xFF2196F3)),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, String name, Brightness brightness, Color color) {
    return ListTile(
      leading: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
      ),
      title: Text(name),
      onTap: () {
        Navigator.pop(context);
        // Применяем тему
        if (brightness == Brightness.dark) {
          KaspiCloneApp.of(context)?.setTheme(ThemeMode.dark);
        } else {
          KaspiCloneApp.of(context)?.setTheme(ThemeMode.light);
        }
        KaspiCloneApp.of(context)?.setColor(color == Colors.white ? const Color(0xFFE31E24) : color);
        ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('🎨 Тема "$name" применена!')));
      },
    );
  }
}
