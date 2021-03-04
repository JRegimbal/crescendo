import java.util.List;

/**
 * Base class for any music elements that appear
 */
abstract class OrderedMusicElement implements Viewable {
  Score parent;
  
  OrderedMusicElement(Score s) {
    assert(s != null);
    this.parent = s;
    this.parent.elements.add(this);
  }
  
  /** Get the correct (x,y) position to render the element on the staff */
  PVector getPosition() { return getBasePosition(); }
  
  /** The base position that puts the element in the correct x position */
  PVector getBasePosition() {
    PVector actual = this.parent.getBasePosition(getIndex());
    return actual;
  }
   
  /** Get location in meters using the coordinate system for physics defined in Panto */
  PVector getPhysicsPosition() {
    PVector pos = getPosition();
    pos.x -= width / 2;
    pos.set(pos.div(pixelsPerMeter));
    return pos;
  }
  
  int getIndex() {
    return this.parent.elements.indexOf(this);
  }
  
  /** Returns width of this element in pixels */
  abstract float getWidth();
  
  /** Draw this element (must be implemented) */
  void draw() {
    return;
  }
  
  /** Get previous element of a certain type */
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
