import 'package:flutter/material.dart';
import 'presentation/pages/pedidos_page.dart';
import 'presentation/pages/dashboard_page.dart';
import 'presentation/pages/agenda_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/pedidos_guest_page.dart';
import 'data/repositories/pedido_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isGuest;
  String? nome;
  String? telefone;
  final pedidoRepository = PedidoRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Costurart Agenda',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF8E24AA)),
        primaryColor: Color(0xFF8E24AA),
        scaffoldBackgroundColor: Color(0xFFF8F6FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8E24AA),
          foregroundColor: Colors.white,
          elevation: 2,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Montserrat',
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color(0xFF8E24AA),
          ),
          titleMedium: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Color(0xFF4A148C),
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: Color(0xFF4A148C),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF8E24AA),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
            ),
            elevation: 2,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF8E24AA)),
          ),
        ),
      ),
      home: isGuest == null
          ? LoginPage(
              onLogin: (guest, n, t) {
                setState(() {
                  isGuest = guest;
                  nome = n;
                  telefone = t;
                });
              },
            )
          : isGuest == true
          ? PedidosGuestPage(
              nome: nome,
              telefone: telefone,
              repository: pedidoRepository,
            )
          : HomeScreen(repository: pedidoRepository),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final PedidoRepository repository;
  const HomeScreen({super.key, required this.repository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      PedidosPage(repository: widget.repository),
      DashboardPage(repository: widget.repository),
      AgendaPage(repository: widget.repository),
    ];
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Pedidos'),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Agenda',
          ),
        ],
      ),
    );
  }
}
