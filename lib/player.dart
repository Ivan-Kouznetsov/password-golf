class Player{
  String _name;
  int _bestScore;

  Player(String name){
    _name=name;
  }

  void recordScore(int score){    
    if(score!=null){
      if (_bestScore == null){
        _bestScore = score;
      }else if (score < _bestScore){
        _bestScore = score;   
      }
    }
  }

  int getScore(){
    return _bestScore;
  }

  String getName(){
    return _name;
  }
}