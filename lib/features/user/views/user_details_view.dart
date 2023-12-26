import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/support/views/support_edit_view.dart';

class UserDetailsView extends StatelessWidget {
  const UserDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Column(
        children: [
          Container(
            height: 245,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('caminho_da_sua_imagem_de_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: (MediaQuery.of(context).size.width - 158) / 2,
                  child: Container(
                    height: 158,
                    width: 158,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                    ),
                    child: Image.asset('caminho_da_sua_imagem_circular.jpg'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Seu Nome',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          // Lista de ListTiles
          ListTile(
            title: Text('Configurações'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Ação quando "Configurações" é clicado
            },
          ),
          Divider(
            color: Color(0xFFE8E8E8),
            thickness: 1,
          ),
          ListTile(
            title: Text('Preferências'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Ação quando "Preferências" é clicado
            },
          ),
          Divider(
            color: Color(0xFFE8E8E8),
            thickness: 1,
          ),
          ListTile(
            title: Text('Ajuda'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () => Get.to(() => SupportEditView()),
          ),
        ],
      ),
    );
  }
}
