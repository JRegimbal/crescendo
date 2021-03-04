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
    Fraction dur = getBaseDuration().getValue();
    if (this.dotted) {
      // include next smallest duration
    }
    return dur;
  }
  
  double durationMs() {
    durationMs = 0;
    return Double.NaN;
  }
}
