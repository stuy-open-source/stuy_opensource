/*
CopyPasta
 
 Circle:
 float getXcor(){return xcor;}
 float getYcor(){return ycor;}
 float getSize(){return size;}
 void setXcor(float x){xcor = x;}
 void setYcor(float x){ycor = x;}
 void setSize(float x){size = x;}
 boolean hitCheckCircle(bullet Bullet){
 return Bullet.strikeCircle(this); 
 }
 
 Rectangle:
 float getXcor(){return xcor;}
 float getYcor(){return ycor;}
 float getSizeX(){return sizeX;}
 float getSizeY(){return sizeY;}
 float getAngle(){return angle;}
 void setXcor(float x){xcor = x;}
 void setYcor(float x){ycor = x;}
 void setSizeX(float x){sizeX = x;}
 void setSizeY(float x){sizeY = x;}
 void setAngle(float x){angle = x;}
 boolean hitCheckCircle(bullet Bullet){
 return Bullet.strikeRectangle(this);
 }
 */
 
void fade(PGraphics pic,float reduction){//beginDraw has already been called
  if(reduction == 0){
    return;
  }
 
 pic.loadPixels();
 //println( pic.pixels.length);
 for(int i = 0; i < pic.pixels.length;i++){
   float al = alpha(pic.pixels[i]) - pic.colorModeA * reduction;
   if(al < 0){
     al = 0;
   }
  pic.pixels[i] = color(red(pic.pixels[i]),green(pic.pixels[i]),blue(pic.pixels[i]),al);
 }
 pic.updatePixels();
 
 
}
boolean circleXcircle(circle a, circle b) {//target's hitbox is cicular
  return abs(a.getXcor() - b.getXcor()) + abs(a.getYcor() - b.getYcor()) <= (a.getSize() / 2) + (b.getSize() / 2);
}
boolean circleXrectangleHstanding(circle a,rectangle b) {//if angle is 90 or 270 degrees then tan(angle) will cause problems
  if (a.getXcor() >= b.getXcor() - b.getSizeY()/2 && a.getXcor() <= b.getXcor() + b.getSizeY()/2
    && a.getYcor() >= b.getYcor() - b.getSizeX()/2 && a.getYcor() <= b.getYcor() + b.getSizeX()/2) {
    return true;
  }
  return false;
}
boolean circleXrectangleHlaying(circle a,rectangle b) {//if angle is 0 ir 180 then slopeShort will have to divide by 0
  if (a.getXcor() >= b.getXcor() - b.getSizeX()/2 && a.getXcor() <= b.getXcor() + b.getSizeX()/2
    && a.getYcor() >= b.getYcor() - b.getSizeY()/2 && a.getYcor() <= b.getYcor() + b.getSizeY()/2) {
    return true;
  }
  return false;
}
boolean circleXrectangle(circle a,rectangle b) {
  if (b.getAngle() % 90 == 0 && b.getAngle() % 180 != 0) {
    return circleXrectangleHstanding(a,b);
  } else if (b.getAngle() % 180 == 0) {
    return circleXrectangleHlaying(a,b);
  }
  float slopeLong = tan(radians(b.getAngle()));
  float interceptLong = b.getYcor() - (b.getXcor() * slopeLong);
  float slopeShort = -1/slopeLong;
  float intersectX = (interceptLong - (a.getYcor() - (a.getXcor() * slopeShort)))/(slopeShort - slopeLong);
  float intersectY = intersectX * slopeLong + interceptLong;
  if (!(distanceEq(intersectX, intersectY, a.getXcor(), a.getYcor()) <= (b.getSizeY() / 2) + (a.getSize() / 2))) {
    return false;
  }
  float interceptShort = b.getYcor() - (b.getXcor() * slopeShort);
  intersectX = (interceptShort - (a.getYcor() - (a.getXcor() * slopeLong)))/(slopeLong - slopeShort);
  intersectY = intersectX * slopeShort + interceptShort;
  if (distanceEq(intersectX, intersectY, a.getXcor(), a.getYcor()) <= (b.getSizeX() / 2) + (a.getSize() / 2)) {
    return true;
  } else {
    return false;
  }
}


float toPositiveAngle(float angle) {//uses degrees
  if (angle < 0) {
    return 360 + (angle%360);
  } else {
    return angle%360;
  }
}
float distanceEq(float x1, float y1, float x2, float y2) {
  return sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2));
}
class Timer {
  public Timer() {
  }
  private long time;
  public void start() {
    time = System.currentTimeMillis();
  }
  public long stop() {
    return (System.currentTimeMillis() - time) / 1000;
  }
}


