class giantWormBossLevel extends battleMode{
  wormHead head;fieldPart fp;
  flipbook Animation1;
  delay de;
  charge coilAttack = new charge(3);
  boolean loadingScreen = true;
  @Override
  void _setup(){
    super._setup();
    buttons.add(new mmButton(14,8,2,1));
    if(loadingScreen){
      super._setup();
      testunitA xxx = new testunitA(this,0.5,0.5,0.20,0.5);
      players.add(xxx);
      xxx.health = 100000;
      head = makeWorm(this);
      de = new delay(2,true);
      if(graphicQuality != LOW_QUALITY){
        Animation1 = new flipbook("background1/frame_","_delay-0.21s.png",80,width,height);
        Mode = new loadingScreen(new flipbookThread(new flipbook[]{Animation1}),this);
      }
      loadingScreen = false;
      Mode._setup();
    }
    else{
      playBgm("song2.mp3");
      fp = createFieldPart(this,"worm",int(4 * scale),int(4*scale),int(head.getXcor() + centerX),int(head.getYcor() + centerY),true);
      setPhase(head);
    }
  }
  @Override
  void _background(PApplet applet){
    if(graphicQuality != LOW_QUALITY){
      if(de.every()){
        applet.background(Animation1.next());
      }
      else{
        applet.background(Animation1.current());
      }
    }
    else{
     background(0); 
    }
  }
  @Override
  void tick(){
    super.tick();
    centerWindow();
    if(debug){
      //println(frameRate);
    }
    //println(scale);
    //println(head.getAngle());
    if(keys[keyN]){
     head.accelerate(head.accel); 
    }
    if(keys[keyB]){
      head.turnRight(head.turnRate);
    }
    if(keys[keyV]){
      head.turnLeft(head.turnRate);
    }
    if(keys[keyM]){
      head.decelerate(head.decel);
    }
    if(keys[keyL]){
      wormBossOpening += -0.1 * scale;
    }
    if(keys[keyK]){
      wormBossOpening += 0.3 * scale;
      if(wormBossOpening > 0){
       wormBossOpening = 0; 
      }
    }
    if(coilAttack.cooldown(keys[keyJ])){
     head.nodeCommand = new wormNodeCoil()._setup(head);
    }
    if(keys[keyH]){
       head.chooseCommand(); 
    }
    if(!out){
      if(head.getXcor() < 0 || head.getXcor() > width || head.getYcor() < 0 || head.getYcor() > height){
        out = true;
        fp.loop();
        fp.vis();
      }
    }
    else{
      if(head.getXcor() >= 0 && head.getXcor() <= width && head.getYcor() >= 0 && head.getYcor() <= height){
       out = false;
       fp.invis();
       if(selectedWindow.focused){
         fp.noLoop();
       }
      }
    }
    checkDisplayBounds(head.location);
    centerWindow(mainWindow);
    fp.setLocation(int(head.getXcor() + centerX - fp.width/2),int(head.getYcor() + centerY - fp.height/2));
  }
  boolean out = false;
}
wormSegment getWormSegment(wormHead head,int index){
  wormSegment r = head;
  for(int i = 0;i < index;i++){
    r = head.backNode.backSegment;
  }
  return r;
}
void setPhase(wormSegment seg){
  int i = 0;
  while(seg.backNode.backSegment != null){
    seg.phase = 10;
    for(int ii = 0; ii < i;ii ++){
      seg.updateOrientation();
    }
    if(debug){
      println(seg.phase);
    }
    seg = seg.backNode.backSegment;
    i++;
  }
}
                       //sizeX,sizeY,angle,health,segments
