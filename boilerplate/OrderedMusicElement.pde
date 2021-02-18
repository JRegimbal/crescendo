abstract class OrderedMusicElement implements Viewable {
  Score parent;
  
  public OrderedMusicElement(Score s) {
    assert(s != null);
    this.parent = s;
    this.parent.elements.add(this);
  }
  
  public PVector getPosition() { return getBasePosition(); }
  
  public PVector getBasePosition() {
    int x = this.parent.marginHorizontal + this.parent.elemMargin + getIndex() * this.parent.elemSpacing;
    int y = this.parent.marginVertical + this.parent.totalHeight;
    return new PVector(x, y);
  }
  
  public int getIndex() {
    return this.parent.elements.indexOf(this);
  }
  
  void draw() {
    return;
  }
}
