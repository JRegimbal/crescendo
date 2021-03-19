/**
 * Marks boundary of bar/measure
 * This should eventually use our own and support final barlines
 */
class BarLine extends OrderedMusicElement {
  float barWidth;
  
  BarLine(Score s) {
    super(s);
    barWidth = textWidth("\ue030");
  }
  
  PVector getPosition() {
    PVector basePosition = getBasePosition();
    basePosition.x += getWidth() / 2.0;
    return basePosition;
  }
  
  float getWidth() { return barWidth; }
  
  float getPadding() { return 2 * this.parent.lineSpacing; }
  
  void draw() {
    PVector pos = getPosition();
    text("\ue030", pos.x, pos.y);
  }
}