void centerWindow() {
  if (surface != null) {
    surface.setLocation(centerX, centerY);
  }
}
void centerWindow(PApplet x) {
  if (x.getSurface() != null) {
    x.getSurface().setLocation(x.displayWidth/2-x.width/2, x.displayHeight/2-x.height/2);
  }
}
String randomSelect(String[]x) {
  return x[int(random(x.length))];
}
boolean released(char targetKey) {//for regular keys
  if (releasedTick != tick) {
    return false;
  } else {
    if (!codedAndPushed) {
      return keyPushed == targetKey;
    } else {
      return false;
    }
  }
}
boolean released(int targetKey) {//for codedKeys
  if (releasedTick != tick) {
    return false;
  } else {
    if (codedAndPushed) {
      return keyPushed == targetKey;
    } else {
      return false;
    }
  }
}
int arrayIndex(String[]ary, String target) {
  for (int i = 0; i < ary.length; i++) {
    if (ary[i].equals(target)) {
      return i;
    }
  }
  return -1;
}
int arrayIndex(char[]ary, char target) {
  for (int i = 0; i < ary.length; i++) {
    if (ary[i] == target) {
      return i;
    }
  }
  return -1;
}
int arrayIndex(Object[]ary, Object target) {
  for (int i = 0; i < ary.length; i++) {
    if (ary[i] == target) {
      return i;
    }
  }
  return -1;
}
int arrayIndex(int[]ary, int target) {
  for (int i = 0; i < ary.length; i++) {
    if (ary[i] == target) {
      return i;
    }
  }
  return -1;
}
int positiveOrNegative() {
  if (random(100) > 50) {
    return 1;
  } else {
    return -1;
  }
}


class delay {
  int wait;
  int counter = 0;
  void setWait(float wait) {
    this.wait = int(wait * expectedFrameRate);
  }
  delay(float wait) {
    this.wait = int(wait * expectedFrameRate);
  }
  delay(float wait,boolean frames){
   if(frames){
     this.wait = int(wait);
   }
   else{
    this.wait = int(wait * expectedFrameRate);
   }
  }
  boolean every() {
    if (counter++ % wait == 0) {
      return true;
    } else {
      return false;
    }
  }
}


class charge {
  int wait;
  int counter = 0;
  charge(float wait) {
    this.wait = int(wait * expectedFrameRate);
  }
  void setWait(float wait) {
    this.wait = int(wait * expectedFrameRate);
  }
  boolean cooldown() {
    if (counter++ < wait) {
      return false;
    } else {
      return true;
    }
  }
  void resetCooldown() {
    counter = 0;
  }
  boolean cooldown(boolean activation) {
    if (cooldown() && activation) {
      resetCooldown();
      return true;
    } else {
      return false;
    }
  }
}
//bounds
/*boolean checkBounds(unit x,battleMode field){
 boolean r = false;
 if(x.xcor > field._width - (x.size / 2)){
 x.xcor = field._width - (x.size / 2);
 r = true;
 }
 else if(x.xcor < x.size / 2){
 x.xcor = x.size / 2;
 r = true;
 }
 if(x.ycor > field._height - (x.size / 2)){
 x.ycor = field._height - (x.size / 2);
 r = true;
 }
 else if(x.ycor < x.size / 2){
 x.ycor = x.size / 2;
 r = true;
 }
 return r;
 }
 int checkBoundsAdvanced(unit x,battleMode field){
 int r = 0;
 if(x.xcor > field._width - (x.size / 2)){
 x.xcor = field._width - (x.size / 2);
 r = 1;
 }
 else if(x.xcor < x.size / 2){
 x.xcor = x.size / 2;
 r = 2;
 }
 if(x.ycor > field._height - (x.size / 2)){
 x.ycor = field._height - (x.size / 2);
 r = 3;
 }
 else if(x.ycor < x.size / 2){
 x.ycor = x.size / 2;
 r = 4;
 }
 return r;
 }*/
