class entity{
  entity parent = null;
  boolean update(){
    //true if unit is to be removed
    return false;
  }
  boolean update(oneWayLinkedList<unit> x){//this is for interaction with other entitys
    //true if unit is to be removed
    return false;
  }
  void _draw(){
  }
}

class unit extends entity{
  battleMode field;
  int health;
  int points;
  float size;
  float xcor;
  float ycor;
  float radius;
  float displaySize;
  void death(){
  }
}