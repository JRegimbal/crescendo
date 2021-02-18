import java.util.ArrayList;

public class Score {
  PFont bravura;
  final int lineSpacing = 20;  // px
  final int strokeWidth = 4;   // px
  final int totalHeight = lineSpacing * 4;
  final int marginVertical = (height - totalHeight) / 2;
  final int marginHorizontal = 0;
  final int elemMargin = 2 * lineSpacing;
  final int elemSpacing = totalHeight;

  public ArrayList<OrderedMusicElement> elements = new ArrayList();
  PShape[] lines = new PShape[5];
  
  public Score() {
    this.elements.clear();
    this.bravura = createFont("Bravura.otf", totalHeight);
    final int totalHeight = lineSpacing * 4;
    final int marginVertical = (height - totalHeight) / 2;
    final int marginHorizontal = 0;
    for (int i = 0; i < lines.length; i++) {
      lines[i] = createShape(LINE, 0 + marginHorizontal, 0 + marginVertical + i * lineSpacing, width - marginHorizontal, marginVertical + i * lineSpacing);
      lines[i].setStroke(strokeWidth);
    }
  }
  
  PVector getBasePosition(int i) {
    int x = marginHorizontal + elemMargin + i *elemSpacing;
    int y = marginVertical + totalHeight;
    return new PVector(x, y);
  }
  
  public void draw() {
    textFont(bravura);
    textAlign(CENTER);
    fill(0);
    for (PShape line : lines) {
      shape(line);
    }
    
    for (OrderedMusicElement element : elements) {
      element.draw();
    }
  }
    
}
