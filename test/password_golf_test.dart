import 'package:password_golf/game.dart';
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

  test('should select winner whe other players have null scores', () {
    final players = <Player>[];  
    players.add(Player('a'));
    players.add(Player('b'));
    players.add(Player('c'));
    players[0].recordScore(10);

    final game = Game.fromPlayers(client, players, 1);
    expect(game.decideWinners()[0].getName(), 'a');
  });

  test('should select winner whe other players have not null scores', () {
    final players = <Player>[];
    players.add(Player('a'));
    players.add(Player('b'));
    players.add(Player('c'));
    players[0].recordScore(10);
    players[1].recordScore(5);
    players[2].recordScore(2);

    final game = Game.fromPlayers(client, players, 1);
    expect(game.decideWinners()[0].getName(), 'c');
  });
}
