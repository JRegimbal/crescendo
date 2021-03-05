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
    System.out.println("fraction: "+dur);
    if (this.isDotted()) {
      System.out.println("strawberry");
      Fraction nextSmallest= Fraction.of(1, dur.getDenominator()*2);
      dur= dur.add(nextSmallest);
      System.out.println("berry "+dur);
    }
    return dur;
  }
  
  double durationMs() {
    Fraction shape= this.getDuration();
    System.out.println("dalmation: "+shape);
    //the calls for time signature and tempo are probably wrong
    OrderedMusicElement e = (OrderedMusicElement) this;
    double tempo = e.parent.tempo;
    System.out.println("Tempo: "+tempo);
    TimeSignature ts = e.parent.timeSig;
    System.out.println("time sig: "+ts.num+" "+ts.den);
    Fraction tsFrac= Fraction.of(1, ts.den);
    if(ts==null){
      tsFrac= Fraction.of(1, 4);  //we want just the denominator for the time 4/4
    }
    double durationMs = 60/tempo;
    Fraction shape2timeFrac= (shape.divide(tsFrac));
    System.out.println("shape2time: "+shape2timeFrac);
    double shape2time= ((double) shape2timeFrac.getNumerator())/((double) shape2timeFrac.getDenominator());
    durationMs= durationMs*shape2time*1000;
    System.out.println("duration: "+durationMs);
    return durationMs;
  }
}
