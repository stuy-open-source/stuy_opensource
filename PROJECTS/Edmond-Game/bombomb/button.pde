class button{
  //constructor + variables
  int sizeX,sizeY,x,y,x1,y1;
  //include pic, hover animation, and pressed pic
  button(float x,float y,float sizeX,float sizeY){
    this.x = int(x * scale);
    this.y = int(y * scale);
    this.sizeX = int(sizeX * scale);
    this.sizeY = int(sizeY * scale);
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
    fill(#08a84d);
    rect(x,y,sizeX,sizeY);
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