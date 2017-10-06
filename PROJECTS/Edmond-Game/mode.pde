class button{
  //constructor + variables
  float sizeX,sizeY,x,y,x1,y1;
  int colour = #FFFFFF;
  boolean STROKE = true;
  //include pic, hover animation, and pressed pic
  button(float x,float y,float sizeX,float sizeY){
    this.x = x * scale;
    this.y = y * scale;
    this.sizeX = sizeX * scale;
    this.sizeY = sizeY * scale;
    x1 = this.x + this.sizeX;
    y1 = this.y + this.sizeY;
  }
  
  //methods
  void action(){
  }
  void pushed(){
  }
  void hover(){
    _draw();
  }
  void _draw(){
    if(STROKE){
      stroke(0);
    }
    else{
      noStroke();
    }
    strokeWeight(1);
    fill(colour);
    rect(x,y,sizeX,sizeY);
  }
  button setColor(int c){
    colour = c;
    return this;
  }
  button setStroke(boolean b){
    STROKE = b;
    return this;
  }
  void tick(){
    if(mouseX >= x && mouseX <= x1 && mouseY >= y && mouseY <= y1){
      if(mousePressed){
        pushed();
      }
      else{
        if(pmousePressed){
          action();
        }
        else{
          hover();
        }
      }
    }
    else{
      _draw();
    }
  }
}
class mode{
  boolean clear = true;
  mode(){}
  ArrayList<button>buttons = new ArrayList<button>();
  void _setup(){
    if(clear){
       clearWindows(); 
    }
  }
  void tick(){
  }
  boolean newMode = false;
  void updateButtons(){
    for(int i = 0; i < buttons.size(); i++){
      if(newMode){
        break;
      }
      buttons.get(i).tick();
    }
  }
}


