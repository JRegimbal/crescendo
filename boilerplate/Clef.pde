class Clef extends OrderedMusicElement {
  ClefShape shape;
  int line;
  
  public Clef(Score s) {
    super(s);
    shape = ClefShape.G;
    line = 2;
  }
  
  public Clef(Score s, ClefShape sh) {
    super(s);
    shape = sh;
    if (shape == ClefShape.G) {
      line = 2;
    }
    else if (shape == ClefShape.C) {
      line = 3;
    }
    else {      // ClefShape.F
      line = 4;
    }
  }
  
  public Clef(Score s, ClefShape sh, int line) {
    super(s);
    shape = sh;
    this.line = line;
  }
  
  PVector getPosition() {
    int index = getIndex();
    PVector basePosition = getBasePosition();
    basePosition.y -= (line - 1) * this.parent.lineSpacing;
    return basePosition;
  }
  
  void draw() {
    String text;
    switch (this.shape) {
      case G:
      text = "\ue050";
      break;
      case F:
      text = "\ue062";
      break;
      case C:
      text = "\ue05c";
      break;
      default:
      text = "";
    }
    PVector pos = getPosition();
    text(text, pos.x, pos.y);
  }
    
}
