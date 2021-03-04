import java.util.List;

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
  
  abstract float getWidth();
  
  void draw() {
    return;
  }
  
  void update() {
    return;
  }
  
  OrderedMusicElement getPrevious(Class c) {
    int idx = this.parent.elements.indexOf(this);
    if (idx == -1) {
      return null;
    }
    List<OrderedMusicElement> sublist = this.parent.elements.subList(0, idx);
    OrderedMusicElement previous = null;
    for (OrderedMusicElement e : sublist) {
      if (c.isInstance(e)) {
        previous = e;
      }
    }
    return previous;
  }
}
