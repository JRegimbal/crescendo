import org.apache.commons.numbers.fraction.*;

public interface Duration {
  BaseDuration getBaseDuration();
  boolean isDotted();
  Fraction getDuration();
  double durationMs();
}
