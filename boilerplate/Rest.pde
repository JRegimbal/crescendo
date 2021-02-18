class Rest extends DurationElement {
  Rest(Score s, BaseDuration dur, boolean dotted) {
    super(s);
    this.duration = dur;
    this.dotted = dotted;
  }
  
  Rest(Score s) {
    this(s, BaseDuration.QUARTER, false);
  }
  
  Rest(Score s, BaseDuration dur) {
    this(s, dur, false);
  }
  
  PVector getPosition() {
    PVector basePosition = getBasePosition();
    basePosition.y -= 2 * this.parent.lineSpacing;
    return basePosition;
  }
  
  void draw() {
    String text;
    switch (this.duration) {
      case WHOLE:
      text = "\ue4e3";
      break;
      case HALF:
      text = "\ue4e4";
      break;
      case QUARTER:
      text = "\ue4e5";
      break;
      case EIGHTH:
      text = "\ue4e6";
      break;
      default:
      text = "";
    }
    if (this.dotted) {
      text += "\ue1e7";
    }
    PVector pos = getPosition();
    text(text, pos.x, pos.y);
  }   
}
