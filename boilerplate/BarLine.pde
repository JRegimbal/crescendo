/**
 * Marks boundary of bar/measure
 */
class BarLine extends OrderedMusicElement {
  float barWidth = this.parent.lineSpacing;
  
  BarLine(Score s) {
    super(s);
  }
  
  PVector getPosition() {
    PVector basePosition = getBasePosition();
    basePosition.x += getWidth() / 2.0;
    return basePosition;
  }
  
  float getWidth() { return barWidth; }
  
  void draw() {
    PVector pos = getPosition();
    PShape l = createShape(LINE, pos.x, pos.y, pos.x, pos.y - 4 * this.parent.lineSpacing);
    l.setStroke(this.parent.strokeWidth);
    shape(l);
  }
}
