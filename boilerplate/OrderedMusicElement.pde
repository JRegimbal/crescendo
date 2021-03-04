import java.util.List;

abstract class OrderedMusicElement implements Viewable {
  Score parent;
  PVector initialBase = null;
  
  OrderedMusicElement(Score s) {
    assert(s != null);
    this.parent = s;
    this.parent.elements.add(this);
  }
  
  PVector getPosition() { return getBasePosition(); }
  
  PVector getBasePosition() {
    if (initialBase == null) {
      initialBase = this.parent.getBasePosition(getIndex()).copy();
    }
    PVector actual = this.parent.getBasePosition(getIndex());
    /*if (!initialBase.equals(actual)) {
      println("ERROR");
      println(initialBase, actual);
    }*/
    return actual;
  }
   
  PVector getPhysicsPosition() {
    PVector pos = getPosition();
    pos.x -= width / 2;
    pos.set(pos.div(pixelsPerMeter));
    return pos;
  }
  
  int getIndex() {
    return this.parent.elements.indexOf(this);
  }
  
  abstract float getWidth();
  
  void draw() {
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
