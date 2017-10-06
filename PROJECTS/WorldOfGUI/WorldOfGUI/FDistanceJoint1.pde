class FDistanceJoint1 extends FBody {
  FDistanceJoint x;
  FBody Body1, Body2;

  public FDistanceJoint1(FBody j, FBody k) {
    x = new FDistanceJoint(j, k);
    Body1 = j;
    Body2 = k;
  }

  public FBody getBody1() {
    return Body1;
  }

  public FBody getBody2() {
    return Body2;
  }

  public float getAnchor1X() {
    return Body1.getX();
  }

  public float getAnchor2X() {
    return Body2.getX();
  }

  public float getAnchor1Y() {
    return Body1.getY();
  }

  public float getAnchor2Y() {
    return Body2.getY();
  }

  public void setLength(int n) {
    x.setLength(n);
  }

  public void setStroke(int n) {
    x.setStroke(n);
  }

  public void setStrokeColor(int n) {
    x.setStrokeColor(n);
  }

  public void setFill(int n) {
    x.setFill(n);
  }

  public void setDrawable(boolean n) {
    x.setDrawable(n);
  }

  public void setFrequency(float n) {
    x.setFrequency(n);
  }
  
  public void removeFromWorld(){
    x.removeFromWorld();
  }
}