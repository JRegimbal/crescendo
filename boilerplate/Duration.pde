import org.apache.commons.numbers.fraction.*;

interface Duration {
  BaseDuration getBaseDuration();
  boolean isDotted();
  Fraction getDuration();
  double durationMs();
}

abstract class DurationElement extends OrderedMusicElement implements Duration {
  BaseDuration duration;
  boolean dotted;
  
  public DurationElement(Score s) {
    super(s);
  }
  
  BaseDuration getBaseDuration() { return this.duration; }
  
  boolean isDotted() { return dotted; }
  
  Fraction getDuration() {
    Fraction dur = getBaseDuration().getValue(); //wait we are using fraction here which I am not familiar with
    if (this.isDotted()) {
      Fraction nextSmallest= Fraction.of(1, dur.getDenominator()*2);
      dur= dur.add(nextSmallest);
    }
    return dur;
  }
  
  double durationMs() {
    Fraction shape= this.getDuration();
    //the calls for time signature and tempo are probably wrong
    OrderedMusicElement e = (OrderedMusicElement) this;
    double tempo = e.parent.tempo;
    // System.out.println("Tempo: "+tempo);
    OrderedMusicElement tsObj = e.getPrevious(TimeSignature.class);
    Fraction tsFrac;
    if (tsObj != null) {
      TimeSignature ts = (TimeSignature) e.getPrevious(TimeSignature.class);
      // println("Time sig:", ts.num, ts.den);
      tsFrac = Fraction.of(1, ts.den);
    }
    else {
      tsFrac = Fraction.of(1, 4);
    }
    double durationMs = 60/tempo;
    Fraction shape2timeFrac= (shape.divide(tsFrac));
    // System.out.println("shape2time: "+shape2timeFrac);
    double shape2time= ((double) shape2timeFrac.getNumerator())/((double) shape2timeFrac.getDenominator());
    durationMs= durationMs*shape2time*1000;
    // System.out.println("duration: "+durationMs);
    return durationMs;
  }
  
  float getPadding() {
    float base = 2 * this.parent.lineSpacing;
    return base + this.parent.lineSpacing * max(4 - getDuration().getDenominator(), 0);
  }
}
