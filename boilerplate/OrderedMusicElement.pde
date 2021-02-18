abstract class OrderedMusicElement implements Viewable {
  Score parent;
  
  OrderedMusicElement(Score s) {
    assert(s != null);
    this.parent = s;
    this.parent.elements.add(this);
  }
  
  PVector getPosition() { return getBasePosition(); }
  
  PVector getBasePosition() {
    return this.parent.getBasePosition(getIndex());
  }
  
  int getIndex() {
    return this.parent.elements.indexOf(this);
  }
  
  void draw() {
    return;
  }
}
