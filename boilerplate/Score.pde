import java.util.ArrayList;

/**
 * Score class. Contains musical elements, defines the appearance of the score,
 * is responsible for calling the required functions for rendering on different modalities.
 */
public class Score {
  PFont smuflFont;
  final static int lineSpacing = 20;  // px
  final int strokeWidth = 2;   // px
  final int totalHeight = lineSpacing * 4;
  final int marginVertical = (height - totalHeight) / 2;
  final int marginHorizontal = 200;
  final int elemMargin = 2 * lineSpacing;
  final int elemSpacing = totalHeight;
  public int tempo;
  private int startIdx = 0;

  public ArrayList<OrderedMusicElement> elements = new ArrayList();
  PShape[] lines = new PShape[5];
  
  public Score(int bpm) {
    this.elements.clear();
    this.smuflFont = createFont("Bravura.otf", totalHeight);
    textFont(smuflFont);
    for (int i = 0; i < lines.length; i++) {
      strokeWeight(strokeWidth);
      lines[i] = createShape(LINE, 0 + marginHorizontal, 0 + marginVertical + i * lineSpacing, width - marginHorizontal, marginVertical + i * lineSpacing);
    }
    this.tempo = bpm;
  }
  
  PVector getBasePosition(int i) {
    return getBasePosition(i, startIdx);
  }
  
  PVector getBasePosition(int i, int base) {
    float x;
    if (i <= base) {
      x = marginHorizontal + elemMargin;
    }
    else {
      x = getBasePosition(i - 1).x + this.elements.get(i - 1).getWidth() + this.elements.get(i-1).getPadding();
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
  
  private ArrayList getBars() {
    ArrayList<OrderedMusicElement> bars = new ArrayList();
    for (OrderedMusicElement element : elements) {
      if (element instanceof BarLine) {
        bars.add(element);
      }
    }
    return bars;
  }
  
  public int totalBars() {
    int barCount = getBars().size();
    if (!(elements.get(elements.size() - 1) instanceof BarLine)) {
      // implicit last bar
      barCount += 1;
    }
    return barCount;
  } 
  
  /** Draw only the ith measure */
  public void draw(int i) {
    textFont(smuflFont);
    textAlign(CENTER);
    fill(0);
    for (PShape line: lines) { shape(line); }
    
    ArrayList<OrderedMusicElement> bars = getBars();
    startIdx = 0;
    int endIdx;
    if (bars.size() == 0) {
      this.draw();
      return;
    }

    if (i == 0) {
      // First bar
      endIdx = elements.indexOf(bars.get(0)) + 1;
    }
    else if (i < bars.size()) {
      // This is not the last bar
      // Draw elements between previous and this bar
      startIdx = elements.indexOf(bars.get(i-1));
      endIdx = elements.indexOf(bars.get(i)) + 1;
    }
    else {
      // Draw the last implicit bar if it exists
      if (elements.get(elements.size() - 1) instanceof BarLine) {
        // Last is a bar. Do nothing.
        println("Error");
        return;
      }
      startIdx = elements.indexOf(bars.get(bars.size() - 1));
      endIdx = elements.size();
    }
    for (OrderedMusicElement element : elements.subList(startIdx, endIdx)) {
      element.draw();
    }
  }
  
  public PVector force(PVector posEE, PVector velEE) {
    PVector force = new PVector(0, 0);
    for (PShape line : lines) {
      force.set(force.add(staffForce(posEE, velEE, line)));
    }
    for (OrderedMusicElement element : elements) {
      if (element instanceof Tangible) {
        force.set(force.add(((Tangible)element).force(posEE, velEE)));
      }
    }
    return force;
  }
  
  /** Get location in meters using the coordinate system for physics defined in Panto */
  PVector getPhysicsPosition(PShape line) {
    PVector pos = new PVector(line.getParams()[0], line.getParams()[1]);
    pos.x -= width / 2;
    pos.set(pos.div(pixelsPerMeter));
    return pos;
  }
  
  private PVector staffForce(PVector posEE, PVector velEE, PShape line) {
    PVector linePos = getPhysicsPosition(line);
    PVector force= new PVector(0, 0);
     //each case of these types of forces will get a different amount of force
    if (abs(posEE.y - linePos.y) < 0.0005) {
      if(linePos.y == 0.07125){
        System.out.println("hello");
        return new PVector(1,2);
      }
      if(linePos.y == 0.07625){
        System.out.println("how");
        return new PVector(1,1.75);
      }
      if(linePos.y == 0.08125){
        System.out.println("are");
        return new PVector(1,1.5);
      }
      if(linePos.y == 0.08625){
        System.out.println("you");
        return new PVector(1,1.25);
      }
      if(linePos.y == 0.09125){
        System.out.println("today");
        return new PVector(1,1);
      }
      else{
          System.out.println("didn't work");
      }
      //return new PVector(1, 1);
    }
    return force;
  }
    
}
