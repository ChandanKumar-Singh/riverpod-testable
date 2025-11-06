import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:testable/core/services/dio/api_service.dart';
import 'package:testable/core/services/dio/api_service_impl.dart';

import 'http_client_test.mocks.dart';

/// --------------------
/// Test Suite
/// --------------------

@GenerateMocks([AuthRepository, ApiService])
void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });
/* 
  testWidgets('Login button triggers login', (tester) async {
    await tester.pumpWidget(MyApp());
    await tester.enterText(find.byType(TextField), 'user@example.com');
    await tester.tap(find.text('Login'));
    await tester.pump();
    expect(find.text('Welcome'), findsOneWidget);
  }); */


  test('AuthRepository login returns true on successful login', () async {
    // Arrange
    when(
      mockAuthRepository.login('testuser', 'password123'),
    ).thenAnswer((_) async => true);
    // Act
    final result = await mockAuthRepository.login('testuser', 'password123');

    // Assert
    expect(result, isTrue);
    verify(mockAuthRepository.login('testuser', 'password123')).called(1);
  });
}
