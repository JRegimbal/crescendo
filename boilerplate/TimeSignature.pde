class TimeSignature extends OrderedMusicElement {
  
  int num;
  int den;
  
  TimeSignature(Score s, int num, int den) {
    super(s);
    this.num = num;
    this.den = den;
  }
  
  float getWidth () {
    return max(textWidth(getTextN()), textWidth(getTextD()));
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
    PVector pos = getPosition();
    String tn = getTextN();
    text(tn, pos.x, pos.y);
    String td = getTextD();
    pos.y += 2 * this.parent.lineSpacing;
    text(td, pos.x, pos.y);
  }
}
