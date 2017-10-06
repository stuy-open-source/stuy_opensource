class grunt extends unit implements circle{
  float getXcor(){return xcor;}
   float getYcor(){return ycor;}
   float getSize(){return size;}
   void setXcor(float x){xcor = x;}
void setYcor(float x){ycor = x;}
void setSize(float x){size = x;}
   boolean hitCheckCircle(bullet Bullet){
    return Bullet.strikeCircle(this); 
   }
  grunt(battleMode field, float xcor, float ycor, float size,int health,unit player){
    this.health = health;// + int(tick / 60 * 0.1);
    this.field = field;
    this.xcor = xcor;
    this.ycor = ycor;
    this.size = size * scale;
    this.player = player;
  }
  unit player;
  delay special = new delay(5);
  charge basic = new charge(0.2);
  float angle = 0;
  float speed = 0.075 * scale;
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
        angle = angle + 90;
      }
    }
    angle = angle % 360;
    xcor += changeX;
    ycor += changeY;
    angle += positiveOrNegative() * random(5);
    angle = angle % 360;
    if(basic.cooldown()){
      basic.resetCooldown();
      shoot(0.2 * scale,10,(0.05 + random(0.03)) * scale);
    }
    if(special.every()){
      shoot(0.5 * scale,30,(0.05 + random(0.1)) * scale);
    }
    return false;
  }
  void death(){
    player.points++;
  }
  void shoot(float size,int damage,float speed){
      //field.players.rewind();
      float BxVector = player.xcor - xcor;
      float ByVector = player.ycor - ycor;
      float fireAngle;
      if(player.ycor < ycor){
          fireAngle = (degrees(atan(BxVector / ByVector)) + 180 +(positiveOrNegative() * random(3))) % 360;
      }
      else{
        fireAngle = (degrees(atan(BxVector / ByVector))+(positiveOrNegative() * random(2))) % 360;
      }
      testbullet x = (new testbullet(this,field,xcor,ycor,size,sin(radians(fireAngle)) * speed,cos(radians(fireAngle)) * speed,damage));
      x.colour = #1A03FC;
      field.bullets.add(x);
  }
  void trueDraw(float xcor, float ycor, PApplet applet){ 
    applet.fill(#00FAF8);
    applet.ellipse(xcor,ycor,size,size);
  }
}


class randomEdgeSpawner{
  charge spawnRate = new charge(5);
  battleMode field;
  unit player;
  randomEdgeSpawner(battleMode field, unit player){
    this.field = field;
    this.player = player;
  }
  void create(){
    field.enemies.add(new grunt(field, random(width), random(height / 20),0.5,10,player));
  }
  void spawn(){
    if(spawnRate.cooldown(field.enemies.size <= 10)){
      create();
    }
    if(field.enemies.size <= 3){
      spawnRate.setWait(2);
    }
    else{
      spawnRate.setWait(5);
    }
  }
}