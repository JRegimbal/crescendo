class Note extends DurationElement implements Tangible {
  int location;  // number of lines and spacing where space below the first line is 0
  
  /** Get the previous clef: this.getPrevious(Clef.class);
    * Get the previous time signature: this.getPrevious(TimeSignature.class);
    */
  
  public Note (Score s, BaseDuration dur, boolean dotted, int location) {
    super(s);
    this.duration = dur;
    this.dotted = dotted;
    this.location = location;
  }
  public Note(Score s) {
    this(s, BaseDuration.QUARTER, false, 0);
  }
  
  public Note(Score s, int location) {
    this(s, BaseDuration.QUARTER, false, location);
  }
  
  public Note(Score s, BaseDuration dur, int location) {
    this(s, dur, false, location);
  }
  
  PVector getPosition() {
    PVector base = getBasePosition();
    base.y -= location * this.parent.lineSpacing / 2.0;
    return base;
  }
  
  String getText() {
    String text = "";
    switch (this.duration) {
      case WHOLE:
      text += "\ue1d2";
      break;
      case HALF:
      if (location < 5) {  // point for switching to up/down stem
        text += "\ue1d3";
      }
      else {
        text += "\ue1d4";
      }
      break;
      case QUARTER:
      if (location < 5) {
        text += "\ue1d5";
      }
      else {
        text += "\ue1d6";
      }
      break;
      case EIGHTH:
      if (location < 5) {
        text += "\ue1d7";
      }
      else {
        text += "\ue1d8";
      }
      break;
    }
    if (this.dotted) {
      text += "\ue1e7";
    }
    return text;
  }
  
  float getWidth() {
    return textWidth(getText());
  }
  
  void draw() {
    String text = getText();
    PVector pos = getPosition();
    text(text, pos.x, pos.y);
  }
    
  
  // TODO Update Implementation
  PVector force(PVector posEE) {
    return new PVector(0, 0);
  }
}
