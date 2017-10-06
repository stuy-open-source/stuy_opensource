class battleMode extends mode{
  int _width = width;
  int _height = height;
  oneWayLinkedList<unit> bombs;
  oneWayLinkedList<unit> playerBombs;
  oneWayLinkedList<unit> enemies;
  oneWayLinkedList<unit> players;
  oneWayLinkedList<unit> anime; //this "anime" stands for animation, not the anime anime (lol)
  
  void _setup(){
    tick = 0;
  }
  void tick(){
    background(0);
    try{
    update(playerBombs,enemies);
    update(bombs,players);
    update(players);
    update(enemies);
    
    //note, animations don't use the _draw method, update includes draw. 
    update(anime);
    //Hence it must be placed in between the update and draw methods.
    
    _draw(playerBombs);
    _draw(enemies);
    _draw(players);
    _draw(bombs);
    }
    catch(NullPointerException e){
    }
  }
  void update(oneWayLinkedList<unit> a, oneWayLinkedList<unit> b){
    while(a.hasNext()){
      if(a.next().update(b)){
        a.getCurrent().death();
        a.remove();
      }
    }
    a.rewind();
  }
  void update(oneWayLinkedList<unit> x){
    while(x.hasNext()){
      if(x.next().update()){
        x.getCurrent().death();
        x.remove();
      }
    }
    x.rewind();
  }
  void _draw(oneWayLinkedList<unit> x){
    while(x.hasNext()){
      x.next()._draw();
    }
    x.rewind();
  }
}