class gameOver extends mode{
  void _setup(){
    super._setup();
    background(#FF0000);
    buttons.add(new testButton(1,6,3,2));
    buttons.add(new muteButton(4,6));
    buttons.add(new mmButton(5,6,3,2));
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
  testButton(float x, float y,float xSize,float ySize){
    super(x,y,xSize,ySize);
  }
  void action(){
    Mode = new testBattleMode();
    Mode._setup();
  }
  void pushed(){
  }
  void hover(){
    _draw();
  }
  void _draw(){
    super._draw();
    fill(0);
    textSize(25);
    text("Test Game",x+sizeX/4,y+sizeY/2.5,400,400);
  }
}


class muteButton extends button{
  muteButton(float x,float y){
    super(x,y,1,1);
  }
  muteButton(float x,float y,float w,float h){
    super(x,y,w,h);
  }
  PImage mutedButton = loadImage("muteButtonMuted.png");
  PImage unmutedButton = loadImage("muteButton.png");
  void action(){
    muted = !muted;
    if(muted){
      bgmMute();
    }
    else{
      refreshBgmVolume();
    }
  }
  void pushed(){
  }
  void hover(){
    _draw();
  }
  void _draw(){
    if(muted){
      image(mutedButton,x,y,sizeX,sizeY);
    }
    else{
      image(unmutedButton,x,y,sizeX,sizeY);
    }
  }
}
String graphicQualityToString(){
  int[]q = {LOW_QUALITY,DEFAULT_QUALITY,HIGH_QUALITY};
  String[]s = {"LOW_QUALITY","DEFAULT_QUALITY","HIGH_QUALITY(LAG)"};
  return s[arrayIndex(q,graphicQuality)];
}
class qualityButton extends button{
  qualityButton(float x,float y,float sizeX,float sizeY){
   super(x,y,sizeX,sizeY); 
  }
  void action(){
    int[] q = new int[]{LOW_QUALITY,DEFAULT_QUALITY,HIGH_QUALITY};
    int index = arrayIndex(q,graphicQuality);
    if(index >= q.length - 1){
      index = 0;
    }
    else{
      index++;
    }
    graphicQuality = q[index];
  }
  void _draw(){
    super._draw();
    fill(0);
    textSize(25);
    text("Graphic Quality:" + graphicQualityToString(),x + 0.1*scale,y + sizeY/2 - 0.1*scale); 
  }
  
}
class loadingScreen extends mode{
  void _setup(){
    super._setup();
    if(random(100) < 50){
      animation = new circlesAnimation();
      ((circlesAnimation)animation)._setup();
    }
    else{
      animation = new rectanglesAnimation(); 
      ((rectanglesAnimation)animation)._setup();
    }
    t.start();
    s = new float[]{1 * scale,8 * scale,14 * scale,0.5 * scale};
    half = s[3] / 2.0;
    background(0);
  }
  fx animation;
  float[] s;
  float difference;
  float half;
  void tick(){
    if(t.done){
      strokeWeight(1);
      Mode = previousMode;
      previousMode._setup();
    }
    else{
      animation._draw();
      noStroke();
      fill(#FF0009);
      rect(s[0],s[1],s[2],s[3]); 
      fill(#00FF28);
      rect(s[0],s[1],s[2] * t.mainLoadingBar(),half);
      fill(#0006FF);
      rect(s[0],s[1] + half,s[2] * t.currentLoadingBar(),half);
    }
  }
  flipbookThread t;
  mode previousMode;
  loadingScreen(flipbookThread _t,mode _previousMode){
    t = _t;
    previousMode = _previousMode;
  }
}

class mainMenu extends mode{
  mainMenuAnimation anime = new mainMenuAnimation();
  void _setup(){
    super._setup();
    ((mainMenuAnimation)anime)._setup();
    buttons.add(new testButton(1,6,3,2).setColor(#CBFDFF).setStroke(false));
    buttons.add(new muteButton(4,1).setColor(#CBFDFF).setStroke(false));
    buttons.add(new MetropolisButton(1,3.5,3,2).setColor(#CBFDFF).setStroke(false));
    buttons.add(new WormButton(1,1,3,2).setColor(#CBFDFF).setStroke(false));
    buttons.add(new qualityButton(5,1,6,1).setColor(#CBFDFF).setStroke(false));
    buttons.add(new creditsButton(14,8,2,1).setColor(#CBFDFF).setStroke(false));
    //playBgm(randomSelect(new String[]{"song1.mp3","song2.mp3","song3.mp3"}));
    playBgm("loopdeloop.wav");
  }
  void tick(){
    println(frameRate);
    background(255);
    //anime._drawBg();
    //anime._drawFg();
    if(graphicQuality != LOW_QUALITY){
      updateButtons();
      anime._draw();
    }
    else{
      updateButtons();
    }
  }
}


class MetropolisButton extends button{
  MetropolisButton(float x, float y,float xSize,float ySize){
    super(x,y,xSize,ySize);
  }
  void action(){
    Mode.newMode = true;
    Mode = new Metropolis();
    Mode._setup();
  }
  void pushed(){
  }
  void hover(){
    _draw();
  }
  void _draw(){
    super._draw();
    fill(0);
    textSize(25);
    text("Metropolis Level",x+(x/3),y+(y/4.3),500,500);
  }
}
class WormButton extends button{
  WormButton(float x, float y,float xSize,float ySize){
    super(x,y,xSize,ySize);
  }
  void action(){
    Mode.newMode = true;
    Mode = new giantWormBossLevel();
    Mode._setup();
  }
  void pushed(){
  }
  void hover(){
    _draw();
  }
  void _draw(){
    super._draw();
    fill(0);
    textSize(25);
    text("Worm Level",x+(x/1.5),y+(y/1.2),500,500);
  }
}
class creditsButton extends button{
  creditsButton(float x,float y,float xSize,float ySize){
     super(x,y,xSize,ySize);
  }
  void action(){
     Mode.newMode = true;
     Mode = new credits();
     Mode._setup();
  }
  void pushed(){ 
  }
  void hover(){
    _draw();
  }
  void _draw(){
    super._draw();
    fill(0);
    textSize(25);
    text("credits",x+sizeX/4,y+sizeY/2.5,400,400);
  }
}
class credits extends mode{
  void _setup(){
    super._setup();
    buttons.add(new mmButton(14,8,2,1));
  }
  int y = height;
  void tick(){
   fill(255);
   background(0);
   textSize(16);
   text("Credits:\n\nGame:\nEdmond Wong\nEmily Wang\n\nMain Menu Music:\nEvan Wong",10,y--);
   updateButtons();
  }
}

class mmButton extends button{
  mmButton(int x, int y,int xSize,int ySize){
    super(x,y,xSize,ySize);
  }
  void action(){
    Mode.newMode = true;
    Mode = new mainMenu();
    Mode._setup();
  }
  void pushed(){
  }
  void hover(){
    _draw();
  }
  void _draw(){
    super._draw();
    fill(0);
    textSize(25);
    text("Main Menu",x+sizeX/4,y+sizeY/2.5,400,400);
  }
}