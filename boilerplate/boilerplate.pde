import processing.serial.*;
import static java.util.concurrent.TimeUnit.*;
import java.util.concurrent.*;
import java.lang.System;
import controlP5.*;
// import org.puredata.core.*;
import org.puredata.processing.PureData;

PureData pd;

/** Settings */
boolean NOTE_TEXTURE = true;
boolean NOTE_FORCE = true;
boolean STAFF_LINES = true;
boolean STAFF_GLOBAL = false;
final boolean DAMPING = true;
/** End settings */

enum Song {
  ASA_BRANCA,
  DISNEY,
  MARY,
}

Song song = Song.DISNEY;

private final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
final int destination = 8080;
final int sourcePort = 8081;
//final NetAddress oscDestination = new NetAddress("127.0.0.1", destination);
//OscP5 oscP5;

/** Haply setup */
Board haplyBoard;
Device widget;
Mechanisms pantograph;

byte widgetID = 5;
int CW = 0;
int CCW = 1;
boolean renderingForce = false;
long baseFrameRate = 120;
ScheduledFuture<?> handle;

PVector angles = new PVector(0, 0);
PVector torques = new PVector(0 ,0);
PVector posEE = new PVector(0, 0);
PVector posEELast = new PVector(0, 0);
PVector velEE = new PVector(0, 0);
PVector fEE = new PVector(0, 0);

boolean engaged = true;

PFont font1;
PFont font2;

/** Music notation info */
Score s;

ControlP5 cp5;
int patch;
/*
PdReceiver receiver = new PdReceiver() {
  @Override
  public void print(String s) {
    println(s);
  }
  public void receiveList(String s, Object... args) {
  }
  public void receiveBang(String s) { print(s); }
  public void receiveFloat(String s, float f) { print(s + f); }
  public void receiveSymbol(String s, String d) { print(s + d); }
  public void receiveMessage(String s, String d, Object... args) { print(s + d); }
};
*/

