import 'dart:io';
import 'package:password_golf/player.dart';
import 'package:password_golf/pwned_passwords_client.dart';

class Game{
  final List<Player> _players = [];
  int _rounds;
  PwnedPasswordsClient _client;

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
      print('The winner is: ${winners[0].getName()} with a score of ${winners[0].getScore()}.');
    }else{
      print("It's tie between:");
      winners.forEach((winner) {
        print(winner.getName() + ': ' + winner.getScore().toString());
      });
    }
  }

  Future<bool> _playRound() async{
    for(var i=0;i<_players.length;i++){
       final score = await _client.getCount(_getHiddenInput("${_players[i].getName()}'s turn:"));
      
       if (score == 0 || score == null)
       {
          print('This password was not exposed.');
       }
       else if(score == 1){
          print('\nSudden Death\n');
          _players[i].recordScore(score);
          return false;
       }
       else
       {
          print('This password was exposed ${score} times.');
          _players[i].recordScore(score);
       }
       
       print("${_players[i].getName()}'s best score: ${_players[i].getScore() ?? 'None'}");
    }
    return true;
  }

  String _getHiddenInput(String prompt){
    stdout.write(prompt);
    stdin.echoMode = false;
    final input = stdin.readLineSync();
    stdin.echoMode = true;

    return input;
  }
  
}