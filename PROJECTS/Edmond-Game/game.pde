import java.util.ArrayList;
import java.awt.Robot;
import processing.sound.*;
import java.lang.Math;
import javax.sound.sampled.*;
import java.awt.event.KeyEvent;
import java.awt.MouseInfo;
import java.awt.Point;
import java.io.*;


int levelnumber = 3; //maunually increase?
boolean[] levels = new boolean[levelnumber];


boolean muted = true;
final int LOW_QUALITY = 0;
final int DEFAULT_QUALITY = 1;
final int HIGH_QUALITY = 2;
int graphicQuality = DEFAULT_QUALITY;
//settings + variables
int scale = 20;
int fieldHeight;
int fieldWidth;
int frameSizeX;
int frameSizeY;
int centerX;
int centerY;
boolean debug = true; //set this to false during release
void settings(){
  //screen resolution ratio is 16:9
  //to do: store settings in file
  int x = displayWidth / 16;
  int y = displayHeight / 9;
  if(x > y){
    scale = y;
  }
  else{
    scale = x;
  }
  scale = (scale * 3) / 4;
  frameSizeX = 16 * scale;
  frameSizeY = 9 * scale;
  size(frameSizeX,frameSizeY);
  centerX = displayWidth/2-width/2;
  centerY = displayHeight/2-height/2;
  
  /*SAVE SYSTEM TEST
  SaveSystem a = new SaveSystem("savefile.txt");
  levels = a.load(levels);
  a.save();*/
}

//setup + variables
Robot robot;
PApplet mainWindow;
mode Mode;
int expectedFrameRate;
void setup(){
  frameRate(60);
  mainWindow = this;
  expectedFrameRate = 60;
  setupGravity();
  surface.setResizable(true);
  centerWindow();
  //frame.setSize(1000,1000);
  //frame.setLocation(100,100);
  Mode = new mainMenu();
  //Mode = new manyWindowsTestEnvironment();
  //Mode = new experimentTestEnironment();
  //Mode = new gameOver();
  //Mode = new tempTestEnvironment();
  //Mode = new robotTestEnvironment();
  //Mode = new pushedTestEnvironment();
  //Mode = new soundTestEnvironment();
  //Mode = new sizeTestEnvironment();
  //Mode = new delayAndCooldownTestEnvironment();
  //Mode = new scrapTestEnvironment();
  //Mode = new OneWayLinkedListTestEnvironment();
  //Mode = new newWindowTestEnvironment();
  //Mode = new giantWormBossTestEnvironment();
  //Mode = new oneWayLinkedListTestEnvironment(); 
  //Mode = new giantWormBossLevel();
  //Mode = new Metropolis();
  //Mode = new attractorTestEnvironment();
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
  //try{
    Mode.tick();
    pmousePressed = mousePressed;
    tick++;
  //}
  //catch(Throwable e){
    //e.printStackTrace();
    //noLoop();
  //}
}

//keyboard + variables
char[]_keys = {'z','x','c','w','a','s','d','v','b','n','m','l','k','j','h'};
int keyZ = 0;int keyX = 1;int keyC = 2;int keyW = 3;int keyA = 4;int keyS = 5;int keyD = 6;int keyV = 7;int keyB = 8;int keyN = 9;int keyM = 10;int keyL = 11;int keyK = 12;int keyJ = 13;int keyH = 14;
boolean[]keys = new boolean[_keys.length];
int[] _codedKeys = {UP,DOWN,LEFT,RIGHT,SHIFT,CONTROL,ALT};
int cKeyUP = 0;int cKeyDOWN = 1;int cKeyLEFT = 2;int cKeyRIGHT = 3;int cKeySHIFT = 4;int cKeyCONTROL = 5;
int cKeyALT = 6;
boolean[]codedKeys = new boolean[_codedKeys.length];
int keyPushed;/*Most recent key that was pushed. A push is the process of pressing AND releasing a key.
Only needs to be checked in keyReleased() because a key must be already pressed to be released.*/
boolean codedAndPushed = false;/*True if the last key pushed was coded or not. 
False if there is a key pushed right now. Set to false at draw*/
//^^^ the function these are used for are located at the tab helper

int releasedTick;
void KP(PApplet x){
  checkKey(true,x);
}
void KR(PApplet x){
  releasedTick = tick;
  if(x.key == CODED){
    //System.out.println(keyCode + " Coded");
    keyPushed = x.keyCode;
    codedAndPushed = true;
  }
  else{
    //System.out.println(key + " normal");
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
    if(debug){System.out.println(keyCode);}
  }
  else{
    for(int i = 0; i < keys.length;i++){
      if(java.lang.Character.toLowerCase(x.key) == _keys[i]){
        keys[i] = setValue;
        return;
      }
    }
    if(debug){System.out.println(key);}
  }
}