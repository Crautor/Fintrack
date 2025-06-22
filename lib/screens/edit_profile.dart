import 'package:fintrack/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fintrack/models/User/User.dart';
import 'package:fintrack/services/UserService/user_service.dart';
import 'package:fintrack/components/layout/main_screen.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool notificationsEnabled = true;
  bool isLoading = true;
  User? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final fetchedUser = await UserService.getByEmail();
      if (fetchedUser != null) {
        setState(() {
          user = fetchedUser;
          _nameController.text = fetchedUser.name;
          _phoneController.text = fetchedUser.phone ?? '';
          _emailController.text = fetchedUser.email;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Erro ao carregar perfil");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFFF3),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Container(
                        height: constraints.maxHeight * 0.28,
                        color: const Color(0xFF00C689),
                      ),
                      Positioned(
                        top: constraints.maxHeight * 0.20,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFEFFFF3),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                const Spacer(),
                                const Text(
                                  'Editar Perfil',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(
                                    Icons.notifications_none,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: const CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/profile.png',
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            user?.name ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Configurações Da Conta',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildTextField(
                                    "Nome De Usuário",
                                    _nameController,
                                  ),
                                  _buildTextField("Telefone", _phoneController),
                                  _buildTextField(
                                    "Email",
                                    _emailController,
                                    readOnly: true,
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        if (user == null) return;

                                        final updatedUser = User(
                                          name: _nameController.text,
                                          email: _emailController.text,
                                          phone: _phoneController.text,
                                        );
                                        final updated =
                                            await UserService.putByEmail(
                                              updatedUser,
                                            );
                                        if (updated != null) {
                                          setState(() => user = updated);
                                          Fluttertoast.showToast(
                                            msg:
                                                "Perfil atualizado com sucesso",
                                          );

                                          Navigator.pop(context);
                                          Future.delayed(
                                            const Duration(milliseconds: 300),
                                            () {
                                              final mainScreen = MainScreen.of(
                                                context,
                                              );
                                              mainScreen?.goTo(4);
                                              ProfilePage.globalKey.currentState
                                                  ?.loadUser();
                                            },
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "Erro ao atualizar perfil",
                                          );
                                        }
                                      } catch (e) {
                                        Fluttertoast.showToast(
                                          msg: "Erro: ${e.toString()}",
                                        );
                                      }
                                    },

                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF00C689),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      minimumSize: const Size.fromHeight(40),
                                    ),
                                    child: const Text(
                                      "Atualizar Perfil",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            readOnly: readOnly,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: readOnly ? Colors.grey.shade200 : Colors.white70,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
