ArrayList<fieldPart>newWindows = new ArrayList<fieldPart>();
void clearWindows(){
  int i = newWindows.size();
  while(i-- > 0){
    newWindows.get(0).kill();
    newWindows.remove(0);
  }
}
class window extends PApplet{
  window(String name){
    super();
    PApplet.runSketch(new String[]{name},this);
  }
  int sizeX;
  int sizeY;
  void settings(){
  }
  void setup(){
  }
  void draw(){
  }
  void keyPressed(){
    KP(this);
  }
  void keyReleased(){
    KR(this);
  }
}
synchronized fieldPart createFieldPart(battleMode field,String name, int Width, int Height, int xcor, int ycor,boolean onTop){
  newWindowWidth = Width;
  newWindowHeight = Height;
  fieldPart x = new fieldPart(field,name,xcor,ycor,onTop);
  newWindows.add(x);
  return x;
}
int newWindowWidth,newWindowHeight;//to be used only by fieldPart;
class fieldPart extends PApplet{
  fieldPart(battleMode field,String name,int xcor, int ycor, boolean onTop){
    super();
    this.xcor = xcor;
    this.ycor = ycor;
    this.onTop = onTop;
    this.name = name;
    this.field = field;
    visiable = true;
    PApplet.runSketch(new String[]{name},this);
  }
  void kill(){
    dispose();
    frame.setVisible(false);
  }
  String name;
  int Width,Height,xcor,ycor;
  boolean onTop;
  boolean visiable;
  battleMode field;
  oneWayLinkedListKey<unit>[] keys;
  void settings(){
    size(newWindowWidth,newWindowHeight);
  }
  void invis(){
   visiable = false;
   getSurface().setVisible(false);
  }
  void vis(){
   visiable = true;
   getSurface().setVisible(true);
  }
  void setup(){
    if(graphicQuality == HIGH_QUALITY){
       frameRate(60);  
    }
    else{
      frameRate(20);
    }
    getSurface().setAlwaysOnTop(onTop);
    getSurface().setLocation(xcor,ycor);
    keys = new oneWayLinkedListKey[field.drawables.length];
    for(int i = 0;i < keys.length;i++){
     keys[i] = field.drawables[i].createKey();
    }
  }
  void draw(){
    getSurface().setLocation(xcor,ycor);
    drawAll(field);
  }
  void skin(){
    field.partBackground(this);
  }
  void drawAll(battleMode field){
    skin();
   for(int i = 0; i < field.drawables.length; i++){
    _draw((oneWayLinkedList<unit>)field.drawables[i],keys[i]);
   }
  }
  void keyPressed(){
    KP(this);
  }
  void keyReleased(){
    KR(this);
  }
  void move(int x, int y){
   xcor = xcor + x;
   ycor = ycor + y;
  }
  void setLocation(int x,int y){
   xcor = x;
   ycor = y;
  }
  void _exit(){
   dispose();
   getSurface().setVisible(false); 
  }
  void _draw(oneWayLinkedList<unit>x,oneWayLinkedListKey<unit> k){
   while(x.hasNext(k)){
      try{
      unit b = x.next(k);
      int trueXcor = int(b.getXcor() + centerX);
      int trueYcor = int(b.getYcor() + centerY);
      if(trueXcor < xcor + width && trueXcor >=xcor && trueYcor < ycor + height && trueYcor >= ycor){
        b.trueDraw(trueXcor - xcor,trueYcor - ycor,this);
      }
      }
      catch(NullPointerException e){
      }
    } 
  }
}
class windowMob extends window{
  //windowMob still needs a bit tuneing
  //either the equation is slightly off or there is a small percentage error due to only being to use ints when setting location
  unit target;
  windowMob(unit target){
   super("windowMob");
   this.target = target;
 }
 void settings(){
    sizeX = int(2 * scale);
    sizeY = int(2 * scale);
    if(sizeY < 100){
      sizeY = 100;
    }
    if(sizeX < 100){
      sizeX = 100;
    }
    println(sizeX + " " + sizeY);
    size(sizeX,sizeY);
  }
  void setup(){
    if(graphicQuality == HIGH_QUALITY){
      frameRate(60);
    }
    else{
      frameRate(30);
    }
    centerWindow();
    getSurface().setAlwaysOnTop(true);
    noLoop();
    //windowPosX += target.displaySize / 2;
    //windowPosY += target.displaySize / 2;
  }
  //pos of target
  //pos of main window, not pos of windowMob
  int windowPosX = ((displayWidth/2- mainWindow.width/2) - sizeX / 2);
  int windowPosY = ((displayHeight/2- mainWindow.height/2) - sizeY / 2);
  int xcor = 0;
  int ycor = 0;
  void draw(){
    centerWindow();
    background(0);
    getSurface().setLocation(xcor = (windowPosX + round(target.xcor)),ycor = (windowPosY + round(target.ycor)));
        _draw(target.field.playerBullets,#FF0000);
        _draw(target.field.bullets,#1A03FC);
    fill(#00D81B);
    ellipse(sizeX / 2,sizeY / 2,target.displaySize,target.displaySize);
    if(codedKeys[cKeySHIFT]){
      fill(#FFFFFF);
      ellipse(sizeX/2,sizeY/2,target.size,target.size);
    }
  }
  void _exit(){
   dispose();
   getSurface().setVisible(false); 
  }
  void keyPressed(){
    KP(this);
  }
  void keyReleased(){
    KR(this);
  }
  void _draw(oneWayLinkedList<unit> x,color ccc){
    oneWayLinkedListKey<unit> k = x.createKey();
    while(x.hasNext(k)){
      try{
      unit b = x.next(k);
      int trueXcor = int(b.xcor + centerX);
      int trueYcor = int(b.ycor + centerY);
      if(trueXcor < xcor + width && trueXcor >=xcor && trueYcor < ycor + height && trueYcor >= ycor){
        fill(ccc);
        ellipse(trueXcor - xcor,trueYcor - ycor,b.size,b.size);
      }
      }
      catch(NullPointerException e){
      }
    }
    
  }
}