class attractorTestEnvironment extends testEnvironment{
 attractor x;
 void _setup(){
  x = new attractor();
  x._setup();
  x.setForce(20);
  x.setDelay(new delay(0.1));
  x.setTarget(new PVector(8*scale,4.5*scale));
  x.setFade(0.1);
  x.setColour(color(0,0,255));
 }
 void tick(){
  x._draw(); 
 }
}
class manyWindowsTestEnvironment extends testEnvironment{
  battleMode x = new battleMode();
 void _setup(){
 }
 void tick(){
   createFieldPart(x,"test",100,100,200,200,false);
 }
}
class newWindowTestEnvironment extends testEnvironment{
  fieldPart x;
 void _setup(){
  //x = new fieldPart("test",500,500,500,100);
 }
}
class oneWayLinkedListTestEnvironment extends testEnvironment{
  void _setup(){
    oneWayLinkedList<Integer> x = new oneWayLinkedList<Integer>();
    oneWayLinkedListKey<Integer> k = x.createKey();
    x.add(0);
    x.add(1);
    x.add(2);
    x.add(3);
    x.add(4);
    x.add(5);
    x.add(6);
    String r = "";
    while(x.hasNext(k)){
      Integer a = x.next(k);
      r += a + " ";
      }
    System.out.println(r);
    //x.rewind(k);
    r = "";
    while(x.hasNext(k)){
      r += x.next(k) + " ";
    }
    System.out.println(r);
  }
  void tick(){
  }
}
class testEnvironment extends mode{
  void _setup(){
  }
  void tick(){
  }
}
class experimentTestEnironment extends testEnvironment{
  int x = 0;
  void _setup(){
  }
  void tick(){
    if(released('z')){
      System.out.println(x++);
    }
  }
}
class tempTestEnvironment extends testEnvironment{
  delay x;
  void _setup(){
    x = new delay(1);
  }
  void tick(){
    if(x.every()){
      println(mouseX + " " + mouseY);
    }
  }
}
class scrapTestEnvironment extends testEnvironment{
  void _setup(){
    System.out.println(10.5 % 5);
  }
}
class sizeTestEnvironment extends testEnvironment{
  void _setup(){
    rect(0 * scale,0 * scale, 1 * scale, 1 * scale);
  }
  void tick(){
  }
}
class soundTestEnvironment extends testEnvironment{
  
}
class robotTestEnvironment extends testEnvironment{
   void tick(){
     if(!keys[keyZ]){
       robot.keyPress(KeyEvent.VK_Z);
       robot.keyRelease(KeyEvent.VK_Z);
       //System.out.println("pressed");
     }
     if(released('z')){
       System.out.println('z');
     }
     if(keys[keyZ]){
       System.out.println('z');
     }
     System.out.println(keys[keyZ]);
   }
}
class testBattleMode extends battleMode{
      randomEdgeSpawner spawn;
      fieldPart window;
      unit a;
  void _setup(){
    super._setup();
   // playBgm(randomSelect(new String[]{"song1.mp3","song2.mp3","song3.mp3"}));
   playBgm("song2.mp3");
    a = new testunitA(this,0.5,0.5,0.20,0.5);
    if(debug){
      a.health = 100000;
    }
    else{
     a.health = 100; 
    }
    players.add(a);
    window = createFieldPart(this,"test",500,500,displayWidth / 2,displayHeight / 2,true);
    spawn = new randomEdgeSpawner(this,a);
    spawn.create();
    background(0);
  }
  void tick(){
    //System.out.println(frameRate);
    if(released('z')){
      //window = createFieldPart(this,"test",500,500,window.xcor,window.ycor,true);
    }
    spawn.spawn();
    super.tick();
    if(a.dead){
      window._exit();
      return;
    }
    if(keys[keyW]){
      window.move(0,-2);
    }
    if(keys[keyA]){
      window.move(-2,0);
    }
    if(keys[keyS]){
     window.move(0,2);
    }
    if(keys[keyD]){
      window.move(2,0);
    }
  }
}
class pushedTestEnvironment extends testEnvironment{
  void tick(){
    if(released('z')){
      System.out.println('z');
    }
    if(released('x')){
      System.out.println('x');
    }
    if(released(UP)){
      System.out.println("up");
    }
    if(released(DOWN)){
      System.out.println("down");
    }
  }
}
class delayAndCooldownTestEnvironment extends testEnvironment{
  int c = 0;
  int cc = 0;
  charge x;
  delay y;
  void _setup(){
    x = new charge(5);
    y = new delay(3);
  }
  void tick(){
    if(x.cooldown(keys[0])){
      System.out.println(c++);
    }
    if(y.every()){
     // System.out.println(cc++);
    }
  }
}
class testunit extends player implements circle{
  float getXcor(){return xcor;}
float getYcor(){return ycor;}
float getSize(){return size;}
void setXcor(float x){xcor = x;}
void setYcor(float x){ycor = x;}
void setSize(float x){size = x;}
boolean hitCheckCircle(bullet Bullet){
  return Bullet.strikeCircle(this); 
}
  float speed = 0.1 * scale;
  testunit(entity parent,battleMode field,float xcor,float ycor,float size,float displaySize){
    this.parent = parent;
    this.field = field;
    this.xcor = xcor;
    this.ycor = ycor;
    this.size = size;
    this.displaySize = displaySize;
    this.radius = this.size / 2;
    health = 100;
  }
  testunit(battleMode field,float xcor,float ycor,float size,float displaySize){
    this.field = field;
    this.xcor = xcor * scale;
    this.ycor = ycor * scale;
    this.size = size * scale;
    this.displaySize = displaySize * scale;
    this.radius = this.size / 2;
    health = 100;
  }
  int[] face = {-1,0};// -1 = up 1 = down, -1 = left 1 = right
  //face must never be {0,0}
  void move(){
    int a = face[0];
    int b = face[1];
    float mSpeed = speed;
    if(codedKeys[cKeySHIFT]){
      mSpeed *= 0.50;//focus speed ratio
    }
    if(codedKeys[cKeyUP] || codedKeys[cKeyDOWN] || codedKeys[cKeyLEFT] || codedKeys[cKeyRIGHT] && 
      !(codedKeys[cKeyUP] && codedKeys[cKeyDOWN] && codedKeys[cKeyLEFT] && codedKeys[cKeyRIGHT])){
      if(!(codedKeys[cKeyUP] && codedKeys[cKeyDOWN])){
        face[0] = 0;
        if(codedKeys[cKeyUP]){
          face[0]--;
          ycor -= mSpeed;
        }
        if(codedKeys[cKeyDOWN]){
          face[0]++;
          ycor += mSpeed;
        }
      }
      if(!(codedKeys[cKeyLEFT] && codedKeys[cKeyRIGHT])){
        face[1] = 0;
        if(codedKeys[cKeyLEFT]){
           face[1]--;
           xcor -= mSpeed;
        }
        if(codedKeys[cKeyRIGHT]){
          face[1]++;
          xcor += mSpeed;
        }
      }
      boolean noChange = keys[keyC];
      if(faceLock){
        noChange = !noChange;
      }
      if(noChange){
        face[0] = a;
        face[1] = b;
      }
      else{
      if(abs(face[0]) > 1){
        face[0] = abs(face[0]) / face[0];
      }
      if(abs(face[1]) > 1){
        face[1] = abs(face[1]) / face[1];
      }
      }
    }
  }
  bullet createbullet(){
    return new testbullet(this,field,xcor,ycor,0.2 * scale,BxVector * scale,ByVector * scale,10);
  }
  float BxVector;
  float ByVector;
  float spread = 0.05;
  boolean faceLock = false;
  void shoot(){
    if(codedKeys[cKeySHIFT]){
      spread = 0.015;
    }
    else{
      spread = 0.05;
    }
    BxVector = (face[1] * (0.3 + random(0.1))) + (random(spread) * positiveOrNegative());
      ByVector = (face[0] * (0.3 + random(0.1))) + (random(spread) * positiveOrNegative());
      field.playerBullets.add(createbullet());
  }
  charge zCooldown = new charge(0.1);
  void death(){
    super.death();
    Mode = new gameOver();
    Mode._setup();
  }
  boolean update(){
    if(health <=0){
      return true;
    }
    if(released(CONTROL)){
      faceLock = !faceLock;
    }
    move();
    checkBounds(this,field);
    if(codedKeys[cKeySHIFT]){
      zCooldown.setWait(0.075);
    }
    else{
      zCooldown.setWait(0.1);
    }
    if(zCooldown.cooldown(keys[keyZ])){
      //System.out.print("shoot");
      shoot();
    }
    return false;
  }
  String achievement = "status: trapped in a box of death";
  void trueDraw(float xcor, float ycor,PApplet applet){ 
    applet.fill(#00D81B);
    applet.ellipse(xcor,ycor,displaySize,displaySize);
    if(codedKeys[cKeySHIFT]){
      applet.fill(#FFFFFF);
      applet.ellipse(xcor,ycor,size,size);
    }
    if(health > 25){
      applet.fill(255);
    }
    else{
      applet.fill(#FF0000);
    }
    applet.stroke(255);
    applet.textSize(25);
    applet.text("hp: " + health + " kills: " + points + " time: " + tick / expectedFrameRate + " " + achievement,0,25);
  }
}
class testunitA extends testunit{
  windowMob test = null;
  testunitA(entity parent,battleMode field,float xcor,float ycor,float size,float displaySize){
    super(parent,field,xcor,ycor,size,displaySize);
    test = new windowMob(this);
    test.getSurface().setVisible(false);
  }
  testunitA(battleMode field,float xcor,float ycor,float size,float displaySize){
    super(field,xcor,ycor,size,displaySize);
    test = new windowMob(this);
    test.getSurface().setVisible(false);
  }
  bullet createbullet(){
    return new testbullet(this,field,xcor,ycor,0.2 * scale,BxVector * scale,ByVector * scale,10);
  }
  void death(){
    super.death();
    test._exit();
  }
  boolean visiable = false;
  int riftwalks = 0;
  void trueDraw(float xcor, float ycor,PApplet applet){
    super.trueDraw(xcor,ycor,applet);
    if(out && !visiable){
      test.getSurface().setVisible(true);
      visiable = true;
      test.loop();
      if(riftwalks++ < 10){
          achievement = "status: error404 player not found";
      }
      else{
          achievement = "D:< come back and die plz";
      }
    }
    if(!out && visiable){
      test.getSurface().setVisible(false);
      visiable = false;
      test.noLoop();
      if(riftwalks++ < 10){
        achievement = "status: hacks detected";
      }
      else{
        achievement = "so, how's the outside world?";
      }
    }
    if(out){
      
    }
  }
  boolean out = false;
  boolean update(){
    if(health <= 0){
      return true;
    }
    if(released(CONTROL)){
      faceLock = !faceLock;
    }
    move();
    checkDisplayBounds(this);
    if(inBounds(this,field)){
      out = false;
    }
    else{
      out = true;
    }
    if(zCooldown.cooldown(keys[keyZ])){
      //System.out.print("shoot");
      shoot();
    }
    return false;
  }
}

class testbullet extends bullet implements circle{
  boolean strikeRectangle(rectangle hitbox){
    return circleXrectangle(this,hitbox);
    }
  float getXcor(){return xcor;}
float getYcor(){return ycor;}
float getSize(){return size;}
void setXcor(float x){xcor = x;}
void setYcor(float x){ycor = x;}
void setSize(float x){size = x;}
boolean hitCheckCircle(bullet Bullet){
  return Bullet.strikeCircle(this); 
}
  //constructors
  testbullet(entity parent,battleMode field,float xcor,float ycor,float size,float xVector,float yVector,int damage){
    super(parent,field,xcor,ycor,size,xVector,yVector,damage);
   
  }
  testbullet(battleMode field,float xcor,float ycor,float size,float xVector,float yVector, int damage){
    this(null,field,xcor,ycor,size,xVector,yVector,damage);
    scaleVars();
  }
  
  //methods
  void trueDraw(float xcor, float ycor,PApplet applet){ 
    applet.fill(colour);
    //if(!checkBoundsGhost(this,field)){
      applet.ellipse(xcor,ycor,displaySize,displaySize);
    //}
  }
  boolean update(){
    xcor += vector[0];
    ycor += vector[1];
    if(checkDisplayBounds(this)){
      //println("dead");
      return true;
    }
    else{
      return false;
    }
  }
}


class Ebullet extends bullet implements circle{
  boolean strikeRectangle(rectangle hitbox){
    return circleXrectangle(this,hitbox);
    }
  float getXcor(){return xcor;}
float getYcor(){return ycor;}
float getSize(){return size;}
void setXcor(float x){xcor = x;}
void setYcor(float x){ycor = x;}
void setSize(float x){size = x;}
boolean hitCheckCircle(bullet Bullet){
  return Bullet.strikeCircle(this); 
}
  //constructors
   Ebullet(entity parent,battleMode field,float xcor,float ycor,float size,float xVector,float yVector,int damage){
    this.parent = parent;
    this.field = field;
    this.xcor = xcor;
    this.ycor = ycor;
    this.size = size;
    this.radius = this.size / 2;
    vector[0] = xVector;
    vector[1] = yVector;
    this.damage = damage;
    displaySize = size;
  }
  Ebullet(battleMode field,float xcor,float ycor,float size,float xVector,float yVector, int damage){
    this(null,field,xcor,ycor,size,xVector,yVector,damage);
    scaleVars();
  }
  
  boolean update(){
    xcor += vector[0];
    ycor += vector[1];
    if(checkBounds(this,field)){
      return true;
    }
    else{
      return false;
    }
  }
  
  //methods
  void trueDraw(float xcor, float ycor,PApplet applet){ 
    applet.fill(#1A03FC);
    applet.ellipse(xcor,ycor,displaySize,displaySize);
  }
}