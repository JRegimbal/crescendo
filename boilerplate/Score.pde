import java.util.ArrayList;

public class Score {
  PFont smuflFont;
  final static int lineSpacing = 20;  // px
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
    this.smuflFont = createFont("Bravura.otf", totalHeight);
    textFont(smuflFont);
    for (int i = 0; i < lines.length; i++) {
      lines[i] = createShape(LINE, 0 + marginHorizontal, 0 + marginVertical + i * lineSpacing, width - marginHorizontal, marginVertical + i * lineSpacing);
      lines[i].setStroke(strokeWidth);
    }
  }
  
  PVector getBasePosition(int i) {
    float x;
    if (i == 0) {
      x = marginHorizontal + elemMargin;
    }
    else {
      x = getBasePosition(i - 1).x + this.elements.get(i - 1).getWidth() + this.elements.get(i).getWidth();
    }
    
    float y = marginVertical + totalHeight;
    return new PVector(x, y);
  }

  public void draw() {
    textFont(smuflFont);
    textAlign(CENTER);
    fill(0);
    for (PShape line : lines) {
      shape(line);
    }
    
    for (OrderedMusicElement element : elements) {
      element.draw();
    }
  }
  
  public PVector force(PVector posEE, PVector velEE) {
    PVector force = new PVector(0, 0);
    for (OrderedMusicElement element : elements) {
      if (element instanceof Tangible) {
        force.set(force.add(((Tangible)element).force(posEE, velEE)));
      }
    }
    return force;
  }
    
}
