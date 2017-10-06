boolean checkBounds(unit x,battleMode field){
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
}
boolean checkBoundsGhost(unit x,battleMode field){
  if(x.xcor > field._width - (x.size / 2)){
    return true;
  }
  else if(x.xcor < x.size / 2){
    return true;
  }
  if(x.ycor > field._height - (x.size / 2)){
    return true;
  }
  else if(x.ycor < x.size / 2){
    return true;
  }
  else{
    return false;
  }
}
boolean checkDisplayBounds(unit x){
  boolean r = false;
  if(x.xcor + centerX > displayWidth - (x.size / 2)){
    x.xcor = (displayWidth - (x.size / 2)) - centerX;
    r = true;
  }
  else if(x.xcor + centerX < x.size / 2){
    x.xcor = (x.size / 2) - centerX;
    r = true;
  }
  if(x.ycor + centerY > displayHeight - (x.size / 2)){
    x.ycor = (displayHeight - (x.size / 2)) - centerY;
    r = true;
  }
  else if(x.ycor + centerY < x.size / 2){
    x.ycor = (x.size / 2) - centerY;
    r = true;
  }
  return r;
}
boolean inBounds(unit x,battleMode field){
  if(x.xcor > field._width - (x.size / 2)){
    //x.xcor = field._width - (x.size / 2);
    return false;
  }
  else if(x.xcor < x.size / 2){
    //x.xcor = x.size / 2;
    return false;
  }
  if(x.ycor > field._height - (x.size / 2)){
    //x.ycor = field._height - (x.size / 2);
    return false;
  }
  else if(x.ycor < x.size / 2){
    //x.ycor = x.size / 2;
    return false;
  }
  return true;
}