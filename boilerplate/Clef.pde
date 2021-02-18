class Clef extends OrderedMusicElement {
  ClefShape shape;
  KeySignature sig;
  int line;
  
  public Clef(Score s, ClefShape sh, int line) {
    super(s);
    shape = sh;
    this.line = line;
    this.sig = KeySignature.CsMaj;
  }
  
  public Clef(Score s) {
    this(s, ClefShape.G, 2);
  }
  
  public Clef(Score s, ClefShape sh) {
    this(s, sh, 0);
    if (sh == ClefShape.G) {
      line = 2;
    }
    else if (sh == ClefShape.C) {
      line = 3;
    }
    else {      // ClefShape.F
      line = 4;
    }
  }
  

  
  PVector getPosition() {
    PVector basePosition = getBasePosition();
    basePosition.y -= (line - 1) * this.parent.lineSpacing;
    return basePosition;
  }
  
  float getWidth() {
    float w = textWidth(this.shape.getGlyph());
    float w2 = textWidth(this.sig.getGlyph());
    switch (this.sig) {
      case CMaj:
      break;
      case GMaj:
      case FMaj:
      w += w2;
      break;
      case DMaj:
      case BfMaj:
      w += w2 * 2;
      break;
      case AMaj:
      case EfMaj:
      w += w2 * 3;
      break;
      case EMaj:
      case AfMaj:
      w += w2 * 4;
      break;
      case BMaj:
      case DfMaj:
      w += w2 * 5;
      break;
      case FsMaj:
      case GfMaj:
      w += w2 * 6;
      break;
      case CfMaj:
      case CsMaj:
      w += w2 * 7;
      break;
    }
    return w;
  }
  
  void draw() {
    String text = this.shape.getGlyph();
    PVector pos = getPosition();
    text(text, pos.x, pos.y);
    
    // Render key signature (if necessary)
    float textWidth = textWidth(text);
    PVector sigPos = getBasePosition();
    sigPos.x += textWidth;
    float sigWidth = textWidth(this.sig.getGlyph());
    String glyph = this.sig.getGlyph();
    if (this.sig.getGlyph() == "\ue262") {  // Sharps
      sigPos.y -= 4 * this.parent.lineSpacing;
      text(glyph, sigPos.x, sigPos.y);
      if (this.sig == KeySignature.GMaj) return;
      sigPos.x += sigWidth;
      sigPos.y += 3 * (this.parent.lineSpacing / 2);
      text(glyph, sigPos.x, sigPos.y);
      if (this.sig == KeySignature.DMaj) return;
      sigPos.x += sigWidth;
      sigPos.y -= 2 * this.parent.lineSpacing;
      text(glyph, sigPos.x, sigPos.y);
      if (this.sig == KeySignature.AMaj) return;
      sigPos.x += sigWidth;
      sigPos.y += 3 * (this.parent.lineSpacing / 2);
      text(glyph, sigPos.x, sigPos.y);
      if (this.sig == KeySignature.EMaj) return;
      sigPos.x += sigWidth;
      sigPos.y += 3 * (this.parent.lineSpacing / 2);
      text(glyph, sigPos.x, sigPos.y);
      if (this.sig == KeySignature.BMaj) return;
      sigPos.x += sigWidth;
      sigPos.y -= 2 * this.parent.lineSpacing;
      text(glyph, sigPos.x, sigPos.y);
      if (this.sig == KeySignature.FsMaj) return;
      sigPos.x += sigWidth;
      sigPos.y += 3 * (this.parent.lineSpacing / 2);
      text(glyph, sigPos.x, sigPos.y);
    }
  }
}
