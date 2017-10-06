class oneWayLinkedList<E>{
  class Lnode{
    E value;
    Lnode(E x){
      value = x;
    }
    Lnode(E x, Lnode a){
      value = x;
      after = a;
    }
    Lnode after = null;
  }
  
  int size = 0;
  Lnode end = new Lnode(null);
  Lnode start = new Lnode(null,end);
  Lnode current = start;
  Lnode back;
  oneWayLinkedList(){
  }
  void add(E x){
    start.after = new Lnode(x,start.after);
    size++;
  }
  boolean hasNext(){
    if(current.after == null || current.after.value == null){
      return false;
    }
    else{
      return true;
    }
  }
  E next(){
    back = current;
    return (current = current.after).value;
  }
  E getCurrent(){
    return current.value;
  }
  void rewind(){
    current = start;
  }
  void remove(){
    current.value = current.after.value;
    current.after = current.after.after;
    current = back;
    size--;
  }
}