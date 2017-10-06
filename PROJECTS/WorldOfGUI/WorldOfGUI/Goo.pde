public class Goo extends FBody {
  FCircle shape;
  boolean connected;
  boolean start;
  ArrayList<FConstantVolumeJoint> joints;

  public Goo() {
    shape = new FCircle(40);
    shape.setDensity(200);
    connected = true;
    start = false;
    joints = new ArrayList<FConstantVolumeJoint>();
    PImage img;
    img = loadImage("goo.png");
    shape.attachImage(img);
  }

  public Goo(FCircle circle) {
    shape = circle;
    shape.setDensity(200);
    connected = false;
    start = false;
    joints = new ArrayList<FConstantVolumeJoint>();
    PImage img;
    img = loadImage("goo.png");
    shape.attachImage(img);
  }

  public Goo(boolean bool) {
    shape = new FCircle(40);
    shape.setDensity(200);
    connected = bool;
    start = bool;
    joints = new ArrayList<FConstantVolumeJoint>();
    PImage img;
    img = loadImage("goo.png");
    shape.attachImage(img);
  }

  void draw() {
  }

  /*
  boolean checkTouching(){
   ArrayList<FBody> x = shape.getTouching();
   boolean ans = false;
   FBody n = null;
   
   for(FCircle y:x){
   if(y.
   }
   }
   */

  public boolean getConn() {
    return this.connected;
  }

  public FCircle getShape() {
    return shape;
  }

  public void setPosition(float x, float y) {
    shape.setPosition(x, y);
  }

  public float getX() {
    return shape.getX();
  }

  public float getY() {
    return shape.getY();
  }

  public void setStatic(boolean bool) {
    shape.setStatic(bool);
  }

  public void setGrabbable(boolean bool) {
    shape.setGrabbable(bool);
  }

  public ArrayList<FConstantVolumeJoint> getJoints() {
    return joints;
  }
}