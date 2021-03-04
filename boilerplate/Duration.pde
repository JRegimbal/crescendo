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
    if (this.dotted) {
      Fraction nextSmallest= new Fraction();
      nextSmallest.setNumerator(1);
      nextSmallest.setDenominator(dur.getDenominator()/2);
      dur= dur.add(nextSmallest);
    }
    return dur;
  }
  
  double durationMs() {
    Fraction shape= this.getDuration();
    TimeSignature ts = this.getPrevious(TimeSignature.class);
    double tempo= this.tempo; //not sure if this has been implemented yet
    double durationMs = 60/tempo;
    double shape2time= ts.denominator/shape.getDenominator();
    durationMs= durationMs*shape2time;
    return durationMs;
  }
}
