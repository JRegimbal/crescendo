import processing.serial.*;
import static java.util.concurrent.TimeUnit.*;
import java.util.concurrent.*;
import java.lang.System;

private final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);

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

/** Music notation info */
Score s;
Clef c;
TimeSignature t;
Rest r, r2;
Note n, n1;
BarLine b, b2;

void setup() {
  size(1000, 650);
  frameRate(baseFrameRate);
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
  c = new Clef(s, ClefShape.G, KeySignature.DMaj);
  t = new TimeSignature(s, 3, 4);
  r = new Rest(s, BaseDuration.HALF);
  // Make a new quarter note that is dotted and one space up from the first staff line
  n = new Note(s, BaseDuration.QUARTER, true, 1);
  b = new BarLine(s);
  // Make a new eighth note on the first staff line
  n1 = new Note(s, BaseDuration.EIGHTH, 0);
  r2 = new Rest(s, BaseDuration.QUARTER);
  println(s.elements.size());

  s.draw();
  panto_setup();

  /** Spawn haptics thread */
  SimulationThread st = new SimulationThread();
  handle = scheduler.scheduleAtFixedRate(st, 1, 1, MILLISECONDS);
}

void draw() {
  if (renderingForce == false) {
    background(255);
    // The order here is important!
    s.draw(1);
    update_animation(angles.x * radsPerDegree, angles.y * radsPerDegree, posEE.x, posEE.y);
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

    torques.set(widget.set_device_torques(fEE.array()));
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
