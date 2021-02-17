abstract class OrderedMusicElement implements Viewable {
  Score parent;
  
  public OrderedMusicElement(Score s) {
    assert(s != null);
    this.parent = s;
    this.parent.elements.add(this);
  }
  
  PShape draw() {
    return createShape(ELLIPSE, 10, 10, 10, 10);
  }
}
