ArrayList<ArrayList<Float>> vals = new ArrayList<ArrayList<Float>>();
Float r = 2.8;


void gen10() {
  Float input = 0.5;
  Float output = 0.0;
  while (r < 4) {
    output = (r * input) * (1 - input);
    ArrayList<Float> yvalues = new ArrayList<Float>();
    yvalues.add(r);
    yvalues.add(output * 100);
    vals.add(yvalues);
    input = output;
    r += 0.001;
  }
}

void setup() {
  size(400, 400);
  background(255);
  gen10();
  pushMatrix();
  scale(2.0,-2.0);
  for (ArrayList<Float> d : vals) {
    ellipse(d.get(0)*100-250, d.get(1)-150, 1, 1);
  }
  popMatrix();
}