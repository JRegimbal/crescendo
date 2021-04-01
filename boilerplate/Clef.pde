/**
 * Encodes clef, position, and key signature
 */
class Clef extends OrderedMusicElement {
  ClefShape shape;
  KeySignature sig;
  int line;
  String text;
  PVector pos;
  boolean initial;
  float clefWidth;
  float accidWidth;
  float textWidth;
  
  public Clef(Score s, ClefShape sh, KeySignature sig) {
    super(s);
    this.initial = true;
    shape = sh;
    this.sig = sig;
    if (sh == ClefShape.G) {  //treble clef
      line = 2;
    }
    else if (sh == ClefShape.C) { //baritone clef??
      line = 3;
    }
    else {      // ClefShape.F aka bass clef
      line = 4;
    }
    this.clefWidth = textWidth(this.shape.getGlyph());
    this.accidWidth = textWidth(this.sig.getGlyph());
    this.textWidth = this.getWidth();
  }

  public Clef(Score s) {
    this(s, ClefShape.G);
  }

  public Clef(Score s, ClefShape sh) {
    this(s, sh, KeySignature.CMaj);
  }
  
  PVector getPosition() {
    PVector basePosition = getBasePosition();
    basePosition.y -= (line - 1) * this.parent.lineSpacing;
    return basePosition;
  }
  
  float getWidth() {
    float w = this.clefWidth;
    float w2 = this.accidWidth;;
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
  
  float getPadding() { return this.parent.lineSpacing; }
  
  void draw() {
    String text = this.shape.getGlyph();
    PVector pos = getPosition();
    text(text, pos.x, pos.y);
    
    // Render key signature (if necessary)
    PVector sigPos = getBasePosition();
    // Offset since we expect to be in G by default
    if (this.shape == ClefShape.F) {
      sigPos.y += this.parent.lineSpacing;
    }
    else if (this.shape == ClefShape.C) {
      sigPos.y += this.parent.lineSpacing / 2;
    }
    sigPos.x += this.clefWidth;
    String glyph = this.sig.getGlyph();
    if (this.sig.getGlyph() == "\ue262") {  // Sharps
      sigPos.y -= 4 * this.parent.lineSpacing;
      text(glyph, sigPos.x, sigPos.y);
      if (this.sig == KeySignature.GMaj) return;
      sigPos.x += this.accidWidth;
      sigPos.y += 3 * (this.parent.lineSpacing / 2);
      text(glyph, sigPos.x, sigPos.y);
      if (this.sig == KeySignature.DMaj) return;
      sigPos.x += this.accidWidth;
      sigPos.y -= 2 * this.parent.lineSpacing;
      text(glyph, sigPos.x, sigPos.y);
      if (this.sig == KeySignature.AMaj) return;
      sigPos.x += this.accidWidth;
      sigPos.y += 3 * (this.parent.lineSpacing / 2);
      text(glyph, sigPos.x, sigPos.y);
      if (this.sig == KeySignature.EMaj) return;
      sigPos.x += this.accidWidth;
      sigPos.y += 3 * (this.parent.lineSpacing / 2);
      text(glyph, sigPos.x, sigPos.y);
      if (this.sig == KeySignature.BMaj) return;
      sigPos.x += this.accidWidth;
      sigPos.y -= 2 * this.parent.lineSpacing;
      text(glyph, sigPos.x, sigPos.y);
      if (this.sig == KeySignature.FsMaj) return;
      sigPos.x += this.accidWidth;
      sigPos.y += 3 * (this.parent.lineSpacing / 2);
      text(glyph, sigPos.x, sigPos.y);
    }
    else if (this.sig.getGlyph() == "\ue260") { // Flats
      sigPos.y -= 2 * this.parent.lineSpacing;
      text(glyph, sigPos.x, sigPos.y);
      if (this.sig == KeySignature.FMaj) return;
      sigPos.x += this.accidWidth;
      sigPos.y -= 3 * (this.parent.lineSpacing / 2);
      text(glyph, sigPos.x, sigPos.y);
      if (this.sig == KeySignature.BfMaj) return;
      sigPos.x += this.accidWidth;
      sigPos.y += 2 * this.parent.lineSpacing;
      text(glyph, sigPos.x, sigPos.y);
      if (this.sig == KeySignature.EfMaj) return;
      sigPos.x += this.accidWidth;
      sigPos.y -= 3 * (this.parent.lineSpacing / 2);
      text(glyph, sigPos.x, sigPos.y);
      if (this.sig == KeySignature.AfMaj) return;
      sigPos.x += this.accidWidth;
      sigPos.y += 2 * this.parent.lineSpacing;
      text(glyph, sigPos.x, sigPos.y);
      if (this.sig == KeySignature.DfMaj) return;
      sigPos.x += this.accidWidth;
      sigPos.y -= 3 * (this.parent.lineSpacing / 2);
      text(glyph, sigPos.x, sigPos.y);
      if (this.sig == KeySignature.GfMaj) return;
      sigPos.x += this.accidWidth;
      sigPos.y += 2 * this.parent.lineSpacing;
      text(glyph, sigPos.x, sigPos.y);
    }
  }
}
