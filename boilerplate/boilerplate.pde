Score s;
Clef c;
Rest r, r2;
Note n, n1;

void setup() {
  size(640, 320);
  s = new Score();
  c = new Clef(s, ClefShape.G, KeySignature.CMaj);
  r = new Rest(s, BaseDuration.HALF);
  // Make a new quarter note that is dotted and one space up from the first staff line
  n = new Note(s, BaseDuration.QUARTER, true, 1);
  // Make a new eighth note on the first staff line
  n1 = new Note(s, BaseDuration.EIGHTH, 0);
  r2 = new Rest(s, BaseDuration.QUARTER);
  println(s.elements.size());
}

void draw() {
  background(255);
  s.draw();
}
