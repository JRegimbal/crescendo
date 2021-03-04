interface Audible {
  void play();
}

interface Tangible {
  PVector force(PVector posEE, PVector velEE);
}

interface Viewable {
  void draw();
  void update();
}
