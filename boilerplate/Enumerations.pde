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
  C("\ue05c"),
  G("\ue050"),
  F("\ue062");
  
  private final String glyph;
  private ClefShape(String s) {
    this.glyph = s;
  }
  public String getGlyph() {
    return this.glyph;
  }
}

enum Accidental {
  NONE(""),
  FLAT("\ue260"),
  NATURAL("\ue261"),
  SHARP("\ue262");
  
  private final String glyph;
  private Accidental(String s) {
    this.glyph = s;
  }
  
  public String getGlyph() {
    return this.glyph;
  }
}

enum KeySignature {
  CMaj(""),
  GMaj("\ue262"),
  DMaj("\ue262"),
  AMaj("\ue262"),
  EMaj("\ue262"),
  BMaj("\ue262"),
  FsMaj("\ue262"),
  CsMaj("\ue262"),
  FMaj("\ue260"),
  BfMaj("\ue260"),
  EfMaj("\ue260"),
  AfMaj("\ue260"),
  DfMaj("\ue260"),
  GfMaj("\ue260"),
  CfMaj("\ue260");
  
  private final String glyph;
  private KeySignature (String s) {
    this.glyph = s;
  }
  
  public String getGlyph() {
    return this.glyph;
  }
}
  
