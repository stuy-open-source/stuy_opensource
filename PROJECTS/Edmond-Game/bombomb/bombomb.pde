import java.util.ArrayList;
import java.awt.Robot;
import java.lang.Math;
import java.awt.event.KeyEvent;
import java.awt.MouseInfo;
import java.awt.Point;

Robot robot;
PApplet mainWindow;
mode Mode;
int expectedFrameRate;
void setup(){
  frameRate(60);
  mainWindow = this;
  expectedFrameRate = 60;
  surface.setResizable(true);
  centerWindow();
  Mode = new mainMenu();
  Mode._setup();
  try{
  robot = new Robot();
  }
  catch(Throwable e){
    e.printStackTrace();
  }
}

//draw + variables
int tick = 0;
boolean pmousePressed;
void draw(){
  try{
    Mode.tick();
    pmousePressed = mousePressed;
    tick++;
  }
  catch(Throwable e){
    e.printStackTrace();
    noLoop();
  }
}

//keyboard + variables
char[]_keys = {'z','x','c'};
int keyZ = 0;int keyX = 1;int keyC = 2;
boolean[]keys = new boolean[_keys.length];
int[] _codedKeys = {UP,DOWN,LEFT,RIGHT};
int cKeyUP = 0;
int cKeyDOWN = 1;
int cKeyLEFT = 2;
int cKeyRIGHT = 3;
boolean[]codedKeys = new boolean[_codedKeys.length];
int keyPushed;
boolean codedAndPushed = false;
int releasedTick;
void KP(PApplet x){
  checkKey(true,x);
}
void KR(PApplet x){
  releasedTick = tick;
  if(x.key == CODED){
    keyPushed = x.keyCode;
    codedAndPushed = true;
  }
  else{
    keyPushed = x.key;
    codedAndPushed = false;
  }
  checkKey(false,x);
}
void keyPressed(){
  KP(mainWindow);
}
void keyReleased(){
  KR(mainWindow);
}
void checkKey(boolean setValue,PApplet x){
  if(x.key == CODED){
    for(int i = 0; i < _codedKeys.length;i++){
      if(x.keyCode == _codedKeys[i]){
        codedKeys[i] = setValue;
        return;
      }
    }
  }
  else{
    for(int i = 0; i < keys.length;i++){
      if(java.lang.Character.toLowerCase(x.key) == _keys[i]){
        keys[i] = setValue;
        return;
      }
    }
  }
}