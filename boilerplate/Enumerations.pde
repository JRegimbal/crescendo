import org.apache.commons.numbers.fraction.*;

enum BaseDuration {
  WHOLE(Fraction.of(1, 1)),
  HALF(Fraction.of(1, 2)),
  QUARTER(Fraction.of(1, 4)),
  EIGHTH(Fraction.of(1, 8));
  
  private final Fraction value;
  private BaseDuration(Fraction f) {
    this.value = f;
  }
  public Fraction getValue() {
    return this.value;
  }
}

enum ClefShape {
  C,
  G,
  F
}
