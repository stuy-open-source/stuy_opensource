import fisica.*;  //<>//
import javax.swing.*;

FWorld world;
FBox goal;
FCircle mouse;
Structure start;
Structure_Joints start_Joints;
Goo a, b, c;
int level = 1;
ArrayList<FConstantVolumeJoint> cvj;
int gooLevel;
int score = 0;
FBox plat, plat2;

public void setLevel() {
  level++;
}

void setup() {
  cvj = new ArrayList<FConstantVolumeJoint>();
  size(1000, 600);
  smooth();
  Fisica.init(this);
  world = new FWorld();
  world.setGravity(0, 800);
  world.setEdges();
  world.remove(world.top);
  world.remove(world.left);
  world.remove(world.right);
  //
  goal = new FBox(100, 70);
  goal.setPosition(300, height-550);
  goal.setStatic(true);
  goal.setFill(10, 150, 10);
  goal.setGrabbable(false);
  PImage img;
  img = loadImage("pipe.PNG");
  goal.attachImage(img);
  world.add(goal);
  if (level == 3) {
    goal.setPosition(775, height-550);
  }
  //
  mouse = new FCircle(20);
  world.add(mouse);
  //
  start = new Structure();
  start_Joints = new Structure_Joints();
  //
  a = new Goo(true);
  b = new Goo(true);//
  c = new Goo(true);
  a.setPosition(400, height-20); 
  b.setPosition(200, height-20);
  c.setPosition(300, height-200);
  //
  world.add(a.getShape());
  world.add(b.getShape());
  world.add(c.getShape());
  c.setStatic(true);
  a.setStatic(true);
  b.setStatic(true);
  a.setGrabbable(false);
  b.setGrabbable(false);
  c.setGrabbable(false);
  start.add(a);
  start.add(b);
  start.add(c);
  //
  FDistanceJoint1 aB = new FDistanceJoint1(a.getShape(), b.getShape());
  aB.setLength(60);
  aB.setStroke(0);
  aB.setFill(#F5B502);
  aB.setStrokeColor(#000000);
  aB.setDrawable(true);
  aB.setFrequency(0.001);
  world.add(aB.x);
  //  
  FDistanceJoint1 bC = new FDistanceJoint1(c.getShape(), b.getShape());
  bC.setLength(60);
  bC.setStroke(0);
  bC.setFill(#F5B502);
  bC.setStrokeColor(#000000);
  bC.setDrawable(true);
  bC.setFrequency(0.001);
  world.add(bC.x);
  //
  FDistanceJoint1 aC = new FDistanceJoint1(a.getShape(), c.getShape());
  aC.setLength(60);
  aC.setStroke(0);
  aC.setFill(#F5B502);
  aC.setStrokeColor(#000000);
  aC.setDrawable(true);
  aC.setFrequency(0.001);
  world.add(aC.x);
  //
  gooLevel = (3 + (level * 2));
  if (level == 3) {
    gooLevel += 6;
  }
  //
  if (level==2) {
    plat = new FBox(730, 150);
    plat.setPosition(0, 270);
    plat.setStatic(true);
    plat.setGrabbable(false);
    plat.setNoFill();
    plat.setStrokeWeight(0);
    world.add(plat);
  }
  if (level==3) {
    plat = new FBox(750, 150);
    plat.setPosition(0, 270);
    plat.setStatic(true);
    plat.setGrabbable(false);
    plat.setNoFill();
    plat.setStrokeWeight(0);
    world.add(plat);

    plat2 = new FBox(400, 150);
    plat2.setPosition(830, 270);
    plat2.setStatic(true);
    plat2.setGrabbable(false);
    plat2.setNoFill();
    plat2.setStrokeWeight(0);
    world.add(plat2);
  }
}




void draw() {
  background(255);
  if (level == 1) {
    PImage img;
    img = loadImage("bg1.png");
    background(img);
  }
  if (level == 2) {
    PImage img2;
    img2 = loadImage("bg3.png");
    background(img2);
  } 
  if (level == 3) {
    PImage img3;
    img3 = loadImage("bg2.PNG");
    background(img3);
  }
  world.step();
  world.draw();
  mouse.setPosition(mouseX, mouseY);
  //
  FDistanceJoint1 aC;
  if (start.getTouching(mouse) != null && start.getTouching(mouse).connected && start_Joints.js.size() < 2) {
    aC = new FDistanceJoint1(mouse, start.getTouching(mouse).getShape());

    if (start_Joints.doesNotHave(aC)) {
      aC.setLength(60);
      aC.setStroke(0);
      aC.setFill(#F5B502);
      aC.setStrokeColor(#000000);
      aC.setDrawable(true);
      aC.setFrequency(0.00000001);
      start_Joints.add(aC);
      world.add(aC.x);
      //println(aC.getBody1());
    }
  }
  start_Joints.checkJoints();

  if (level > 1) {
    textSize(32);
    text("Level " + (level-1) + " Completed! :)", 10, 30);
  }


  textSize(32);
  text("Total score: " + score, 10, 90); 

  textSize(32);
  text("Goos left: " + gooLevel, 10, 120); 


  if (start.reachedGoal(goal)) {
    if (level<3) {
      setScore();
      setLevel();
      setup();
    } else {
      javax.swing.JOptionPane.showMessageDialog(null, "GAME WON, please restart to play again" + '\n' + "Score: " + score);
      noLoop();
    }
  }

  a.setPosition(400, height-20); 
  b.setPosition(200, height-20);
  c.setPosition(300, height-200);

  start.checkForces();

  textSize(32);
  text("Current level: " + level, 10, 60);

  if (gooLevel==0) {
    javax.swing.JOptionPane.showMessageDialog(null, "GAME LOST, please restart to play again");
    noLoop();
  }

  if (level == 2) {
    start.touch(plat);
  }

  if (level == 3) {
    start.touch(plat);
    start.touch(plat2);
  }

  if (level == 2) {
    a.setPosition(500, height-20); 
    b.setPosition(300, height-20);
    c.setPosition(400, height-190);
  }
  if (level == 3) {
    a.setPosition(500, height-20); 
    b.setPosition(300, height-20);
    c.setPosition(400, height-190);
  }
}

void setScore() {
  score += gooLevel*10;
}

public Goo addGoo(float x, float y) {
  Goo g = new Goo(false);
  g.setPosition(x, y);
  world.add(g.getShape());
  g.setGrabbable(false);
  start.add(g);
  return g;
}

void keyReleased() {
  if (key == 'G' || key == 'g') {
    // try{
    Goo x = addGoo(mouseX, mouseY);
    /*
    FDistanceJoint1 aC = new FDistanceJoint1(x.getShape(), start.getTouching(mouse).getShape());
     aC.setLength(60);
     aC.setStroke(0);
     aC.setFill(#F5B502);
     aC.setStrokeColor(#F5B502);
     aC.setDrawable(true);
     aC.setFrequency(1);
     start_Joints.add(aC);
     world.add(aC);
     }
     catch(NullPointerException e){}*/
    try {
      FConstantVolumeJoint aC = new FConstantVolumeJoint();
      aC.setStrokeColor(#000000);
      aC.addBody(x.getShape());
      aC.addBody(start_Joints.js.get(0).getBody2());
      aC.addBody(start_Joints.js.get(1).getBody2());  
      x.joints.add(aC);
      aC.setNoFill();
      if (level<3) {
        aC.setFrequency(10000);
      } else {
        aC.setFrequency(10000);
      }
      //catch the index out of bounds 
      //exception. happens when you try to add a goo,
      //but you are not connected to two goos. Only one
      /////////////////CHANGE THIS!!!!!!!!!!!!!!!!!!!!!!!!
      world.add(aC);
      cvj.add(aC);
      x.connected = true;
      gooLevel -= 1;
    }
    catch(IndexOutOfBoundsException e) {
      world.remove(x.getShape());
    }
  }
}