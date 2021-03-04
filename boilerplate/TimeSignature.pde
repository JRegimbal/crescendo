class TimeSignature extends OrderedMusicElement {
  
  int num;
  int den;
  String tn, td;
  PVector pn, pd;
  boolean initial;
  float textWidthN, textWidthD, textWidth;
  
  
  TimeSignature(Score s, int num, int den) {
    super(s);
    this.num = num;
    this.den = den;
    this.initial = true;
    this.textWidthN = textWidth(getTextN());
    this.textWidthD = textWidth(getTextD());
    this.textWidth = max(textWidthN, textWidthD);
  }
  
  float getWidth () {
    return this.textWidth;
  }
  
  String getText(int i) {
    String text = "";
    switch (i) {
      case 0:
      text += "\ue080";
      break;
      case 1:
      text += "\ue081";
      break;
      case 2:
      text += "\ue082";
      break;
      case 3:
      text += "\ue083";
      break;
      case 4:
      text += "\ue084";
      break;
      case 5:
      text += "\ue085";
      break;
      case 6:
      text += "\ue086";
      break;
      case 7:
      text += "\ue087";
      break;
      case 8:
      text += "\ue088";
      break;
      case 9:
      text += "\ue089";
    }
    return text;
  }
  
  PVector getPosition() {
    PVector pos = getBasePosition();
    pos.y -= 3 * this.parent.lineSpacing;
    return pos;
  }
  
  String getTextN() {
    return getText(this.num);
  }
  
  String getTextD() {
    return getText(this.den);
  }
  
  void draw() {
    if (initial) {
      pn = getPosition();
      tn = getTextN();
      td = getTextD();
      pd = pn.copy();
      pd.y += 2 * this.parent.lineSpacing;
      initial = false;
    }
    text(tn, pn.x, pn.y);
    text(td, pd.x, pd.y);
  }
}