float[] wormBossStats = {1,    0.5,  0,    2000,  16};
float wormBossOpening = 0 * scale;
float endFriction = 0.90;
float constantFriction = 0.90;
boolean snap = false;
boolean useConstantFriction = true;
wormHead makeWorm(battleMode field){
  float[]s = wormBossStats;
  wormHead head = new wormHead(field,width/scale - s[0]/2,s[1]/2,s[0],s[1],s[2],int(s[3]));
  wormSegment currentSegment = head.backNode.createSegment(s[0]*scale,s[1]*scale,s[2],int(s[3]));
  for(int n = 0;n < s[4] - 2;n++){
    currentSegment = currentSegment.createBackNode().createSegment(s[0]*scale,s[1]*scale,s[2],int(s[3]));
  }
  wormTail tail = currentSegment.createBackNode().createTail(s[0],s[1],s[2],int(s[3]));
  wormNode currentNode = head.backNode;
  for(int n = 0;n < s[4] - 1;n++){
    field.enemies.addLast(currentNode);
      currentNode.friction = 1 - n*((1 - endFriction)/s[4]);
    
    currentNode = currentNode.backSegment.backNode;
  }
   field.enemies.addLast(tail.backNode);//debug
   field.enemies.addLast(tail);
  currentSegment = head.backNode.backSegment;
  for(int n = 0;n < s[4] - 2;n++){
    field.enemies.addLast(currentSegment);
    currentSegment = currentSegment.backNode.backSegment;
  }
  field.enemies.addLast(head);
  currentNode = head.backNode;
  while(currentNode.backSegment != null){
    currentNode.leader = head;
    currentNode.backSegment.leader = head;
    currentNode = currentNode.backSegment.backNode;
  }
  return head;
}
abstract class wormSegmentCommand{
  abstract void tick(wormSegment x);
  wormSegmentCommand _setup(wormHead x){
    return this;
  }
  void end(wormHead x){
  }
}
abstract class wormNodeCommand{
  abstract void tick(wormNode x);
  wormNodeCommand _setup(wormHead x){
    return this;
  }
  void end(wormHead x){
  }
  void headMove(wormHead x){
  }
}
class wormSegmentMove extends wormSegmentCommand{
  void tick(wormSegment x){
    x.move();
  }
}
class wormNodeMove extends wormNodeCommand{
  void tick(wormNode x){
    x.move();
  }
  void headMove(wormHead x){
   x.move(); 
  }
}
class wormNodePathShoot extends wormNodePath{
  wormNodePathShoot(PVector p[],float[]s){
     super(p,s); 
  }
  wormNodePathShoot(PVector p[],float[]s,int nextMode){
     super(p,s,nextMode); 
  }
  void turnEffect(wormHead x){
    //normalBullet(entity parent,battleMode field,PVector location,PVector velocity,float size,int damage)
    unit target = x.findTarget();
    PVector targetLocation = new PVector(target.getXcor(),target.getYcor());
    for(float i = 1.2;i >= 0.8;i -= 0.2){
      wormSegment shooter = x.backNode.backSegment;
      x.field.bullets.add(new normalBullet(x,x.field,shooter.location.copy(),PVector.sub(targetLocation,shooter.location).setMag(speed[index - 1] * i),0.2 * scale,10));
      shooter = shooter.backNode.backSegment;
      x.field.bullets.add(new normalBullet(x,x.field,shooter.location.copy(),PVector.sub(targetLocation,shooter.location).setMag(speed[index - 1] * i),0.2 * scale,10));
      shooter = shooter.backNode.backSegment;
      x.field.bullets.add(new normalBullet(x,x.field,shooter.location.copy(),PVector.sub(targetLocation,shooter.location).setMag(speed[index - 1] * i),0.2 * scale,10));
      shooter = shooter.backNode.backSegment;
      x.field.bullets.add(new normalBullet(x,x.field,shooter.location.copy(),PVector.sub(targetLocation,shooter.location).setMag(speed[index - 1] * i),0.2 * scale,10));
      shooter = shooter.backNode.backSegment;
      x.field.bullets.add(new normalBullet(x,x.field,shooter.location.copy(),PVector.sub(targetLocation,shooter.location).setMag(speed[index - 1] * i),0.2 * scale,10));
    }
  }
  void endEffect(wormHead x){ 
    turnEffect(x);
  }
  
}
class wormNodePath extends wormNodeCommand{
 wormNodePath(PVector p[],float[]s){
  speed = s;
  path = p;
 }
 wormNodePath(PVector[] p,float[]s,int nextmode){
  this(p,s);
  nextMode = nextmode;
 }
 float[]speed;
 PVector[] path;
 int index = 0;
 int frames;
 boolean first = true;
 int nextMode = 0;
 void tick(wormNode x){
   x.move();
 }
 void turnEffect(wormHead x){
 }
 void firstEffect(wormHead x){
 }
 void endEffect(wormHead x){
 }
 void headMove(wormHead x){
   if(first){
     PVector target = path[index].copy();
     x.angle = degrees((target).sub(x.location).heading());
     x.velocity = PVector.fromAngle(radians(x.getAngle())).mult(speed[index]);
     frames = round(PVector.sub(path[index],x.location).mag()/x.velocity.mag());
     first = false;
     index++;
     firstEffect(x);
   }
   if(frames-- == 0){
      if(index < path.length){
        PVector target = path[index].copy();
        x.angle = degrees((target).sub(x.location).heading());
        x.velocity = PVector.fromAngle(radians(x.getAngle())).mult(speed[index]);
        frames = round(PVector.sub(path[index],x.location).mag()/x.velocity.mag());
        turnEffect(x);
      }
      else{
        endEffect(x);
        x.attackMode = nextMode;
        x.chooseCommand();
      }
      index++;
   }
   x.move();
 }
}
class wormNodeCoil extends wormNodeCommand{
 void tick(wormNode x){
    x.move();
 }
 attractor xx;
 PVector centerPoint;
 wormNodeCommand _setup(wormHead x){
  useConstantFriction = true;
  constantFriction = 0.7;
  x.limit = (40.0/90)*scale;
  x.velocity.setMag(0);
  //accel = (x.limit - x.velocity.mag())/(2.5 * expectedFrameRate);
  accel = (x.limit)/(2.5 * expectedFrameRate);
  decel = (x.limit)/(2.5 * expectedFrameRate);
  centerPoint = new PVector(x.getXcor(),x.getYcor());
  if(graphicQuality == LOW_QUALITY){
    return this;
  }
  else{
   xx = new quickAttractor(); 
  }
    xx._setup();
    xx.setForce(50);
    xx.setDelay(new delay(0.5));
    xx.setTarget(centerPoint);
    xx.setFade(0.1);
    xx.setColour(color(255));
  x.fxEffects = xx;
  return this;
 }
 float accel,decel;
 charge coilTime = new charge(5.5);
 charge phase1 = new charge(2.5);
 charge phase2 = new charge(1.5);
 float r = 8;
 float rChange = (10.125 - 8)/(1.5 * expectedFrameRate);
 void headMove(wormHead x){
   if(coilTime.cooldown()){
     x.faceTarget();
     x.attackMode = x.ATTACKREADY;
     x.fxEffects = null;
     for(int i = 0; i < 360; i++){
       x.field.bullets.add(new normalBullet(x,x.field,centerPoint.copy(),PVector.fromAngle(radians(random(360))).setMag(random((25.0/45)*scale) + 0.1 * scale),0.2 * scale,10));
     }
     x.chooseCommand();
   }
   else{
     if(!phase1.cooldown()){
       x.accelerate(accel);
       x.turnRight(r); 
       //xx.force++;
       x.field.bullets.add(new custerBomb(x,x.field,centerPoint.copy(),PVector.fromAngle(radians(random(360))).setMag((30.0/90)*scale),0.2 * scale,10));
     }
     else{
       if(!phase2.cooldown()){
         r += rChange;
         x.turnRight(r);
         //xx.force++;
       }
       else{
         x.decelerate(decel);
         x.turnRight(r);
       }
     }
   }
   x.move();
 }
}
class wormHead extends wormSegment{
  fx fxEffects = null;
  wormHead(battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
    this(null,field,xcor,ycor,sizeX,sizeY,angle,health);
    scaleVars();
    //frontNode = new wormNode(this,field,xcor + sizeX/2 + nodeSize/2,ycor,nodeSize,int(health * 0.75));
    backNode = new wormNode(null,field,this.xcor - cos(radians(this.angle))*((this.sizeX + getSizeY())/2),this.ycor - sin(radians(this.angle))*((this.sizeX + getSizeY())/2),getSizeY(),int(health * 0.75),this);
  }
  wormHead(entity parent,battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
     super(parent,field,xcor,ycor,sizeX,sizeY,angle,health);
     
   }
   wormSegmentCommand segmentCommand = new wormSegmentMove();
   wormNodeCommand nodeCommand = new wormNodeMove();
   wormSegmentCommand getSegmentCommand(){
     return segmentCommand;
   }
   wormNodeCommand getNodeCommand(){
     return nodeCommand;
   }
   unit target;
   unit findTarget(){
     oneWayLinkedListKey<unit> k = field.players.createKey();
     int r = int(random(field.players.size)) + 1;
    for(int i = 0; i < r; i++){
      if(field.players.hasNext(k)){
       field.players.next(k); 
      }
      else if(debug){
       println("bosses, unit findTarget(), linkedList error"); 
      }
    }
    return field.players.getCurrent(k);
   }
   void trueDraw(float xcor,float ycor,PApplet applet){
    super.trueDraw(xcor,ycor,applet);
    if(fxEffects != null && applet == mainWindow){
      fxEffects._draw();
    }
   }
   void faceTarget(){
    if(target == null){
     target = findTarget();
     if(target == null && debug){
       println("bosses, void faceTarget(), findTarget error");
     }
    }
    angle = degrees((new PVector(target.getXcor(),target.getYcor())).sub(location).heading());
    velocity = PVector.fromAngle(radians(angle)).mult(velocity.mag());
   }
   final int PASSIVE = 0;
   final int ATTACKREADY = 1;
   final int PATH = 2;
   int attackMode = PASSIVE;
   float limit = (25.0/90)*scale;
   float accel = (0.1/90)*scale;// 90 is the scale on my computer - edmond
   float decel = (0.2/90)*scale;
   float turnRate = 4;//10.125;
   void chooseCommand(){
     switch(attackMode){
      case PASSIVE:
        nodeCommand = new wormNodeMove()._setup(this);
        return;
      case ATTACKREADY:
          nodeCommand = new wormNodeMove()._setup(this);
          limit = (50.0/90) * scale;
          //faceTarget();
          accelerate((50.0/90) * scale);
          attackMode = PATH;
          return;
      case PATH:
          float a = (25.0/90)*scale;
          nodeCommand = new wormNodePathShoot(new PVector[]{new PVector(scale,scale),new PVector(15 * scale,scale),new PVector(15*scale,8*scale),new PVector(scale,8*scale),new PVector(scale,scale)},new float[]{a,a,a,a,a},PASSIVE);
          return;
     }
   }
   void accelerate(float x){
     float speed = velocity.mag();
     if(speed + x < 0){
       velocity.setMag(0);
       return;
     }
     if(speed == 0){
      velocity = PVector.fromAngle(radians(angle));
      velocity.setMag(x);
      return;
     }
     if(speed < limit){
       if(speed + x < limit){
         velocity.setMag(speed + x);
       }
       else{
         velocity.setMag(limit);
       }
     }
     else{
       velocity.setMag(limit);
     }
   }
   void decelerate(float x){
    accelerate(-1*x); 
   }
   void move(){
     setXcor(getXcor() + velocity.x);
     setYcor(getYcor() + velocity.y);
     setBackNode();
   }
   boolean update(){
     nodeCommand.headMove(this);
     contactDamage();
     return false;
   }
   void turnLeft(float degrees){//degrees is less than 90
     angle -= degrees;
     velocity.rotate(radians(-1*degrees));
   }
   void turnRight(float degrees){//degress is less than 90
     angle += degrees;
     velocity.rotate(radians(degrees));
   }
}
class wormTail extends wormSegment{
  wormTail(entity parent,battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
     super(parent,field,xcor,ycor,sizeX,sizeY,angle,health);
     createBackNode();
   }
   boolean update(){
     //backNode.update();
     return super.update();
   }
}
class wormNode extends unit implements circle{
  wormHead leader = null;
  PVector location;
  PVector targetLocation;
  float friction = 1;
  wormSegment frontSegment,backSegment;
  PVector velocity = new PVector(0,0);
  //float limit = 10;//change limit in wormSegment too
  float getXcor(){return location.x;}
  float getYcor(){return location.y;}
  float getSize(){return size;}
  void setXcor(float x){location.x = x;}
  void setYcor(float x){location.y = x;}
  void setSize(float x){size = x;}
  
