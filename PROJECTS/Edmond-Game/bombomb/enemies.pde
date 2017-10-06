class grunt extends unit{
  grunt(battleMode field, float xcor, float ycor, float size, int health, unit player){
    this.health = health;
    this.field = field;
    this.xcor = xcor;
    this.ycor = ycor;
    this.size = size * scale;
    this.player = player;
  }
  
  unit player;
  charge basic = new charge(0.2);
  float angle = 0;
  float speed = 0.075 * scale;
  int[] face = {-1,1};// -1 = up 1 = down, -1 = left 1 = right
  boolean update(){
    if(health <= 0){return true;}
    
    
    int a = checkBoundsAdvanced(this,field);
    float changeX = sin(radians(angle)) * speed;
    float changeY = sin(radians(angle)) * speed;
    if(a != 0){
      if(a == 1 || a == 2){
        angle = angle + 90;
      }
      else{
        angle = angle + 180;
      }
    }
    angle = angle % 360;
    xcor += changeX;
    ycor += changeY;
    angle += positiveOrNegative() * random(5);
    angle = angle % 360;
    
    
    if(basic.cooldown()){
      basic.resetCooldown();
      placeb(0.2 * scale, 10);
    }
    return false;
  }
  void death(){
    player.points++;
  }
  void placeb(float size,int damage){
      field.players.rewind();
      field.bombs.add(new bomb(this,field,xcor+(face[0] * size),ycor+(face[1] * size),size,damage));
  }
  void _draw(){
    fill(#00FAF8);
    ellipse(xcor,ycor,size,size);
  }
}