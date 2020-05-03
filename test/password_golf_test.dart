import 'package:password_golf/player.dart';
import 'package:password_golf/pwned_passwords_client.dart';
import 'package:test/test.dart';

void main() {
  final client = PwnedPasswordsClient();
  test('should get password count when provided with an exposed password', () async {    
    expect(await client.getCount('password'), greaterThan(1));
  });

  test('should get password count of 0 when provided with a password that is not exposed', () async {  
    expect(await client.getCount('batteryhorsestaplecorrect'), 0);
  });

  test('should record score', () async {
    final player = Player('name');
    player.recordScore(10);
    expect(player.getScore(), 10);
  });
}
