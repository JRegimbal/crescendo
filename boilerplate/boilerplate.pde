import processing.serial.*;
import static java.util.concurrent.TimeUnit.*;
import java.util.concurrent.*;
import java.lang.System;
import controlP5.*;
import oscP5.*;
import netP5.*;

private final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
final int destination = 8080;
final int sourcePort = 8081;
final NetAddress oscDestination = new NetAddress("127.0.0.1", destination);
OscP5 oscP5;

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

/** Music notation info */
Score s;

ControlP5 cp5;

void setup() {
  size(1000, 650);
  frameRate(baseFrameRate);
  /** Open Sound Control */
  oscP5 = new OscP5(this, sourcePort);
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

  cp5 = new ControlP5(this);
  cp5.addSlider("Measure")
     .setPosition(40, height / 2 - 120)
     .setSize(20, 250)
     .setRange(s.totalBars(), 1)
     .setValue(1)
     .setNumberOfTickMarks(s.totalBars())
     .setColorValueLabel(255);

  panto_setup();

  /** Spawn haptics thread */
  SimulationThread st = new SimulationThread();
  handle = scheduler.scheduleAtFixedRate(st, 1, 1, MILLISECONDS);
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
