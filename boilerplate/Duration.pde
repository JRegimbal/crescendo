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
    TimeSignature ts = (TimeSignature) e.getPrevious(TimeSignature.class);
    if(ts==null){
      ts= new TimeSignature(e.parent, 4, 4);
    }
    double durationMs = 60/tempo;
    double shape2time= (double)ts.den/shape.getDenominator();
    durationMs= durationMs*shape2time*1000;
    return durationMs;
  }
}
