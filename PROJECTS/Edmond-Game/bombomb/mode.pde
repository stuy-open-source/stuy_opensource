class mode{
  ArrayList<button>buttons = new ArrayList<button>();
  void _setup(){
  }
  void tick(){
  }
  void updateButtons(){
    for(int i = 0; i < buttons.size(); i++){
      buttons.get(i).tick();
    }
  }
}


class gameOver extends mode{
  void _setup(){
    background(#FF0000);
    buttons.add(new testButton(1,6,3,2));
  }
  void tick(){
    background(#FF0000);
    textSize(5 * scale);
    fill(0);
    text("R.I.P.",3 * scale,4.5 * scale);
    updateButtons();
  }
}


class testButton extends button{
  testButton(int x, int y,int xSize,int ySize){
    super(x,y,xSize,ySize);
  }
  void action(){
    Mode = new BomberMode();
    Mode._setup();
  }
  void pushed(){
  }
  void hover(){
    _draw();
  }
  void _draw(){
    super._draw();
    text("start",x,y,100,100);
  }
}


class mainMenu extends mode{
  void _setup(){
    buttons.add(new testButton(1,6,3,2));
  }
  void tick(){
    background(#F0F0F0);
    updateButtons();
  }
}


class BomberMode extends battleMode{
  void _setup(){
    super._setup();
    bombs = new oneWayLinkedList<unit>();
    playerBombs = new oneWayLinkedList<unit>();
    enemies = new oneWayLinkedList<unit>();
    players = new oneWayLinkedList<unit>();
    anime = new oneWayLinkedList<unit>();
    testUnit a = new testUnit(this, 1, 1, 0.5,0.5);
    players.add(a);
    enemies.add(new grunt(this, width-1, height-1,0.5,10,a));
    enemies.add(new grunt(this, width-1, 1,0.5,10,a));
    enemies.add(new grunt(this, 1, height-1,0.5,10,a));
  }
  void tick(){
    super.tick();
  }
}