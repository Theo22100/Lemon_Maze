import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _network = Network();
  late TextEditingController _nameController;
  late TextEditingController _surNameController;
  String buttonText = 'Save';
  int? id;
  @override
  void initState() {
    _nameController = TextEditingController();
    _surNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        unFocus(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBar,
        body: body,
        floatingActionButton: fabAction(context),
      ),
    );
  }

  void unFocus(BuildContext context) {
    FocusScopeNode scope = FocusScope.of(context);
    if (scope.hasFocus) scope.unfocus();
  }

  FloatingActionButton fabAction(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        seeAll(context);
      },
      label: Row(
        children: const [
          Icon(Icons.person),
          Text('See All'),
        ],
      ),
    );
  }

  AppBar get appBar {
    return AppBar(
      title: const Text('Full Stack Example'),
      centerTitle: true,
    );
  }

  Center get body {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _nameController,
              maxLength: 45,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextFormField(
              controller: _surNameController,
              maxLength: 45,
              decoration: const InputDecoration(
                labelText: 'Surname',
              ),
            ),
            ElevatedButton(
              onPressed: saveButtonAction,
              child: Text(buttonText),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  void seeAll(BuildContext context) async {
    await showModalBottomSheet(
      elevation: 10,
      backgroundColor: Colors.amber,
      context: context,
      builder: (c) {
        return FutureBuilder<List<Person>?>(
          future: _network.read,
          builder: (c, s) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.8,
              color: Colors.amber,
              child: allPersons(s),
            );
          },
        );
      },
    );
  }

  Widget allPersons(AsyncSnapshot<List<Person>?> s) {
    if (!s.hasData) {
      return const Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: s.data!.length,
        itemBuilder: (c, i) {
          return PersonCard(
            person: s.data![i],
            delete: () {
              setState(() {});
            },
            update: () {
              setState(
                () {
                  buttonText = 'Update';
                  Person p = s.data![i];
                  id = p.id;
                  _nameController.text = p.name;
                  _surNameController.text = p.surName;
                },
              );
            },
          );
        },
      );
    }
  }

  Future<void> saveButtonAction() async {
    switch (buttonText) {
      case 'Update':
        await updateAction();
        break;
      default:
        await saveAction();
    }
    _nameController.clear();
    _surNameController.clear();
    setState(() {
      buttonText = 'Save';
    });
  }

  bool get condition {
    bool c1 = _nameController.text.isNotEmpty;
    bool c2 = _surNameController.text.isNotEmpty;
    bool condition = c1 && c2;
    return condition;
  }

  Future<void> updateAction() async {
    if (condition) {
      var p = Person(
        name: _nameController.text,
        surName: _surNameController.text,
        id: id,
      );
      await _network.update(p);
      await dialog('${p.name} ${p.surName} updated.');
    } else {
      await dialog('Fields cannot be empty.');
    }
  }

  Future<void> saveAction() async {
    if (condition) {
      var p = Person(
        name: _nameController.text,
        surName: _surNameController.text,
        id: null,
      );
      bool c = await _network.check(p);
      if (c) {
        await _network.write(p);
        await dialog(
          '${p.name} ${p.surName} saved',
        );
      } else {
        await dialog(
          '${p.name} ${p.surName} already exist',
        );
      }
    } else {
      await dialog('Fields cannot be empty.');
    }
  }

  Future<void> dialog(
    String message,
  ) async {
    return await showDialog(
      context: context,
      builder: (c) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(message),
          ),
        );
      },
    );
  }
}
