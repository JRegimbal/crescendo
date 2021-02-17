class Note extends DurationElement implements Tangible {
  int location;
  
  public Note(Score s) {
    super(s);
  }
  
  // TODO Update Implementation
  PVector force(PVector posEE) {
    return new PVector(0, 0);
  }
}
