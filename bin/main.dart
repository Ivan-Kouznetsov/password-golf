import 'package:password_golf/game.dart';
import 'package:password_golf/pwned_passwords_client.dart';
import 'dart:io';
import 'package:ansicolor/ansicolor.dart';
import 'dart:convert';
import 'package:path/path.dart' show dirname, join;

void main(List<String> arguments) async{
  //load settings if any
  var settings = _getSettings('settings.json');

  //optional colors
  color_disabled = arguments.isEmpty || arguments[0]!='-c';
  final yellowPen = AnsiPen()..yellow();
  final greenPen = AnsiPen()..green(bold:true);
  final cyanPen = AnsiPen()..cyan();

  const defaultRounds = 3;

  print(yellowPen('Password') + greenPen('Golf🚩 '));
  print(cyanPen('Rules:') + 'Try to guess which passwords have been exposed the fewest number of times, player with lowest score at the end of the last round wins.');
  stdout.write('Players:');
  final playerNames = stdin.readLineSync();

  int rounds;
  
  stdout.write('Number of rounds[${defaultRounds}]:');
  rounds = int.tryParse(stdin.readLineSync().trim()) ?? defaultRounds;
  
  final game = Game(settings.containsKey('url') ? PwnedPasswordsClient(settings['url']) : PwnedPasswordsClient(),
                    playerNames.trim().split(' '), 
                    rounds);

  await game.playGame();
  exit(1);
}

Map<String,dynamic> _getSettings(String filename){
  final fileUri = dirname(Platform.script.toString()) + '/${filename}';
  var settingsFile = File.fromUri(Uri.parse(fileUri));
  if (settingsFile.existsSync())
  {
    return json.decode(settingsFile.readAsStringSync());
  }
  else
  {
    return {};
  }
}