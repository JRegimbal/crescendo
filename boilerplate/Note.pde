/**
 * Implements note elements. Viewable, tangible, audible.
 */
class Note extends DurationElement implements Tangible, Audible {
  int location;  // number of lines and spacing where space below the first line is 0
  float textWidth;
  float startTime;

  /** Get the previous clef: this.getPrevious(Clef.class);
   * Get the previous time signature: this.getPrevious(TimeSignature.class);
   */

  NoteState state;

  public Note (Score s, BaseDuration dur, boolean dotted, int location) {
    super(s);
    this.duration = dur;
    this.dotted = dotted;
    this.location = location;
    this.textWidth = textWidth(getText());
    this.state = NoteState.NOT_PLAYING;
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
      } else {
        text += "\ue1d4";
      }
      break;
    case QUARTER:
      if (location < 5) {
        text += "\ue1d5";
      } else {
        text += "\ue1d6";
      }
      break;
    case EIGHTH:
      if (location < 5) {
        text += "\ue1d7";
      } else {
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
    return this.textWidth;
  }

  void draw() {
    String text = getText();
    PVector pos = getPosition();
    text(text, pos.x, pos.y);

    // Draw ledger lines when applicable
    if (location < -1) {
      // At least one line below bottom
      int temp = location;
      final int extra = this.parent.lineSpacing / 3;
      while (temp < -1) {
        strokeWeight(this.parent.strokeWidth);
        PShape l = createShape(LINE, pos.x - getWidth() / 2 - extra, pos.y, pos.x + getWidth() / 2 + extra, pos.y);
        shape(l);
        pos.y -= this.parent.lineSpacing;
        temp += 2;
      }
    }
    if (location > 9) {
      int temp = location;
      final int extra = this.parent.lineSpacing / 3;
      while (temp > 9) {
        strokeWeight(this.parent.strokeWidth);
        PShape l = createShape(LINE, pos.x - getWidth() / 2 - extra, pos.y, pos.x + getWidth() / 2 + extra, pos.y);
        shape(l);
        pos.y += this.parent.lineSpacing;
        temp -= 2;
      }
    }

    switch (this.state) {
    case NOT_PLAYING:
      break;
    case START_PLAYING:
      play();
      break;
    case PLAYING:
      if (millis() - startTime > durationMs()) {
        this.state = NoteState.NOT_PLAYING;
      }
      break;
    default:
      break;
    }
  }


  PVector force(PVector posEE, PVector velEE) {   
    PVector posDiff = (posEE.copy().sub(getPhysicsPosition()));
    final float threshold = 0.005;
    float fx = 0;
    float fy = 0;
    
    if (posDiff.mag() > threshold) {
      return new PVector(0, 0);
    } else if (this.state == NoteState.NOT_PLAYING) {
      this.state = NoteState.START_PLAYING;
    }
      
    if (velEE.mag() > 0.00) {
      switch (getText()) {
      case "\ue1d2":
        if (posDiff.mag() > 0.0025) {
          fx = -velEE.x/abs(velEE.x + 0.001) * 2 * abs(randomGaussian());
          fy = -velEE.y/abs(velEE.y + 0.001) * 2 * abs(randomGaussian());
        }
        break;
      case "\ue1d3":
        if (posDiff.mag() > 0.0015) {
          fx = -velEE.x/abs(velEE.x + 0.001) * 1.5 * abs(randomGaussian());
          fy = -velEE.y/abs(velEE.y + 0.001) * 1.5 * abs(randomGaussian());
        }
        break;
      case "\ue1d4":
        if (posDiff.mag() > 0.0015) {
          fx = -velEE.x/abs(velEE.x + 0.001) * 1.5 * abs(randomGaussian());
          fy = -velEE.y/abs(velEE.y + 0.001) * 1.5 * abs(randomGaussian());
        }
        break;
      case "\ue1d5":
        fx = -velEE.x/abs(velEE.x + 0.001) * abs(randomGaussian());
        fy = -velEE.y/abs(velEE.y + 0.001) * abs(randomGaussian());
        break;
      case "\ue1d6":
        fx = -velEE.x/abs(velEE.x + 0.001) * abs(randomGaussian());
        fy = -velEE.y/abs(velEE.y + 0.001) * abs(randomGaussian());
        break;
      case "\ue1d7":
        fx = 0.75 * randomGaussian();
        fy = 0.75 * randomGaussian();
        break; 
      case "\ue1d8":
        fx = 0.75 * randomGaussian();
        fy = 0.75 * randomGaussian();
        break;
      }
    }

    fx = constrain(fx, -1.25, 1.25);
    fy = constrain(fy, -1.25, 1.25);

    return new PVector(fx, fy);
  }

  float getFrequency() {
    //the notes can be found by taking the starting note and doing the following calculation: Freq = note x 2^N/12
    //the clef will determine the starting note
    Clef c = (Clef) this.getPrevious(Clef.class);
    ClefShape sh = c.shape;
    if (sh== null) {
      sh = ClefShape.G;
    }
    float refnote = 0.0;
    if (sh == ClefShape.G) {  //treble clef
      //the first note is the one on the first staff line- so for this clef it is E4
      refnote = 329.628;
    } else if (sh == ClefShape.C) { //baritone clef??
      //the reference note is F3
      refnote = 174.61;
    } else {      // ClefShape.F aka bass clef
      //the reference note is G2
      refnote = 98.00;
    }
    float loc = float(this.location);
    return refnote * (float) Math.pow(2, (loc/12.0));
  }

  void play() {
    float frequency = getFrequency();
    double dur = this.durationMs();
    // Osc type message. Related to crescendo project and it plays a note.
    // Trying to follow good practices in case we expand
    OscMessage note = new OscMessage("/crescendo/play");
    note.add(frequency);
    note.add((float)dur);  // Must cast to float as Pd does not support double precision
    oscP5.send(note, oscDestination);
    this.state = NoteState.PLAYING;
    startTime = millis();
  }
}

enum NoteState {
  NOT_PLAYING, 
    START_PLAYING, 
    PLAYING,
};
