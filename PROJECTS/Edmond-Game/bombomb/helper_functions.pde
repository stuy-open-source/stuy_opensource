class Timer{
  public Timer(){
    }
    private long time;
    public void start(){
  time = System.currentTimeMillis();
    }
    public long stop(){
  return (System.currentTimeMillis() - time) / 1000;
    }
}


void centerWindow(){
  if(surface != null){
    surface.setLocation(centerX,centerY);
  }
}
void centerWindow(PApplet x){
  if(x.getSurface() != null){
    x.getSurface().setLocation(x.displayWidth/2-x.width/2,x.displayHeight/2-x.height/2);
  }
}
String randomSelect(String[]x){
  return x[int(random(x.length))];
}
boolean released(char targetKey){//for regular keys
  if(releasedTick != tick){
    return false;
  }
  else{
    if(!codedAndPushed){
      return keyPushed == targetKey;
    }
    else{
      return false;
    }
  }
}
boolean released(int targetKey){//for codedKeys
  if(releasedTick != tick){
    return false;
  }
  else{
    if(codedAndPushed){
      return keyPushed == targetKey;
    }
    else{
      return false;
    }
  }
}
int arrayIndex(String[]ary,String target){
  for(int i = 0; i < ary.length; i++){
    if(ary[i].equals(target)){
      return i;
    }
  }
  return -1;
}
int arrayIndex(char[]ary,char target){
  for(int i = 0; i < ary.length; i++){
    if(ary[i] == target){
      return i;
    }
  }
  return -1;
}
int positiveOrNegative(){
  if(random(100) > 50){
    return 1;
  }
  else{
    return -1;
  }
}


class delay{
  int wait;
  int counter = 0;
  void setWait(float wait){
    this.wait = int(wait * expectedFrameRate);
  }
  delay(float wait){
    this.wait = int(wait * expectedFrameRate);
  }
  boolean every(){
    if(counter++ % wait == 0){
      return true;
    }
    else{
      return false;
    }
  }
}


class charge{
  int wait;
  int counter = 0;
  charge(float wait){
    this.wait = int(wait * expectedFrameRate);
  }
  void setWait(float wait){
    this.wait = int(wait * expectedFrameRate);
  }
  boolean cooldown(){
    if(counter++ < wait){
      return false;
    }
    else{
      return true;
    }
  }
  void resetCooldown(){
    counter = 0;
  }
  boolean cooldown(boolean activation){
    if(cooldown() && activation){
      resetCooldown();
      return true;
    }
    else{
      return false;
    }
  }
}