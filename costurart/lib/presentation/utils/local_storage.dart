import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveNomeTelefone(String nome, String telefone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nome', nome);
    await prefs.setString('telefone', telefone);
  }

  static Future<Map<String, String>> getNomeTelefone() async {
    final prefs = await SharedPreferences.getInstance();
    final nome = prefs.getString('nome') ?? '';
    final telefone = prefs.getString('telefone') ?? '';
    return {'nome': nome, 'telefone': telefone};
  }
}
