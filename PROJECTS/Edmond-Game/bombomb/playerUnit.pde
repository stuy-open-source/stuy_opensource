class player extends unit{
}
class testUnit extends player{
  float speed = 0.15 * scale;
  testUnit(entity parent,battleMode field,float xcor,float ycor,float size,float displaySize){
    this.parent = parent;
    this.field = field;
    this.xcor = xcor;
    this.ycor = ycor;
    this.size = size;
    this.displaySize = displaySize;
    this.radius = this.size / 2;
    health = 100;
  }
  testUnit(battleMode field,float xcor,float ycor,float size,float displaySize){
    this.field = field;
    this.xcor = xcor * scale;
    this.ycor = ycor * scale;
    this.size = size * scale;
    this.displaySize = displaySize * scale;
    this.radius = this.size / 2;
    health = 100;
  }
  
  int[] face = {-1,1};// -1 = up 1 = down, -1 = left 1 = right
  void move(){
   if(codedKeys[cKeyUP]){
     ycor -= speed;
     face[0] = -1;
   }
   if(codedKeys[cKeyDOWN]){
     ycor += speed;
     face[0] = 1;
   }
   if(codedKeys[cKeyLEFT]){
     xcor -= speed;
     face[1] = -1;
   }
   if(codedKeys[cKeyRIGHT]){
     xcor += speed;
     face[1] = 1;
   }
  }
  
  
  bomb createb(){
    return new bomb(this, field, xcor+(face[0]*10), ycor+(face[1]*10), 0.2 * scale, 10);
  }
  void placeb(){
      field.playerBombs.add(createb());
  }
  
  void death(){
    Mode = new gameOver();
    Mode._setup();
  }
  
  charge bombCooldown = new charge(1);
  boolean update(){
    if(health <=0){
      return true;
    }
    move();
    checkBounds(this,field);
    if(bombCooldown.cooldown(keys[keyZ])){
      placeb();
      bombCooldown.resetCooldown();
    }
    return false;
  }
  
  void _draw(){
    fill(#00D81B);
    ellipse(xcor,ycor,displaySize,displaySize);
    if(health > 25){
      fill(255);
    }
    else{
      fill(#FF0000);
    }
    textSize(25);
    text("hp: " + health + " kills: " + points + " time: " + tick / expectedFrameRate,0,25);
  }
}