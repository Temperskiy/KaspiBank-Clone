import 'package:flutter/material.dart';

void main() {
  runApp(const KaspiApp());
}

class KaspiApp extends StatelessWidget {
  const KaspiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaspi Bank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFE31E24),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE31E24),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE31E24),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// ЭКРАН ВХОДА
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
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                  ),
                ),
                child: const Column(
                  children: [
                    Text('Kaspi bank', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900)),
                    SizedBox(height: 30),
                    Text('Добро пожаловать!', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    if (_isRegistering) ...[
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Имя в Kaspi',
                          hintText: 'Алия Маратовна',
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
                    ],
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Ваш любой номер',
                        hintText: '7771234567',
                        prefixText: '+7 ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _handleSubmit,
                      child: Text(_isRegistering ? 'Зарегистрироваться' : 'Продолжить'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => setState(() => _isRegistering = !_isRegistering),
                      child: Text(_isRegistering ? 'Уже есть аккаунт? Войти' : 'Нет аккаунта? Зарегистрироваться'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    final phone = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Введите номер')));
      return;
    }
    final name = _isRegistering ? _nameController.text.trim() : 'Пользователь';
    final email = _isRegistering ? _emailController.text.trim() : '';
    
    if (_isRegistering && (name.isEmpty || email.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Заполните все поля')));
      return;
    }
    
    Navigator.push(context, MaterialPageRoute(builder: (context) => PinScreen(phone: phone, name: name, email: email, isNewUser: _isRegistering)));
  }
}

// ЭКРАН PIN
class PinScreen extends StatefulWidget {
  final String phone, name, email;
  final bool isNewUser;
  const PinScreen({super.key, required this.phone, required this.name, required this.email, required this.isNewUser});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String _pin = '', _savedPin = '', _message = '';
  
  @override
  void initState() {
    super.initState();
    _message = widget.isNewUser ? 'Придумайте PIN (4 цифры)' : 'Введите PIN-код';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0, title: Text(widget.isNewUser ? 'Создайте PIN' : 'Введите PIN')),
      body: Column(
        children: [
          const Spacer(flex: 2),
          Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
            child: Center(child: Text(widget.name[0].toUpperCase(), style: const TextStyle(fontSize: 40)))),
          const SizedBox(height: 12),
          Text(widget.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          if (widget.email.isNotEmpty) Text(widget.email, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) => Container(margin: const EdgeInsets.symmetric(horizontal: 10), width: 16, height: 16,
              decoration: BoxDecoration(shape: BoxShape.circle, color: i < _pin.length ? const Color(0xFFE31E24) : Colors.transparent,
                border: Border.all(color: i < _pin.length ? const Color(0xFFE31E24) : Colors.grey, width: 2))))),
          const SizedBox(height: 12),
          Text(_message, style: TextStyle(color: Colors.grey[600])),
          const Spacer(),
          _buildKeyboard(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildKeyboard() {
    return Column(children: [
      for (var row in [['1','2','3'], ['4','5','6'], ['7','8','9']])
        Padding(padding: const EdgeInsets.only(bottom: 16),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((d) => _keyButton(d)).toList())),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(width: 85), _keyButton('0'), const SizedBox(width: 20),
        GestureDetector(onTap: () { if (_pin.isNotEmpty) setState(() => _pin = _pin.substring(0, _pin.length - 1)); },
          child: Container(width: 65, height: 65, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey[300]!)),
            child: const Icon(Icons.backspace, color: Colors.grey)))
      ]),
    ]);
  }

  Widget _keyButton(String digit) {
    return GestureDetector(
      onTap: () {
        if (_pin.length < 4) {
          setState(() => _pin += digit);
          if (_pin.length == 4) _checkPin();
        }
      },
      child: Container(margin: const EdgeInsets.symmetric(horizontal: 10), width: 65, height: 65,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey[300]!)),
        child: Center(child: Text(digit, style: const TextStyle(fontSize: 24)))),
    );
  }

  void _checkPin() {
    if (widget.isNewUser) {
      if (_savedPin.isEmpty) {
        _savedPin = _pin; _pin = '';
        setState(() => _message = 'Повторите PIN');
      } else if (_pin == _savedPin) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardScreen(phone: widget.phone, name: widget.name, email: widget.email, balance: 0)), (route) => false);
      } else {
        setState(() { _message = 'PIN не совпадает!'; _pin = ''; _savedPin = ''; });
        Future.delayed(const Duration(seconds: 1), () => setState(() => _message = 'Придумайте PIN (4 цифры)'));
      }
    } else {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardScreen(phone: widget.phone, name: widget.name, email: widget.email, balance: 453200)), (route) => false);
    }
  }
}

