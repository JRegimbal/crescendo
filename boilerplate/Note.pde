/**
 * Implements note elements. Viewable, tangible, audible.
 */
class Note extends DurationElement implements Tangible, Audible {
  int location;  // number of lines and spacing where space below the first line is 0
  float textWidth;
  float startTime;
  boolean ready;

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
    ready = true;
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
    final float threshold = 0.005;
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
      if ((posEE.copy().sub(getPhysicsPosition())).mag() < threshold) {
        if (ready) {
          this.state = NoteState.START_PLAYING;
        }
      } else {
        ready = true;
      }
      break;
    case START_PLAYING:
      play();
      ready = false;
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
    PVector force = new PVector(0, 0);
    if (posDiff.mag() <= threshold) {
      if (NOTE_FORCE) {
        // Grab next note if it exists
        if (this.parent.elements.indexOf(this) < this.parent.elements.size() - 1) {
          PVector nextPos = this.parent.elements.get(this.parent.elements.indexOf(this) + 1).getPhysicsPosition();
          force.add(getPhysicsPosition().sub(nextPos).setMag(1.56));
        }
      }
      if (NOTE_TEXTURE) {
        float fx = 0, fy = 0;
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
        force.add(new PVector(fx, fy));
      }
    }
    return force;
  }

  int getFrequency() {
    //the notes can be found by taking the starting note and doing the following calculation: Freq = note x 2^N/12
    //the clef will determine the starting note
    Clef c = (Clef) this.getPrevious(Clef.class);
    ClefShape sh = c.shape;
    if (sh == null) {
      sh = ClefShape.G;
    }
    int pitchClass = 0; // 0 = C
    int octave = 0;
    if (sh == ClefShape.G) {
      pitchClass = 4;
      octave = 4;
    } else if (sh == ClefShape.C) {
      pitchClass = 0;
      octave = 4;
    } else {  // F clef
      pitchClass = 3;
      octave = 3;
    }
    // Change pitch class to one of note
    pitchClass -= ((c.line - 1) * 2 - this.location);
    while (pitchClass > 6) {
      octave++;
      pitchClass -= 7;
    }
    while (pitchClass < 0) {
      octave--;
      pitchClass += 7;
    }
    int midiNum = 12 * (octave + 1); // C for that octave with A440
    switch (pitchClass) {
      case 0: // c
      break;
      case 1: // d
      midiNum += 2;
      break;
      case 2: // e
      midiNum += 4;
      break;
      case 3: // f
      midiNum += 5;
      break;
      case 4: // g
      midiNum += 7;
      break;
      case 5: // a
      midiNum += 9;
      break;
      case 6: // b
      midiNum += 11;
      break;
      default:
      break;
    }
    // TODO take into account key sig
    return midiNum;
  }

  void play() {
    int frequency = getFrequency();
    double dur = this.durationMs();
    // Osc type message. Related to crescendo project and it plays a midi note.
    // Trying to follow good practices in case we expand
    OscMessage note = new OscMessage("/crescendo/midi");
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