  void contactDamage(){
     while(field.players.hasNext(_key)){
       unit target = field.players.next(_key);
       if(target instanceof circle && circleXcircle((circle)target,this)){
           hit(target);
       }
     }
   }
   void hit(unit x){
    x.health -= 10; 
   }
  boolean hitCheckCircle(bullet Bullet){
    if(backSegment != null){//last node (tail node) does not technically exist
      return Bullet.strikeCircle(this);
    }
    else{
      return false;
    }
  }
  oneWayLinkedListKey _key;
  wormSegment createSegment(float sizeX,float sizeY,float angle,int health){
    PVector l = PVector.add(location,PVector.fromAngle(radians(angle + 180)).mult((sizeX + getSize())/2));
    wormSegment newSegment = new wormSegment(this,field,l.x,l.y,sizeX,sizeY,angle,health);
    newSegment.frontNode = this;
    backSegment = newSegment;
    return newSegment;
  }
  
  wormTail createTail(float sizeX,float sizeY,float angle,int health){
    PVector l = PVector.add(location,PVector.fromAngle(radians(angle + 180)).mult((sizeX + getSize())/2));
    wormTail newSegment = new wormTail(this,field,l.x,l.y,sizeX,sizeY,angle,health);
    newSegment.frontNode = this;
    backSegment = newSegment;
    return newSegment;
  }
  //entity parent,battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health
  wormNode(wormNode parent,battleMode field,float xcor,float ycor,float size,int health,wormSegment frontSegment){
    super(parent,field,xcor,ycor);
    this.size = size;this.health = health;
    location = new PVector(xcor,ycor);
    this.frontSegment = frontSegment;
    _key = field.players.createKey();
  }
  boolean update(){
    if(parent != null){
       leader.getNodeCommand().tick(this);
    }
    contactDamage();
    return false;
  }
  void move(){
    if(velocity.mag() < 0.15){//friction
     velocity.set(0,0); 
    }
    else{
     if(useConstantFriction){
       velocity.mult(constantFriction);
     }
     else{
       velocity.mult(friction); 
     }
    }
    location.add(velocity);
    wormNode p = ((wormNode)parent);
    PVector targetLocation = p.location;
    PVector difference = PVector.sub(targetLocation,location);
    difference.setMag(difference.mag() - frontSegment.getSizeX() - (getSize() + (p.getSize()))/2 + wormBossOpening);
    velocity.add(difference);
    location.add(difference);
    PVector angle1 = PVector.fromAngle(radians(frontSegment.getAngle()));
    PVector angle2 = PVector.fromAngle(radians(p.frontSegment.getAngle()));
    float diff = angle2.heading() - angle1.heading();
    //println(tan(radians(p.frontSegment.getAngle())));
    if(abs(diff) > HALF_PI){
      //float t = tan(radians(p.frontSegment.getAngle()));
      //pDir = dir;
      //dir = (t > 0);
        //dir = true;
        //boolean x = diff > 0;
        //if(pDir != dir){x = !x; dir = false;}
        
        //if(keys[keyM]){
        //  x = !x;
        //}
       // PVector oldLocation = location;
       if(snap){
        if(diff <= 0){
          PVector a = new PVector(-angle2.y,angle2.x).setMag(frontSegment.getSizeX() + (getSize() + p.getSize())/2).add(targetLocation);
         location = a;
        }
        else if (diff > 0){
          PVector b = new PVector(-angle2.y,angle2.x).setMag(frontSegment.getSizeX() + (getSize() + p.getSize())/2).add(targetLocation);
         location = b;
        }}
        //println(100.0 / scale);
        //if(abs(getYcor() - pycor) > 1 * scale){
         // location = oldLocation;
        //}
      /*}
      else{
       boolean x = diff > 0;
       if(dir){x = !x; dir = false;}
        if(x){
         location = angle2.rotate(HALF_PI).setMag(frontSegment.getSizeX() + (getSize() + p.getSize())/2).add(targetLocation);
        }
        else{
         location = angle2.rotate(-1*HALF_PI).setMag(frontSegment.getSizeX() + (getSize() + p.getSize())/2).add(targetLocation);
        }
      }*/
    }
    pxcor = getXcor();
        pycor = getYcor();
  }
  float pxcor;
  float pycor;
  @Override
  void _draw(){
   trueDraw(location.x,location.y,mainWindow); 
  }
  @Override
  void trueDraw(float xcor,float ycor,PApplet applet){
    if(backSegment == null){return;}
    applet.fill(#300DFF);
    applet.stroke(#300DFF);
    applet.ellipse(xcor,ycor,size,size);
  }
}
class wormSegment extends unit implements rectangle{
  //for wiggle animation
  final float[]wiggleAnimation = {-2,-1.9,-1.8,-1.7,-1.6,-1.5,-1.4,-1.3,-1.2,-1.1,0,1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,2};
  boolean back = true;
  int phase = -1;
  //
  wormHead leader = null;
  PVector velocity = new PVector(0,0);
  PVector location;
   wormNode frontNode;
   wormNode backNode;
   //float nodeSize = 0.5 * scale;
   float velocityX = 0;
   float velocityY = 0;
   float angle,sizeX,sizeY;
   float getXcor(){return location.x;}
   float getYcor(){return location.y;}
   float getSizeX(){return sizeX;}
   float getSizeY(){return sizeY;}
   float getAngle(){return angle;}
   void setXcor(float x){location.x = x;}
   void setYcor(float x){location.y = x;}
   void setSizeX(float x){sizeX = x;}
   void setSizeY(float x){sizeY = x;}
   void setAngle(float x){angle = x;}
   boolean hitCheckCircle(bullet Bullet){
    return Bullet.strikeRectangle(this);
   }
   wormSegment(){}
   wormSegment(entity parent,battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
     super(parent,field,xcor,ycor);
     this.sizeX = sizeX;this.sizeY = sizeY;this.health = health;this.angle = angle;
     location = new PVector(xcor,ycor);
     _key = field.players.createKey();
   }
   oneWayLinkedListKey<unit> _key;
   wormNode createBackNode(){
    return backNode = new wormNode(frontNode,field,this.xcor - cos(radians(this.angle))*((this.sizeX + getSizeY())/2),this.ycor - sin(radians(this.angle))*((this.sizeX + getSizeY())/2),getSizeY(),int(health * 0.75),this); 
   }
   delay wiggleDelay = new delay(2,true);
   boolean update(){
     leader.getSegmentCommand().tick(this);
     contactDamage();
     if(wiggleDelay.every()){
       updateOrientation();
     }
     return false;
   }
   void contactDamage(){
     while(field.players.hasNext(_key)){
       unit target = field.players.next(_key);
       if(target instanceof circle && circleXrectangle((circle)target,this)){
           hit(target);
       }
     }
   }
   void hit(unit x){
    x.health -= 10; 
   }
   void move(){
     angle = degrees(PVector.sub(frontNode.location,backNode.location).heading());
     //location = PVector.fromAngle(radians(angle)).mult(((backNode.getSize() + getSizeX())/2)).add(backNode.location);
     location = PVector.add(frontNode.location,backNode.location).mult(0.5);
   }
   void scaleVars(){
    super.scaleVars();
    sizeX *= scale;
    sizeY *= scale;
    location.mult(scale);
   }
   void setBackNode(){
    backNode.setXcor(getXcor() - cos(radians(angle))*((sizeX + backNode.getSize())/2));
    backNode.setYcor(getYcor() - sin(radians(angle))*((sizeX + backNode.getSize())/2)); 
   }
   @Override
   void _draw(){
       trueDraw(location.x,location.y,mainWindow); 
   }
   void updateOrientation(){
     if(phase != -1){
       if(phase == wiggleAnimation.length - 1 || phase == 0){
          back = !back;
       }
       if(back){
         phase--;
       }
       else{
         phase++;
         }
     }
   }
   @Override
   void trueDraw(float xcor,float ycor,PApplet applet){
     applet.pushMatrix();
     applet.stroke(#00F2FC);
     if(phase == 0){
       applet.fill(#FF0000);
     }
     else{
       applet.fill(#FFFFFF);
     }
     
     applet.translate(xcor,ycor);
     if(phase == -1){
       applet.rotate(radians(angle));
     }
     else{
         applet.rotate(radians(angle + wiggleAnimation[phase]));
     }
       
     
     applet.rect(sizeX/-2,sizeY/-2,sizeX,sizeY);
     applet.popMatrix();
   }
}





class Metropolis extends battleMode{
  @Override
  void _setup(){
    super._setup();
    player a = new testunitA(this,0.5,0.5,0.20,0.5);
    players.add(a);
    enemies.add(new Lula(this,10,5,0.4,0.6,a));
    //enemies.add(BunBun(Lula,stuff));
    //Lula.setChild(BunBun);
  }
  @Override
  void tick(){
    super.tick();
  }
}
class Lula extends unit implements rectangle{
  void setChild(Lula _child){
    this.child = _child;
  }
  
  float getXcor(){return location.x;}
  float getYcor(){return location.y;}
  float getSizeX(){return sizeX;}
  float getSizeY(){return sizeY;}
  float getAngle(){return radians(0);}
  void setXcor(float x){xcor = x;}
  void setYcor(float x){ycor = x;}
  void setSizeX(float x){sizeX = x;}
  void setSizeY(float x){sizeY = x;}
  void setAngle(float x){float angle = x;}
  boolean hitCheckCircle(bullet Bullet){
     return Bullet.strikeRectangle(this);
  }
  
  
  float sizeX,sizeY;
  float mvtspeed = 2;
  PVector ploc;
  PVector location;
  PVector velocity;
  boolean[] ActOptions = new boolean[5]; //0 p>2.5x, 1 p>1.5x, 2 p>r, 3 is BunBun alive?
  boolean[] isAttackingStill = new boolean[5]; //0 miniCBs, 1 DuoAttack
  Lula child;
  boolean alive = true;
  boolean indanger;
  entity player;
  
  Lula(battleMode field,float xcor,float ycor,float _width,float _height,entity player){
    super();
    this.field = field;
    this.sizeX = _width*scale;
    this.sizeY = _height*scale;
    location = new PVector(xcor*scale,ycor*scale);
    velocity = new PVector(0,0);
    this.player = player;
    ploc = new PVector(player.getXcor(),player.getYcor());
    health = 100;
    setXcor(xcor*scale);
    setYcor(ycor*scale);
  }
  Lula(){}
  
  
  void getVelocityTo(float _speed){
    PVector direction = ploc.sub(location);
    direction.normalize();
    direction.mult(-1*_speed);
    velocity = direction;
  }
  
  void actions(){
    if (ActOptions[0]){
      attack();
    }
    if(ActOptions[1]){
      if(isAttackingStill[0]){
        attack();
      }else{
        if((int)(Math.random()*3) == 0){
          attack();
          move();
        }else{
          move();
        }
      }
    }
    if(ActOptions[2]){
      move();
    }
    if(indanger){
      if(isAttackingStill[1]){
        //DuoAttack();
      }else{
        //DuoAttack();
      }
    }
  }
  
 
  void move(){
    getVelocityTo(mvtspeed);
    /*if(abs(location.x-0)<abs(location.y-0) || 
       abs(location.x-0)<abs(location.y-height) || 
       abs(location.x-width)<abs(location.y-0) || 
       abs(location.x-width)<abs(location.y-height)){
      PVector a = new PVector(-1*velocity.y, velocity.x);
      location.add(a);
      System.out.println(location);
    }else{
      PVector b = new PVector(velocity.y,-1*velocity.x);
      location.add(b);
      System.out.println(location);
    }*/
    location.add(velocity);
  }
  
  charge basic = new charge(4);
  charge special = new charge(7);
  charge basiclength = new charge(0.5);
  int miniCBamt = 0;
  void attack(){
    if(isAttackingStill[0]){
      if(basiclength.cooldown()){
        basiclength.resetCooldown();
        throwMiniCB();
        miniCBamt++;
      }
      if(miniCBamt == 3){
        basiclength.resetCooldown();
        miniCBamt = 0;
        isAttackingStill[0] = false;
      }
    }else{
      if(basic.cooldown()){
        basic.resetCooldown();
        throwMiniCB();
        miniCBamt++;
        isAttackingStill[0] = true;
      }else{
        if(special.cooldown()){
          special.resetCooldown();
          throwBigCB();
        }
      }
    }
  }
  
  void bunBunDied(){
    this.ActOptions[4] = false;
    this.health = 15;
  }
  
  void checkStatus(){//in boundscheck check if ActOptions[4] then checkStatus()
    alive = child.alive;
    if(!alive){
      bunBunDied();
    }
  }
  
  void death(){}
  void throwMiniCB(){
    field.bullets.add(createMiniCB());
  }
  bullet createMiniCB(){//gotta modify this
    return new CB(this,field,getXcor(),getYcor(),0.2 * scale,ploc.sub(location).normalize(),10, ploc);
  }
  void throwBigCB(){
    field.bullets.add(createBigCB());
  }
  bullet createBigCB(){//gotta modify this
    return new CB(this,field,getXcor(),getYcor(),0.4 * scale,ploc.sub(location).normalize(),20, ploc);
  }
  void DuoAttack(){}
  float r = 2*scale;
  void boundsCheck(){
    if(abs(ploc.x-getXcor())+abs(ploc.y-getYcor())<(4.5*r)){
      ActOptions[0] = false;
      if(abs(ploc.x-getXcor())+abs(ploc.y-getYcor())<(2.5*r)){
        ActOptions[1] = false;
        if(abs(ploc.x-getXcor())+abs(ploc.y-getYcor())<r){
          ActOptions[2] = false;
          indanger = true;
        }else{ActOptions[2] = true;}
      }else{ActOptions[1] = true;ActOptions[2] = false;}
    }else{ActOptions[0] = true;ActOptions[1] = false;ActOptions[2] = false;}
    
    if(ActOptions[3]){
      checkStatus();
    }
    
    if(location.x<0){
      location = new PVector(0,location.y);
    }
    if(location.x>width){
      location = new PVector(width,location.y);
    }
    if(location.y<0){
      location = new PVector(location.x,0);
    }
    if(location.y>height){
      location = new PVector(location.x,height);
    }
  }
  
  boolean update(){ 
    if(ActOptions[4] == false && health < 0){return true;}
    ploc = new PVector(player.getXcor(), player.getYcor());
    boundsCheck(); //checks if Lula's on screen and updates ActOptions
    actions();
    return false;
  }
  @Override
  void trueDraw(float xcor,float ycor,PApplet applet){
    pushMatrix();
    stroke(#000000);
    fill(#E07407);
    translate(xcor,ycor);
    rotate(radians(0));
    rect(sizeX/-2,sizeY/-2,sizeX,sizeY);
    popMatrix();
  }
}

class CB extends bullet implements circle{
  //constructors + variables
  float getXcor(){return location.x;}
  float getYcor(){return location.y;}
  float getSize(){return size;}
  void setXcor(float x){xcor = x;}
  void setYcor(float x){ycor = x;}
  void setSize(float x){size = x;}
  boolean hitCheckCircle(bullet Bullet){
    throw new UnsupportedOperationException();
  }
  
  int damage;
  float[] vector = new float[2];
  int colour = #FF0000;
  PVector location;
  PVector velocity;
  PVector ploc;
  CB(){
  }
  CB(entity parent,battleMode field,float xcor,float ycor,float size,PVector vector,int damage,PVector _ploc){
    this.parent = parent;
    this.field = field;
    location = new PVector(xcor,ycor);
    this.size = size;
    this.radius = this.size / 2;
    velocity = vector;
    this.damage = damage;
    this.displaySize = this.size;
    ploc = _ploc;
    setXcor(xcor);
    setYcor(ycor);
    velocity.mult(scale*0.13);
  }
  CB(battleMode field,float xcor,float ycor,float size,PVector vector,int damage,PVector ploc){
    this(null,field,xcor,ycor,size,vector,damage,ploc);
    scaleVars();
  }
  void scaleVars(){
   super.scaleVars();
   velocity.mult(scale*2);
  }
  
  //methods
  boolean hit(unit target){
    target.health -= damage;
    return true;
  }
  boolean update(){
    travel();
    if(checkBounds(this,field)){
      return true;
    }
    else{
      return false;
    }
  }
  int t = 0;
  void travel(){
    t++;
    //float z = (0.5*-9.8*t*t) + velocity.mag();
    PVector a = new PVector(velocity.x,velocity.y);
    location.add(a);
  }
  void death(){
  }
  boolean strikeCircle(circle hitbox){//target's hitbox is cicular
   return abs(getXcor() - hitbox.getXcor()) + abs(getYcor() - hitbox.getYcor()) <= (getSize() / 2) + (hitbox.getSize() / 2); 
  }
  boolean strikeStandingRect(rectangle hitbox){//if angle is 90 or 270 degrees then tan(angle) will cause problems
    if(getXcor() >= hitbox.getXcor() - hitbox.getSizeY()/2 && getXcor() <= hitbox.getXcor() + hitbox.getSizeY()/2
      && getYcor() >= hitbox.getYcor() - hitbox.getSizeX()/2 && getYcor() <= hitbox.getYcor() + hitbox.getSizeX()/2){
       return true; 
      }
      return false;
  }
  boolean strikeLayingRect(rectangle hitbox){//if angle is 0 ir 180 then slopeShort will have to divide by 0
     if(getXcor() >= hitbox.getXcor() - hitbox.getSizeX()/2 && getXcor() <= hitbox.getXcor() + hitbox.getSizeX()/2
      && getYcor() >= hitbox.getYcor() - hitbox.getSizeY()/2 && getYcor() <= hitbox.getYcor() + hitbox.getSizeY()/2){
       return true; 
      }
      return false;
  }
  boolean strikeRectangle(rectangle hitbox){
    if(hitbox.getAngle() % 90 == 0 && hitbox.getAngle() % 180 != 0){
      return strikeStandingRect(hitbox);
    }
    else if(hitbox.getAngle() % 180 == 0){
      return strikeLayingRect(hitbox);
    }
    float slopeLong = tan(radians(hitbox.getAngle()));
    float interceptLong = hitbox.getYcor() - (hitbox.getXcor() * slopeLong);
    float slopeShort = -1/slopeLong;
    float intersectX = (interceptLong - (getYcor() - (getXcor() * slopeShort)))/(slopeShort - slopeLong);
    float intersectY = intersectX * slopeLong + interceptLong;
    if(!(distanceEq(intersectX,intersectY,getXcor(),getYcor()) <= (hitbox.getSizeY() / 2) + (getSize() / 2))){
      return false;
    }
      float interceptShort = hitbox.getYcor() - (hitbox.getXcor() * slopeShort);
      intersectX = (interceptShort - (getYcor() - (getXcor() * slopeLong)))/(slopeLong - slopeShort);
      intersectY = intersectX * slopeShort + interceptShort;
      if(distanceEq(intersectX,intersectY,getXcor(),getYcor()) <= (hitbox.getSizeX() / 2) + (getSize() / 2)){
       return true; 
      }
      else{
        return false;
      }
    }
  boolean update(oneWayLinkedList<unit> x){
    boolean a = update();
    while(x.hasNext()){
      unit target = x.next();
      if(target.hitCheckCircle(this)){//bullet is cicular
        if(hit(target)){
          return true;
        }
        else{
          return a;
        }
      }
    }
   
    return a;
  }
  void trueDraw(float xcor, float ycor,PApplet applet){ 
    applet.fill(colour);
    applet.ellipse(xcor,ycor,displaySize,displaySize);
  }
}




/*
hitCheckCircle(bullet x){
    if(x.strikeCircle()){
         if(stamina > 0){
              stamina--;
               return false;
             }
          else{
                 return true;
           }
         }
      else{ return false;}
}
*/


/*
class BunBun extends Lula implements rectangle{
  float getXcor(){return location.x;}
  float getYcor(){return location.y;}
  float getSizeX(){return sizeX;}
  float getSizeY(){return sizeY;}
  float getAngle(){return radians(0);}
  boolean hitCheckCircle(bullet Bullet){
     return Bullet.strikeRectangle(this);
  }
  
  float sizeX,sizeY;
  float mvtspeed = 0.75 * scale;
  PVector ploc;
  PVector location;
  PVector velocity;
  boolean[] ActOptions = new boolean[3]; //0 p>=2.5x, 1 p>x, 2 p<=x
  boolean[] isAttackingStill = new boolean[5]; //0 charge, 1 kicks, 2 punchcombo, 3 armhammer
  boolean alive = true;
  Lula parent;
  
  BunBun(Lula parent, battleMode field,float xcor,float ycor,float _width,float _height,PVector playerlocation){
    super();
    this.field = field;
    location = new PVector(xcor,ycor);
    this.xcor = location.x;
    this.ycor = location.y;
    this.sizeX = _width*scale;
    this.sizeY = _height*scale;
    velocity = new PVector(0,0);
    ploc = playerlocation;
    health = 100;
    this.parent = parent;
  }
  
  boolean update(){ 
    if(health < 0){alive = !alive; return true;}
    boundsCheck(); //checks if BunBun's on screen and updates ActOptions
    actions();
    return false;
  }
  
  void actions(){
    if (ActOptions[0] || isAttackingStill[0]){
      chargeattack();
    }
    if(ActOptions[1] || isAttackingStill[1]){
      kickattack();
    }
    if(ActOptions[2] || isAttackingStill[2] || isAttackingStill[3]){
      armsattack();
    }
    if(parent.indanger){
      DuoAttack();
    }
  }
  
 
  void move(speed){
    if(abs(ploc.x-locationx)+abs(ploc.y-location.y)>(sizeX*2)){
      getVelocityTo(speed);
      location.add(velocity);
    }
  }
  
  charge basic = new charge(7);
  charge special = new charge(15);
  charge basiclength = new charge(2);
  void chargeattack(){
    if(isAttackingStill[0]){
      location.add(velocity);
        basiclength.resetCooldown();
        throwMiniCB();
        miniCBamt++;
      }
      if(miniCBamt == 3){
        basiclength.resetCooldown();
        miniCBamt = 0;
        isAttackingStill = false;
      }
    }else{
      if(basic.cooldown()){
        basic.resetCooldown();
        throwMiniCB();
        miniCBamt++;
        isAttackingStill = true;
      }else{
        if(special.cooldown()){
          special.resetCooldown();
          throwBigCB();
        }
      }
    }
  }
  
  void switchStatus(){
    alive = !alive;
  }
  
  void death(){}
  void throwMiniCB(){}
  void throwBigCB(){}
  void DuoAttack(){}
  void boundsCheck(){}
  
  void trueDraw(){}
}


*/