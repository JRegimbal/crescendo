Score s;
Clef c;
Rest r, r2, r3;
Note n;

void setup() {
  size(640, 320);
  s = new Score();
  c = new Clef(s, ClefShape.G);
  r = new Rest(s, BaseDuration.HALF);
  n = new Note(s, BaseDuration.QUARTER, true, 1);
  r2 = new Rest(s, BaseDuration.EIGHTH);
  r3 = new Rest(s, BaseDuration.QUARTER);
  println(s.elements.size());
}

void draw() {
  background(255);
  s.draw();
}
