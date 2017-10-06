class Structure {
  ArrayList<Goo> gooo;

  public Structure() {
    gooo = new ArrayList<Goo>();
  }

  public void add(Goo x) {
    gooo.add(x);
  }

  public Goo getTouching(FBody x) {
    Goo ans = null;
    boolean f = false;
    for (Goo y : gooo) {
      if (y.getShape().isTouchingBody(x)) {
        ans = y;
        x.setFill(20, 40, 20);
        f = true;
      }
    }
    if (!f) {
      x.setFill(1000, 1000, 1000);
    }
    return ans;
  }

  public boolean reachedGoal(FBox reached) {
    boolean ans = false;
    for (Goo g : gooo) {
      if (g.shape.isTouchingBody(reached)) {
        ans = true;
      }
    }
    return ans;
  }

  public int size() {
    return gooo.size();
  }

  public Goo get(int x) {
    return gooo.get(x);
  }

  public void checkForces() {
    for (Goo y : gooo) {
      if (y.shape.getVelocityY()>2000) {
        y.shape.setFill(400, 20, 20);
        for (FConstantVolumeJoint x : y.getJoints()) {
          x.removeFromWorld();
        }
      }
      if (y.shape.getY() > height-30) {
        y.shape.setVelocity(0, 0);
        if (!y.start)
        {
          y.connected = false;
        }
      }
    }
  }

  public void touch(FBox z) {
    for (Goo y : gooo) {
      if (y.shape.isTouchingBody(z)) {
        y.shape.setFill(400, 20, 20);
        y.connected = false;
        for (FConstantVolumeJoint x : y.getJoints()) {
          x.removeFromWorld();
        }
      }
      if (y.shape.getY() > height-30) {
        y.shape.setVelocity(0, 0);
      }
    }
  }
}