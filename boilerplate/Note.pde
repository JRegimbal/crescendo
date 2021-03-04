import processing.sound.*;
Sound sound;
SinOsc sine = new SinOsc(this);

class Note extends DurationElement implements Tangible, Runnable{
  int location;  // number of lines and spacing where space below the first line is 0
  //SinOsc sine;  each note has its own sine wave
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
    getSine();
    if(mouseX-pos.x <10 && mouseY-pos.y<10){
      Thread thread= new Thread(this);
      thread.run();
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
    double refnote= 0.0;
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
    float frequency= (float) (refnote* Math.pow(2, (this.location-1)/12));
    System.out.println(frequency);
    sine.freq(frequency);
    sine.amp(0.5);
    
  }

  void run(){
    //making sure that the thing plays for the appropriate amount of time
    double currentTime= millis();
    while((millis()-currentTime) < this.durationMs()){
      sine.play();
      System.out.println("hit");
    }
    sine.stop();
  }
}
