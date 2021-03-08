import processing.sound.*;
PApplet p = this;

class Note extends DurationElement implements Tangible, Runnable{
  int location;  // number of lines and spacing where space below the first line is 0
  //SinOsc sine;  each note has its own sine wave
  /** Get the previous clef: this.getPrevious(Clef.class);
    * Get the previous time signature: this.getPrevious(TimeSignature.class);
    */
  
  NoteState state;
  SinOsc sine;
  
  public Note (Score s, BaseDuration dur, boolean dotted, int location) {
    super(s);
    this.duration = dur;
    this.dotted = dotted;
    this.location = location;
    this.state = NoteState.NOT_PLAYING;
    this.sine = new SinOsc(p);
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

    switch (this.state) {
      case NOT_PLAYING:
      if (pos.sub(new PVector(mouseX, mouseY)).mag() < 10) {
        this.state = NoteState.START_PLAYING;
      }
      break;
      case START_PLAYING:
      Thread t = new Thread(this);
      this.state = NoteState.PLAYING;
      t.run();
      case PLAYING:
      default:
      break;
    }
  }
    
  
  // TODO Update Implementation
  PVector force(PVector posEE) {
    return new PVector(0, 0);
  }
  
  void getSine(){
    //the notes can be found by taking the starting note and doing the following calculation: Freq = note x 2^N/12
    //the clef will determine the starting note
    Clef c = (Clef) this.getPrevious(Clef.class);
    ClefShape sh = c.shape;
    if(sh== null){
      sh= ClefShape.G;
    }
    float refnote= 0.0;
    if (sh == ClefShape.G) {  //treble clef
      //the first note is the one on the first staff line- so for this clef it is E4
      refnote= 329.628;
    }
    else if (sh == ClefShape.C) { //baritone clef??
      //the reference note is F3
      refnote= 174.61;
    }
    else {      // ClefShape.F aka bass clef
      //the reference note is G2
      refnote= 98.00;
    }
    System.out.println(this.location);
    float loc= float(this.location);
    float frequency= refnote* (float) Math.pow(2, (loc/12.0));
    System.out.println(frequency);
    sine.freq(frequency);
    sine.amp(0.5);
    
  }

  void run(){
    getSine();
    //making sure that the thing plays for the appropriate amount of time
    double currentTime= millis();
    sine.play();
    double dur = this.durationMs();
    while((millis()-currentTime) < dur){
      delay(100);
    }
    sine.stop();
    this.state = NoteState.NOT_PLAYING;
  }
}

enum NoteState {
    NOT_PLAYING,
    START_PLAYING,
    PLAYING,
  };
