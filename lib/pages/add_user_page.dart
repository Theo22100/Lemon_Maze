import 'package:flutter/material.dart';
import 'package:my_app/modules/http.dart';

class AddUserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddUserPageState();
  }
}

class AddUserPageState extends State<AddUserPage> {
  TextEditingController nameController = TextEditingController();
  String response = "";

  createUser() async {
    var result = await http_post("create-user", {
      "name": nameController.text,
    });
    if (result.ok) {
      setState(() {
        response = result.data['status'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajout User"),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "Nom"),
          ),
          TextButton(
            child: Text("Créer"),
            onPressed: createUser,
          ),
          Text(response),
        ],
      ),
    );
  }
}
