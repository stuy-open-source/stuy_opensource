class bomb extends unit{
  //constructors + variables
  int damage;
  bomb(){
  }
  bomb(entity parent, battleMode field, float xcor, float ycor, float size, int damage){
    this.parent = parent;
    this.field = field;
    this.xcor = xcor;
    this.ycor = ycor;
    this.size = size;
    this.radius = this.size / 2;
    this.damage = damage;
  }
  bomb(battleMode field, float xcor, float ycor, float size, int damage){
    this.field = field;
    this.xcor = xcor * scale;
    this.ycor = ycor * scale;
    this.size = size * scale;
    this.radius = this.size / 2;
    this.damage = damage;
  }
  
  //methods
  boolean hit(unit target){
    target.health -= damage;
    return true;
  }
  
  boolean update(){
    if (boom){
      boomduration++;
    }
    if (boomduration % 2 == 0){ //bombs last for only 2 ticks(?)
      boom = false;
      return true;
    }
    if(checkBounds(this,field)){
      return true;
    }
    else{
      return false;
    }
  }
  
  void death(){
  }
  
  delay Boomtimer = new delay(4);
  boolean boom = false;
  int boomduration = 0;
  
  boolean update(oneWayLinkedList<unit> x){
    boolean a = update();
    if (Boomtimer.every()){
      boom = !boom;
      boomduration++;
    }
    while(boom){
      unit target = x.next();
      if(abs(xcor - target.xcor) + abs(ycor - target.ycor) <= size){
        if(hit(target)){
          return true;
        }
        else{
          return a;
        }
      }
    }
    x.rewind();
    return a;
  }
  
  void _draw(){
    if(boom){
        fill(#FF0000);
    }
    else{
        fill(#000000);
    }
    ellipse(xcor,ycor,size,size);
  }
}