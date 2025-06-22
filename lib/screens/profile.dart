import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fintrack/models/User/User.dart';
import 'package:fintrack/services/UserService/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static final globalKey = GlobalKey<_ProfilePageState>();

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final fetchedUser = await UserService.getByEmail();
      setState(() {
        user = fetchedUser;
        isLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Erro ao carregar usuário");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFFF3),
      body: Stack(
        children: [
          Container(height: 220, color: const Color(0xFF00C689)),

          Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Color(0xFFEFFFF3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
            ),
          ),

          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Center(
                        child: Text(
                          'Perfil',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/profile.png'),
                      radius: 50,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  isLoading ? 'Carregando...' : (user?.name ?? 'Usuário'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      _buildOptionButton(
                        Icons.person_outline,
                        "Editar Perfil",
                        context,
                      ),
                      const SizedBox(height: 20),
                      _buildOptionButton(Icons.logout, "Sair", context),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(IconData icon, String label, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (label == "Editar Perfil") {
          Navigator.pushNamed(context, '/edit-profile');
        } else if (label == "Sair") {
          const storage = FlutterSecureStorage();
          await storage.deleteAll();

          Fluttertoast.showToast(
            msg: "Logout realizado com sucesso",
            backgroundColor: Colors.green,
          );

          Navigator.pushNamedAndRemoveUntil(
            context,
            '/prelogin',
            (route) => false,
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF53A7F5),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