void setup() {
  size(1000, 650);
  frameRate(baseFrameRate);
  pd = new PureData(this, 44100, 0, 2);
  pd.openPatch("oscTest.pd");
  pd.start();
  /*
  PdBase.setReceiver(receiver);
  PdBase.openAudio(0, 2, 44100);
  try {
    patch = PdBase.openPatch(dataPath("oscTest.pd"));
  } catch (IOException e) {
    println("Unable to open patch!");
    println(e.getMessage());
  }
  println(patch);
  PdBase.computeAudio(true);
  PdBase.start();
  */

  /** Haply */
  haplyBoard = new Board(this, Serial.list()[0], 0);
  widget = new Device(widgetID, haplyBoard);
  pantograph = new Pantograph();
  widget.set_mechanism(pantograph);
  widget.add_actuator(1, CCW, 2);
  widget.add_actuator(2, CW, 1);
  widget.add_encoder(1, CCW, 241, 10752, 2);
  widget.add_encoder(2, CW, -61, 10752, 1);
  widget.device_set_parameters();

  /** Score */
  if (song == Song.ASA_BRANCA) {
    s = new Score(105);
    new Clef(s, ClefShape.G, KeySignature.GMaj);
    new TimeSignature(s, 2, 4);
    new Note(s, BaseDuration.EIGHTH, 2);
    new Note(s, BaseDuration.EIGHTH, 3);
    new BarLine(s);
    new Note(s, BaseDuration.QUARTER, 4);
    new Note(s, BaseDuration.QUARTER, 6);
    new BarLine(s);
    new Note(s, BaseDuration.QUARTER, 6);
    new Note(s, BaseDuration.QUARTER, 4);
    new BarLine(s);
    new Note(s, BaseDuration.QUARTER, 5);
    new Note(s, BaseDuration.QUARTER, 5);
    new BarLine(s);
    new Note(s, BaseDuration.QUARTER, 5);
    new Note(s, BaseDuration.EIGHTH, 2);
    new Note(s, BaseDuration.EIGHTH, 3);
    new BarLine(s);
    new Note(s, BaseDuration.QUARTER, 4);
    new Note(s, BaseDuration.QUARTER, 6);
    new BarLine(s);
    new Note(s, BaseDuration.QUARTER, 6);
    new Note(s, BaseDuration.QUARTER, 5);
    new BarLine(s);
    new Note(s, BaseDuration.HALF, 4);
    new BarLine(s);
    new Rest(s, BaseDuration.EIGHTH);
    new Note(s, BaseDuration.EIGHTH, 2);
    new Note(s, BaseDuration.EIGHTH, 2);
    new Note(s, BaseDuration.EIGHTH, 3);
    new BarLine(s);
    new Note(s, BaseDuration.QUARTER, 4);
    new Note(s, BaseDuration.QUARTER, 6);
    new BarLine(s);
    new Rest(s, BaseDuration.EIGHTH);
    new Note(s, BaseDuration.EIGHTH, 6);
    new Note(s, BaseDuration.EIGHTH, 5);
    new Note(s, BaseDuration.EIGHTH, 4);
    new BarLine(s);
    new Note(s, BaseDuration.QUARTER, 2);
    new Note(s, BaseDuration.QUARTER, 5);
    new BarLine(s);
    new Rest(s, BaseDuration.EIGHTH);
    new Note(s, BaseDuration.EIGHTH, 5);
    new Note(s, BaseDuration.EIGHTH, 4);
    new Note(s, BaseDuration.EIGHTH, 3);
    new BarLine(s);
    new Note(s, BaseDuration.QUARTER, 3);
    new Note(s, BaseDuration.QUARTER, 4);
    new BarLine(s);
    new Rest(s, BaseDuration.EIGHTH);
    new Note(s, BaseDuration.EIGHTH, 3);
    new Note(s, BaseDuration.EIGHTH, 3);
    new Note(s, BaseDuration.EIGHTH, 2);
    new BarLine(s);
    new Note(s, BaseDuration.HALF, 2);
    new BarLine(s);
    new Rest(s, BaseDuration.EIGHTH);
    new Note(s, BaseDuration.EIGHTH, 2);
    new Note(s, BaseDuration.EIGHTH, 2);
    new Note(s, BaseDuration.EIGHTH, 3);
    new BarLine(s);
    new Note(s, BaseDuration.QUARTER, 4);
    new Note(s, BaseDuration.QUARTER, 6);
    new BarLine(s);
    new Rest(s, BaseDuration.EIGHTH);
    new Note(s, BaseDuration.EIGHTH, 6);
    new Note(s, BaseDuration.EIGHTH, 5);
    new Note(s, BaseDuration.EIGHTH, 4);
    new BarLine(s);
    new Note(s, BaseDuration.QUARTER, 2);
    new Note(s, BaseDuration.QUARTER, 5);
    new Rest(s, BaseDuration.EIGHTH);
    new Note(s, BaseDuration.EIGHTH, 5);
    new Note(s, BaseDuration.EIGHTH, 4);
    new Note(s, BaseDuration.EIGHTH, 3);
    new BarLine(s);
    new Note(s, BaseDuration.QUARTER, 3);
    new Note(s, BaseDuration.QUARTER, 4);
    new BarLine(s);
    new Rest(s, BaseDuration.EIGHTH);
    new Note(s, BaseDuration.EIGHTH, 3);
    new Note(s, BaseDuration.EIGHTH, 3);
    new Note(s, BaseDuration.EIGHTH, 2);
    new BarLine(s);
    new Note(s, BaseDuration.HALF, 2);
    new BarLine(s);
  }
  else if (song == Song.DISNEY) {
    s = new Score(105);
    new Clef(s, ClefShape.G, KeySignature.CMaj);
    new TimeSignature(s, 4, 4);
    new Rest(s, BaseDuration.HALF);
    new Note(s, BaseDuration.EIGHTH, 0);
    new Note(s, BaseDuration.EIGHTH, 2);
    new Note(s, BaseDuration.EIGHTH, 4);
    new Note(s, BaseDuration.EIGHTH, 5);
    new BarLine(s);
    new Note(s, BaseDuration.HALF, 1);
    new Rest(s, BaseDuration.HALF);
    new BarLine(s);
    new Rest(s, BaseDuration.HALF);
    new Note(s, BaseDuration.EIGHTH, 0);
    new Note(s, BaseDuration.EIGHTH, 2);
    new Note(s, BaseDuration.EIGHTH, 4);
    new Note(s, BaseDuration.EIGHTH, 5);
    new BarLine(s);
    new Note(s, BaseDuration.HALF, 6);
    new Rest(s, BaseDuration.HALF);
    new BarLine(s);
    new Rest(s, BaseDuration.HALF);
    new Note(s, BaseDuration.EIGHTH, 5);
    new Note(s, BaseDuration.EIGHTH, 6);
    new Note(s, BaseDuration.EIGHTH, 7);
    new Note(s, BaseDuration.EIGHTH, 8);
    new BarLine(s);
    new Note(s, BaseDuration.HALF, 9);
    new Note(s, BaseDuration.EIGHTH, 9);
    new Note(s, BaseDuration.EIGHTH, 8);
    new Note(s, BaseDuration.EIGHTH, 7);
    new Note(s, BaseDuration.EIGHTH, 6);
    new BarLine(s);
    new Note(s, BaseDuration.HALF, 5);
    new Note(s, BaseDuration.EIGHTH, 8);
    new Note(s, BaseDuration.EIGHTH, 7);
    new Note(s, BaseDuration.EIGHTH, 6);
    new Note(s, BaseDuration.EIGHTH, 5);
    new BarLine(s);
    new Note(s, BaseDuration.HALF, 2);
    new Rest(s, BaseDuration.HALF);
    new BarLine(s);
    new Rest(s, BaseDuration.HALF);
    new Note(s, BaseDuration.EIGHTH, 0);
    new Note(s, BaseDuration.EIGHTH, 2);
    new Note(s, BaseDuration.EIGHTH, 4);
    new Note(s, BaseDuration.EIGHTH, 5);
    new BarLine(s);
    new Note(s, BaseDuration.HALF, 1);
    new Rest(s, BaseDuration.HALF);
    new BarLine(s);
    new Rest(s, BaseDuration.HALF);
    new Note(s, BaseDuration.EIGHTH, 0);
    new Note(s, BaseDuration.EIGHTH, 2);
    new Note(s, BaseDuration.EIGHTH, 4);
    new Note(s, BaseDuration.EIGHTH, 5);
    new BarLine(s);
    new Note(s, BaseDuration.HALF, 6);
    new Note(s, BaseDuration.EIGHTH, 7);
    new Note(s, BaseDuration.EIGHTH, 6);
    new Note(s, BaseDuration.EIGHTH, 7);
    new Note(s, BaseDuration.EIGHTH, 9);
    new BarLine(s);
    new Note(s, BaseDuration.HALF, 5);
    new Note(s, BaseDuration.EIGHTH, 5);
    new Note(s, BaseDuration.EIGHTH, 4);
    new Note(s, BaseDuration.EIGHTH, 5);
    new Note(s, BaseDuration.EIGHTH, 7);
    new BarLine(s);
    new Note(s, BaseDuration.HALF, 1);
    new Note(s, BaseDuration.EIGHTH, 7);
    new Note(s, BaseDuration.EIGHTH, 8);
    new Note(s, BaseDuration.EIGHTH, 6);
    new Note(s, BaseDuration.EIGHTH, 7);
    new BarLine(s);
    new Note(s, BaseDuration.HALF, 5);
    new Rest(s, BaseDuration.HALF);
    new BarLine(s);
    new Rest(s, BaseDuration.HALF);
    new Note(s, BaseDuration.EIGHTH, 7);
    new Note(s, BaseDuration.EIGHTH, 6);
    new Note(s, BaseDuration.EIGHTH, 7);
    new Note(s, BaseDuration.EIGHTH, 9);
    new BarLine(s);
    new Note(s, BaseDuration.HALF, 5);
    new Note(s, BaseDuration.EIGHTH, 5);
    new Note(s, BaseDuration.EIGHTH, 4);
    new Note(s, BaseDuration.EIGHTH, 5);
    new Note(s, BaseDuration.EIGHTH, 7);
    new BarLine(s);
    new Note(s, BaseDuration.HALF, 1);
    new Note(s, BaseDuration.EIGHTH, 7);
    new Note(s, BaseDuration.EIGHTH, 8);
    new Note(s, BaseDuration.EIGHTH, 6);
    new Note(s, BaseDuration.EIGHTH, 7);
    new BarLine(s);
    new Note(s, BaseDuration.WHOLE, 5);
    new BarLine(s);
  }
  else if (song == Song.MARY) {
    s = new Score(120);
    new Clef(s, ClefShape.G, KeySignature.CMaj);
    new TimeSignature(s, 4, 4);
    new Note(s, BaseDuration.QUARTER, 0);
    new Note(s, BaseDuration.QUARTER, -1);
    new Note(s, BaseDuration.QUARTER, -2);
    new Note(s, BaseDuration.QUARTER, -1);
    new BarLine(s);
    new Note(s, BaseDuration.QUARTER, 0);
    new Note(s, BaseDuration.QUARTER, 0);
    new Note(s, BaseDuration.HALF, 0);
    new BarLine(s);
    new Note(s, BaseDuration.QUARTER, -1);
    new Note(s, BaseDuration.QUARTER, -1);
    new Note(s, BaseDuration.HALF, -1);
    new BarLine(s);
    new Note(s, BaseDuration.QUARTER, 0);
    new Note(s, BaseDuration.QUARTER, 2);
    new Note(s, BaseDuration.HALF, 2);
    new BarLine(s);
    new Note(s, BaseDuration.QUARTER, 0);
    new Note(s, BaseDuration.QUARTER, -1);
    new Note(s, BaseDuration.QUARTER, -2);
    new Note(s, BaseDuration.QUARTER, -1);
    new BarLine(s);
    new Note(s, BaseDuration.QUARTER, 0);
    new Note(s, BaseDuration.QUARTER, 0);
    new Note(s, BaseDuration.QUARTER, 0);
    new Note(s, BaseDuration.QUARTER, 0);
    new BarLine(s);
    new Note(s, BaseDuration.QUARTER, -1);
    new Note(s, BaseDuration.QUARTER, -1);
    new Note(s, BaseDuration.QUARTER, 0);
    new Note(s, BaseDuration.QUARTER, -1);
    new BarLine(s);
    new Note(s, BaseDuration.WHOLE, -2);
    new BarLine(s);
  }

  cp5 = new ControlP5(this);
  cp5.addSlider("Measure")
     .setPosition(40, height / 2 - 120)
     .setSize(20, 250)
     .setRange(s.totalBars(), 1)
     .setValue(1)
     .setNumberOfTickMarks(s.totalBars())
     .setColorValueLabel(255);
     
  cp5.addToggle("STAFF_LINES")
    .setPosition(40, 500)
    .setSize(50, 20)
    .setCaptionLabel("Staff Lines")
    .setColorCaptionLabel(0)
    ;
  cp5.addToggle("NOTE_TEXTURE")
    .setPosition(100, 500)
    .setSize(50, 20)
    .setCaptionLabel("Note Texture")
    .setColorCaptionLabel(0)
    ;
  cp5.addToggle("NOTE_FORCE")
    .setPosition(160, 500)
    .setSize(50, 20)
    .setCaptionLabel("Note Nudge")
    .setColorCaptionLabel(0)
    ;

  panto_setup();

  /** Spawn haptics thread */
  SimulationThread st = new SimulationThread();
  handle = scheduler.scheduleAtFixedRate(st, 1, 1, MILLISECONDS);
  
  font1 = loadFont("D-DIN-Bold-48.vlw");
  font2 = loadFont("D-DIN-48.vlw");
}