// ГЛАВНЫЙ ЭКРАН
class DashboardScreen extends StatefulWidget {
  final String phone, name, email;
  final double balance;
  const DashboardScreen({super.key, required this.phone, required this.name, required this.email, required this.balance});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late double _balance;
  int _bonus = 1250;
  String _cardNumber = '5678';
  final List<Map<String, dynamic>> _transactions = [
    {'icon': '↓', 'title': 'Пополнение с карты', 'amount': '+50 000 ₸', 'isIncome': true},
    {'icon': '↑', 'title': 'Перевод на Kaspi Gold', 'amount': '-12 500 ₸', 'isIncome': false},
    {'icon': '↑', 'title': 'Магазин Magnum', 'amount': '-8 750 ₸', 'isIncome': false},
    {'icon': '↓', 'title': 'Зарплата', 'amount': '+320 000 ₸', 'isIncome': true},
  ];

  @override
  void initState() {
    super.initState();
    _balance = widget.balance;
    _cardNumber = (1000 + DateTime.now().millisecond % 9000).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFE31E24), Color(0xFFC41A1F)]),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('👋 Добрый день', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                    Text(widget.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                  ]),
                  IconButton(icon: const Icon(Icons.exit_to_app, color: Colors.white), onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false)),
                ]),
                const SizedBox(height: 20),
                Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Kaspi Gold', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const Text('Баланс', style: TextStyle(color: Colors.white54, fontSize: 13)),
                    Text('${_balance.toStringAsFixed(0)} ₸', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('💳 ···· $_cardNumber', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      Text('🔥 $_bonus бонусов', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    ]),
                  ])),
              ]),
            ),
            Padding(padding: const EdgeInsets.all(16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _actionButton('📤', 'Перевести', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TransferScreen(balance: _balance, onTransfer: (amount) => setState(() { _balance -= amount; _bonus += (amount * 0.01).toInt(); _transactions.insert(0, {'icon': '↑', 'title': 'Перевод', 'amount': '-$amount ₸', 'isIncome': false}); }))));
              }),
              _actionButton('📷', 'QR', () {}),
              _actionButton('🛒', 'Платежи', () {}),
              _actionButton('🏦', 'Банк', () {}),
            ])),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Последние операции', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Все ›', style: TextStyle(color: Color(0xFFE31E24))),
            ])),
            Expanded(child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: _transactions.length, itemBuilder: (context, i) {
              final t = _transactions[i];
              return Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Container(width: 44, height: 44, decoration: BoxDecoration(color: (t['isIncome'] as bool) ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Center(child: Text(t['icon'] as String, style: TextStyle(fontSize: 20, color: (t['isIncome'] as bool) ? Colors.green : Colors.red)))),
                  const SizedBox(width: 12),
                  Expanded(child: Text(t['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))),
                  Text(t['amount'] as String, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: (t['isIncome'] as bool) ? Colors.green : Colors.black87)),
                ]));
            })),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(selectedItemColor: const Color(0xFFE31E24), unselectedItemColor: Colors.grey, items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
        BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Переводы'),
        BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
      ]),
    );
  }

  Widget _actionButton(String emoji, String label, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Column(children: [
      Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(14)), child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22)))),
      const SizedBox(height: 8),
      Text(label, style: const TextStyle(fontSize: 11)),
    ]));
  }
}

// ЭКРАН ПЕРЕВОДОВ
class TransferScreen extends StatefulWidget {
  final double balance;
  final Function(double) onTransfer;
  const TransferScreen({super.key, required this.balance, required this.onTransfer});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _phoneCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Переводы')),
      body: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Номер получателя', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(controller: _phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(hintText: '7771234567', prefixText: '+7 ', border: OutlineInputBorder())),
        const SizedBox(height: 24),
        const Text('Сумма', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(children: [1000, 5000, 10000, 50000].map((a) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 8), child: OutlinedButton(onPressed: () => _amountCtrl.text = a.toString(), child: Text('$a ₸', style: const TextStyle(fontSize: 12)))))).toList()),
        const SizedBox(height: 8),
        TextField(controller: _amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: '0 ₸', suffixText: '₸', border: OutlineInputBorder())),
        const Spacer(),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {
          final amount = double.tryParse(_amountCtrl.text) ?? 0;
          if (amount <= 0 || amount > widget.balance) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ошибка'))); return; }
          widget.onTransfer(amount);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ Перевод ${amount.toInt()} ₸!'), backgroundColor: Colors.green));
        }, child: const Text('Перевести'))),
      ])),
    );
  }
}
