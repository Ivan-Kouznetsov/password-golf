import 'package:password_golf/game.dart';
import 'package:password_golf/pwned_passwords_client.dart';
import 'dart:io';

void main(List<String> arguments) async{

  const defaultRounds = 3;

  print('Password Golf');
  print('Rules: Try to guess which passwords have been exposed the fewest number of times, player with lowest score at the end of the last round wins.');
  stdout.write('Players:');
  final playerNames = stdin.readLineSync();

  int rounds;
  
  stdout.write('Number of rounds[${defaultRounds}]:');
  rounds = int.tryParse(stdin.readLineSync().trim()) ?? defaultRounds;
  
  final game = Game(PwnedPasswordsClient(), playerNames.trim().split(' '), rounds);

  await game.playGame();
  exit(1);
}
