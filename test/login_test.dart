import 'package:LemonMaze/pages/register-login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:LemonMaze/modules/http.dart';

import 'login_test.mocks.dart'; // Notez le fichier généré ici

// Annotation pour générer les mocks
@GenerateMocks([NavigatorObserver])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });
  testWidgets('Login Page Test', (WidgetTester tester) async {
    // Créez des mocks pour NavigatorObserver
    final mockObserver = MockNavigatorObserver();

    await tester.pumpWidget(
      MaterialApp(
        home: const LoginPage(),
        navigatorObservers: [mockObserver],
      ),
    );
    // Vérifiez que les widgets initiaux sont rendus correctement
    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Saisir du texte dans les champs de texte
    await tester.enterText(find.byType(TextField).at(0), 'testuser');
    await tester.enterText(find.byType(TextField).at(1), 'password');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Vérifiez que le Snackbar est affiché si les champs sont vides
    expect(find.text('Veuillez remplir tous les champs !'), findsNothing);

    // Simulez une connexion réussie
    when(http_post('login', any)).thenAnswer((_) async {
      return RequestResult(
        true,
        {
          'success': true,
          'token': 'mock_token',
          'pseudo': 'testuser',
          'mail': 'testuser@example.com',
          'age': '25',
          'ville': 'Test City',
          'id': '123',
        },
      );
    });
    // Appuyez sur le bouton de connexion après avoir rempli les champs
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    // Vérifiez la navigation
    verify(mockObserver.didPush(any, any)).called(2);
  });
}