boolean checkBoundsGhost(unit x, battleMode field) {
  if (x.xcor > field._width - (x.size / 2)) {
    return true;
  } else if (x.xcor < x.size / 2) {
    return true;
  }
  if (x.ycor > field._height - (x.size / 2)) {
    return true;
  } else if (x.ycor < x.size / 2) {
    return true;
  } else {
    return false;
  }
}
boolean checkDisplayBounds(unit x) {
  boolean r = false;
  if (x.getXcor() + centerX > displayWidth - (x.size / 2)) {
    x.xcor = (displayWidth - (x.size / 2)) - centerX;
    r = true;
  } else if (x.xcor + centerX < x.size / 2) {
    x.xcor = (x.size / 2) - centerX;
    r = true;
  }
  if (x.ycor + centerY > displayHeight - (x.size / 2)) {
    x.ycor = (displayHeight - (x.size / 2)) - centerY;
    r = true;
  } else if (x.ycor + centerY < x.size / 2) {
    x.ycor = (x.size / 2) - centerY;
    r = true;
  }
  return r;
}
boolean checkDisplayBoundsCircle(circle x) {
  boolean r = false;
  if (x.getXcor() + centerX > displayWidth - (x.getSize() / 2)) {
    x.setXcor((displayWidth - (x.getSize() / 2)) - centerX);
    r = true;
  } else if (x.getXcor() + centerX < x.getSize() / 2) {
    x.setXcor( (x.getSize() / 2) - centerX);
    r = true;
  }
  if (x.getYcor() + centerY > displayHeight - (x.getSize() / 2)) {
    x.setYcor((displayHeight - (x.getSize() / 2)) - centerY);
    r = true;
  } else if (x.getYcor() + centerY < x.getSize() / 2) {
    x.setYcor((x.getSize() / 2) - centerY);
    r = true;
  }
  return r;
}
boolean inBounds(unit x, battleMode field) {
  if (x.xcor > field._width - (x.size / 2)) {
    //x.xcor = field._width - (x.size / 2);
    return false;
  } else if (x.xcor < x.size / 2) {
    //x.xcor = x.size / 2;
    return false;
  }
  if (x.ycor > field._height - (x.size / 2)) {
    //x.ycor = field._height - (x.size / 2);
    return false;
  } else if (x.ycor < x.size / 2) {
    //x.ycor = x.size / 2;
    return false;
  }
  return true;
}

//circle bounds
boolean checkBounds(circle x, battleMode field) {
  boolean r = false;
  if (x.getXcor() > field._width - (x.getSize() / 2)) {
    x.setXcor(field._width - (x.getSize() / 2));
    r = true;
  } else if (x.getXcor() < x.getSize() / 2) {
    x.setXcor(x.getSize() / 2);
    r = true;
  }
  if (x.getYcor() > field._height - (x.getSize() / 2)) {
    x.setYcor(field._height - (x.getSize() / 2));
    r = true;
  } else if (x.getYcor() < x.getSize() / 2) {
    x.setYcor(x.getSize() / 2);
    r = true;
  }
  return r;
}
boolean checkDisplayBounds(PVector x) {//assumes its main window
  boolean r = false;
  if (x.x > mainWindow.width + centerX) {
    x.x = (mainWindow.width + centerX);
    r = true;
  } else if (x.x < 0 - centerX) {
    x.x = 0 - centerX;
    r = true;
  }
  if (x.y > mainWindow.height + centerY) {
    x.y=(mainWindow.height + centerY);
    r = true;
  } else if (x.y < 0-centerY) {
    x.y = 0-centerY;
    r = true;
  }
  return r;
}
int checkBoundsAdvanced(circle x, battleMode field) {
  int r = 0;
  if (x.getXcor() > field._width - (x.getSize() / 2)) {
    x.setXcor(field._width - (x.getSize() / 2));
    r = 1;
  } else if (x.getXcor() < x.getSize() / 2) {
    x.setXcor(x.getSize() / 2);
    r = 2;
  }
  if (x.getYcor() > field._height - (x.getSize() / 2)) {
    x.setYcor(field._height - (x.getSize() / 2));
    r = 3;
  } else if (x.getYcor() < x.getSize() / 2) {
    x.setYcor(x.getSize() / 2);
    r = 4;
  }
  return r;
}

public String Command(String arg) {
  String something = "";
  try {
    String command = arg;
    Process proc = Runtime.getRuntime().exec(command);

    // Read the output

    BufferedReader reader =
      new BufferedReader(new InputStreamReader(proc.getInputStream()));
    BufferedWriter reader1 = new BufferedWriter(new OutputStreamWriter(proc.getOutputStream()));

    String line = "";
    String line1 = "";
    while ((line = reader.readLine()) != null) {
      something += line + "\n";
    }
    proc.waitFor();
  }
  catch(Throwable e) {
    e.printStackTrace();
  }
  return something;
}