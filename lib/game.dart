import 'dart:io';
import 'package:password_golf/player.dart';
import 'package:password_golf/pwned_passwords_client.dart';
import 'package:ansicolor/ansicolor.dart';

class Game{
  final List<Player> _players = [];
  int _rounds;
  PwnedPasswordsClient _client;

  var scorePen = AnsiPen()..yellow();
  var namePen = AnsiPen()..white(bold:true);
  var deathPen = AnsiPen()..red(bold:true);
  var winPen = AnsiPen()..cyan();

  Game(PwnedPasswordsClient client, List<String> playerNames, int rounds){
    _client = client;

    playerNames.forEach((name) {
      _players.add(Player(name));
    });

    print('${_players.length} have entered the game:');
    _players.forEach((player) {
      print(player.getName());
    });

    _rounds = rounds;
  }

  Game.fromPlayers(PwnedPasswordsClient client, List<Player> players, int rounds){
    _client = client;
    players.forEach((player) {
      _players.add(player);
    });
    _rounds = rounds;
  }

  List<Player> decideWinners(){
    // ignore: omit_local_variable_types
    List<Player> winners = [];
    final bestScore =(_players.where((player) => player.getScore()!=null).toList()..sort((a,b) => a.getScore().compareTo(b.getScore()))).first.getScore();
    
    _players.forEach((player) {
      if (player.getScore() == bestScore) winners.add(player);
    });

    return winners;
  }

  void playGame() async{
    for(var i=0;i<_rounds;i++){
      print('Round ${i+1}:');
      if (!await _playRound()) break;
    }

    var winners = decideWinners();
    if (winners.length==1){
      print('The winner is: ${namePen(winners[0].getName())} with a score of ${scorePen(winners[0].getScore().toString())}.');
    }else{
      print("It's tie between:");
      winners.forEach((winner) {
        print(namePen(winner.getName()) + ': ' + scorePen(winner.getScore().toString()));
      });
    }
  }

  Future<bool> _playRound() async{
    for(var i=0;i<_players.length;i++){
       final score = await _client.getCount(_getHiddenInput("${namePen(_players[i].getName())}'s turn:"));
      
       if (score == 0 || score == null)
       {
          print('\nThis password was not exposed.');
       }
       else if(score == 1){
          print(deathPen('\nSudden Death\n'));
          _players[i].recordScore(score);
          return false;
       }
       else
       {
          print('\nThis password was exposed ${scorePen(score.toString())} times.');
          _players[i].recordScore(score);
       }
       
       print("${namePen(_players[i].getName())}'s best score: ${scorePen(_players[i].getScore() == null ? 'None' : _players[i].getScore().toString())}");
    }
    return true;
  }

  String _getHiddenInput(String prompt){
    stdout.write(prompt);
    try{
      stdin.echoMode = false;
      final input = stdin.readLineSync();
      stdin.echoMode = true;
      return input;
    }catch(ex){
      // some terminals don't support stdin.echoMode = false;
      final input = stdin.readLineSync();
      return input;
    }    
  }
  
}