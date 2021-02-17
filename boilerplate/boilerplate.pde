Score s;
Clef c;
Rest r;
Note n;

void setup() {
  s = new Score();
  c = new Clef(s);
  r = new Rest(s);
  n = new Note(s);
  println(s.elements.size());
}
