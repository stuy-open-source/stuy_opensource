class Structure_Joints {
  ArrayList<FDistanceJoint1> js;

  public Structure_Joints() {
    js = new ArrayList<FDistanceJoint1>();
  }

  public void add(FDistanceJoint1 x) {
    js.add(x);
    //println(x.getBody1() + " " + x.getBody2());
  }

  public void checkJoints() {
    ArrayList<FDistanceJoint1> rem = new ArrayList<FDistanceJoint1>();
    for (FDistanceJoint1 y : js) {
      if (dist(y.getAnchor1X(), y.getAnchor1Y(), y.getAnchor2X(), y.getAnchor2Y()) > 300) {
        rem.add(y);
        y.removeFromWorld();
      }
    }
    if (rem.size() != 0) {
      for (FDistanceJoint1 y : rem) {
        js.remove(y);
        js.trimToSize();
      }
    }
  }

  public boolean doesNotHave(FDistanceJoint1 x) {
    boolean ans = true;
    for (FDistanceJoint1 y : js) {
      if ((y.getBody1() == x.getBody1() || y.getBody1() == x.getBody2()) &&
        (y.getBody2() == x.getBody1() || y.getBody2() == x.getBody2())) {
        ans = false;
      }
    }
    return ans;
  }
}