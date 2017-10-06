int scale = 20;
int fieldHeight;
int fieldWidth;
int frameSizeX;
int frameSizeY;
int centerX;
int centerY;
void settings(){
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
}