void draw() {
  if (renderingForce == false) {
    background(255);
    // The order here is important!
    s.draw(
      (int)cp5.get("Measure").getValue() - 1
    );
    update_animation(angles.x * radsPerDegree, angles.y * radsPerDegree, posEE.x, posEE.y);
  }
  
  textFont(font1, 24);
  fill(0);
  text("Can you guess the song?", 150, 50);
  
  textFont(font2, 15);
  fill(0);
  text("Use the up and down arrow keys", 150, 80);
  text("to change the measure", 150, 100);
//  PdBase.pollPdMessageQueue();
}

void keyPressed() {
  if (keyCode == DOWN) {
    if (cp5.get("Measure").getValue() < cp5.get(Slider.class, "Measure").getMin()) {
      cp5.get("Measure").setValue(cp5.get("Measure").getValue() + 1);
    }
  }
  else if (keyCode == UP) {
    if (cp5.get("Measure").getValue() > 1) {
      cp5.get("Measure").setValue(cp5.get("Measure").getValue() - 1);
    }
  }
  else if (keyCode == SHIFT) {
    engaged = false;
  }
}

void keyReleased() {
  if (keyCode == SHIFT) {
    engaged = true;
  }
}

// Zero the Haply before ending
void exit() {
  handle.cancel(true);
  scheduler.shutdown();
  widget.set_device_torques(new float[]{0, 0});
  widget.device_write_torques();
  super.exit();
}

// Haptics thread
class SimulationThread implements Runnable {
  public void run() {
    renderingForce = true;
    if (haplyBoard.data_available()) {
      widget.device_read_data();
      angles.set(widget.get_device_angles());
      posEE.set(widget.get_device_position(angles.array()));
      posEE.set(device_to_graphics(posEE));
      velEE.set((posEE.copy().sub(posEELast)).div(0.001));
      posEELast.set(posEE);
      fEE.set(s.force(posEE, velEE));
    }

    if (engaged) {
      torques.set(widget.set_device_torques(fEE.array()));
    }
    else {
      torques.set(widget.set_device_torques(new float[]{0, 0}));
    }
    widget.device_write_torques();
    renderingForce = false;
  }
}

/** Helper */
PVector device_to_graphics(PVector deviceFrame) {
  return deviceFrame.set(-deviceFrame.x, deviceFrame.y);
}

PVector graphics_to_device(PVector graphicsFrame) {
  return graphicsFrame.set(-graphicsFrame.x, graphicsFrame.y);
}

void pdPrint(String s) { println(s); }
