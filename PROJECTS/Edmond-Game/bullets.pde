abstract class bullet extends unit{
  //constructors + variables
  int damage;
  float[] vector = new float[2];
  int colour = #FF0000;
  bullet(){
  }
  bullet(entity parent,battleMode field,float xcor,float ycor,float size,float xVector,float yVector,int damage){
    super(parent,field,xcor,ycor);
    this.size = size;
    this.radius = this.size / 2;
    vector[0] = xVector;
    vector[1] = yVector;
    this.damage = damage;
    this.displaySize = this.size;
  }
  bullet(battleMode field,float xcor,float ycor,float size,float xVector,float yVector, int damage){
    this(null,field,xcor,ycor,size,xVector,yVector,damage);
    scaleVars();
  }
  float getSize(){throw new UnsupportedOperationException();}
  float getXcor(){return xcor;}
  float getYcor(){return ycor;}
  void setXcor(float x){xcor = x;}
  void setYcor(float x){ycor = x;}
  boolean hitCheckCircle(bullet Bullet){
    throw new UnsupportedOperationException();
  }
  void scaleVars(){
   super.scaleVars();
   vector[0] *= scale;
   vector[1] *= scale;
  }
  //methods
  boolean hit(unit target){
    target.health -= damage;
    return true;
  }
  abstract boolean update();
  /*
    xcor += vector[0];
    ycor += vector[1];
    if(checkBounds(this,field)){
      return true;
    }
    else{
      return false;
    }*/
  void death(){
  }
  boolean strikeCircle(circle hitbox){//target's hitbox is cicular
  //println("hi");
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
     if(getXcor() >= hitbox.getXcor() - hitbox.getSizeX()/2 && xcor <= hitbox.getXcor() + hitbox.getSizeX()/2
      && getYcor() >= hitbox.getYcor() - hitbox.getSizeY()/2 && ycor <= hitbox.getYcor() + hitbox.getSizeY()/2){
       return true; 
      }
      return false;
  }
  abstract boolean strikeRectangle(rectangle hitbox);//{
    //return circleXrectangle((circle)this,hitbox);
    //}
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

class normalBullet extends bullet implements circle{
 normalBullet(entity parent,battleMode field,PVector location,PVector velocity,float size,int damage){
   this.parent = parent;
   this.field = field;
   this.location = location;
   this.size = size;
   this.radius = size / 2;
   this.damage = damage;
   this.velocity = velocity;
 }
 PVector velocity;
 color colour = #2C9EFF;
 PVector location;
 float getXcor(){return location.x;}
 float getYcor(){return location.y;}
 float getSize(){return size;}
 void setXcor(float x){location.x = x;}
 void setYcor(float x){location.y = x;}
 void setSize(float x){size = x;}
 boolean hitCheckCircle(bullet Bullet){
   return Bullet.strikeCircle(this); 
 }
 boolean update(){
   location.add(velocity);
   return checkDisplayBoundsCircle(this);
 }
 boolean strikeRectangle(rectangle hitbox){
    return circleXrectangle(this,hitbox);
    }
 void trueDraw(float xcor,float ycor,PApplet applet){
  applet.noStroke();
  applet.fill(colour);
  applet.ellipse(xcor,ycor,size,size);
  applet.strokeWeight(1);
 }
}
float gravity = 0;
void setupGravity(){
  gravity = (0.75 * scale)/expectedFrameRate;
}
class spark extends normalBullet{
  spark(entity parent,battleMode field,PVector location,PVector velocity,float size,int damage,color _color){
    super(parent,field,location,velocity,size,damage);
    colour = _color;
    pastLocation = location;
  }
  int counter = 0;
  PVector pastLocation;
  boolean update(){
   velocity.y += gravity;
   if(counter++ % 2 == 0){
     pastLocation = location.copy();
   }
   return super.update();
  }
  @Override
  void trueDraw(float xcor,float ycor,PApplet applet){
   applet.stroke(colour);
   applet.strokeWeight(size);
   applet.line(location.x,location.y,pastLocation.x,pastLocation.y);
   applet.strokeWeight(1);
  }
  
}
class custerBomb extends normalBullet{
  custerBomb(entity parent,battleMode field,PVector location,PVector velocity,float size,int damage){
    super(parent,field,location,velocity,size,damage);
  }
  custerBomb(entity parent,battleMode field,PVector location,PVector velocity,float size,int damage,int clock){
    super(parent,field,location,velocity,size,damage);
    counter = clock * expectedFrameRate;
  }
  int counter = 20;
  boolean update(){
   if(counter-- == 0){
     colorMode(HSB,100);
     float s = 0.05 * scale;
     float sp = 0.1 * scale;
     for(int i = 0; i < 6;i++){
      field.bullets.add(new spark(this,field,location.copy(),PVector.fromAngle(radians(i * (180/5) + 180)).setMag(sp),s,damage,color(random(360),99,99)));
     }
     colorMode(RGB,255,255,255);
     return true;
   }
   else{
     return super.update();
   }
  }
}