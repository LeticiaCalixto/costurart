import 'package:flutter/material.dart';
import '../utils/local_storage.dart';

class LoginPage extends StatefulWidget {
  final void Function(bool isGuest, String? nome, String? telefone) onLogin;
  const LoginPage({super.key, required this.onLogin});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  String? _nome;
  String? _telefone;

  @override
  void initState() {
    super.initState();
    _loadNomeTelefone();
  }

  Future<void> _loadNomeTelefone() async {
    final data = await LocalStorage.getNomeTelefone();
    setState(() {
      _nomeController.text = data['nome'] ?? '';
      _telefoneController.text = data['telefone'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Entrar por nome e telefone',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nomeController,
                      decoration: const InputDecoration(labelText: 'Nome'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _telefoneController,
                      decoration: const InputDecoration(labelText: 'Telefone'),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final nome = _nomeController.text;
                        final telefone = _telefoneController.text;
                        await LocalStorage.saveNomeTelefone(nome, telefone);
                        widget.onLogin(true, nome, telefone);
                      },
                      child: const Text('Entrar'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final emailController = TextEditingController();
                    final senhaController = TextEditingController();
                    return AlertDialog(
                      title: const Text('Entrar com email'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: senhaController,
                            decoration: const InputDecoration(
                              labelText: 'Senha',
                            ),
                            obscureText: true,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.onLogin(false, emailController.text, null);
                          },
                          child: const Text('Entrar'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text(
                'Entrar com email',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.deepPurple,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
