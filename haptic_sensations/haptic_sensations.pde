/**
 **********************************************************************************************************************
 * @file       haptic_sensations.pde
 * @author     Hannah E., Rubia G.
 * @version    V1.0.0
 * @date       03-March-2021
 * @brief      Haptic sketching for CanHaptics 501 project
 **********************************************************************************************************************
 * @attention
 *
 *
 **********************************************************************************************************************
 */

/* library imports *****************************************************************************************************/
import processing.serial.*;
import static java.util.concurrent.TimeUnit.*;
import java.util.concurrent.*;
/* end library imports *************************************************************************************************/


/* scheduler definition ************************************************************************************************/
private final ScheduledExecutorService scheduler      = Executors.newScheduledThreadPool(1);
/* end scheduler definition ********************************************************************************************/


/* device block definitions ********************************************************************************************/
Board             haplyBoard;
Device            widgetOne;
Mechanisms        pantograph;

byte              widgetOneID                         = 5;
int               CW                                  = 0;
int               CCW                                 = 1;
boolean           renderingForce                     = false;
/* end device block definition *****************************************************************************************/


/* framerate definition ************************************************************************************************/
long              baseFrameRate                       = 120;
/* end framerate definition ********************************************************************************************/


/* elements definition *************************************************************************************************/

/* Screen and world setup parameters */
float             pixelsPerCentimeter                 = 40.0;

/* generic data for a 2DOF device */
/* joint space */
PVector           angles                              = new PVector(0, 0);
PVector           torques                             = new PVector(0, 0);

/* task space */
PVector           posEE                               = new PVector(0, 0);
PVector           fEE                                 = new PVector(0, 0); 

/* World boundaries */
FWorld            world;
float             worldWidth                          = 30.0;  
float             worldHeight                         = 20.0; 

float             edgeTopLeftX                        = 0.0; 
float             edgeTopLeftY                        = 0.0; 
float             edgeBottomRightX                    = worldWidth; 
float             edgeBottomRightY                    = worldHeight;

float             gravityAcceleration                 = 980; //cm/s2

/* Initialization of virtual tool */
HVirtualCoupling  s;

/* define notations blocks */
FBox              l1;
FBox              l2;
FBox              l3;
FBox              l4;
FBox              l5;
FCircle           n1;
FCircle           n2;
FCircle           n3;
FCircle           n4;
FCircle           n5;
FCircle           n6;

/* define mode parameters */
boolean           toggle_lines                        = false;
boolean           moving                              = false;

float x;
float y;

float threshold = 50;
float barFx = -0.90;
float barFy = -0.90;

float noteFx = -1.15;
float noteFy = -1.15;

float damping = 700;

float barWidth = 0.15;
float barSpace = 1.5;

/* end elements definition *********************************************************************************************/


/* setup section *******************************************************************************************************/
void setup() {
  /* put setup code here, run once: */

  /* screen size definition */
  size(1200, 800);

  /* device setup */

   /**  
   * The board declaration needs to be changed depending on which USB serial port the Haply board is connected.
   * In the base example, a connection is setup to the first detected serial device, this parameter can be changed
   * to explicitly state the serial port will look like the following for different OS:
   *
   *      windows:      haplyBoard = new Board(this, "COM10", 0);
   *      linux:        haplyBoard = new Board(this, "/dev/ttyUSB0", 0);
   *      mac:          haplyBoard = new Board(this, "/dev/cu.usbmodem1411", 0);
   */
  haplyBoard          = new Board(this, Serial.list()[1], 1);
  widgetOne           = new Device(widgetOneID, haplyBoard);
  pantograph          = new Pantograph();

  widgetOne.set_mechanism(pantograph);

  widgetOne.add_actuator(1, CCW, 2);
  widgetOne.add_actuator(2, CW, 1);

  widgetOne.add_encoder(1, CCW, 241, 10752, 2);
  widgetOne.add_encoder(2, CW, -61, 10752, 1);


  widgetOne.device_set_parameters();

  /* 2D physics scaling and world creation */
  hAPI_Fisica.init(this); 
  hAPI_Fisica.setScale(pixelsPerCentimeter); 
  world               = new FWorld();

  /* bars */
  l1                  = new FBox(worldWidth, barWidth);
  l1.setPosition(worldWidth/2, worldHeight/2 - barSpace*2 - barWidth);
  l1.setFill(20, 10, 5, 100);
  l1.setDensity(900);
  l1.setSensor(true);
  l1.setNoStroke();
  l1.setStatic(true);
  l1.setName("bar");
  world.add(l1);

  l2                  = new FBox(worldWidth, barWidth);
  l2.setPosition(worldWidth/2, worldHeight/2 - barSpace - barWidth);
  l2.setFill(20, 1, 5, 100);
  l2.setDensity(350);
  l2.setSensor(true);
  l2.setNoStroke();
  l2.setStatic(true);
  l2.setName("bar");
  world.add(l2);

  l3                  = new FBox(worldWidth, barWidth);
  l3.setPosition(worldWidth/2, worldHeight/2);
  l3.setFill(20, 10, 5, 100);
  l3.setDensity(350);
  l3.setSensor(true);
  l3.setNoStroke();
  l3.setStatic(true);
  l3.setName("bar");
  world.add(l3);

  l4                  = new FBox(worldWidth, barWidth);
  l4.setPosition(worldWidth/2, worldHeight/2 + barSpace + barWidth);
  l4.setFill(20, 10, 5, 100);
  l4.setDensity(350);
  l4.setSensor(true);
  l4.setNoStroke();
  l4.setStatic(true);
  l4.setName("bar");
  world.add(l4);

  l5                  = new FBox(worldWidth, barWidth);
  l5.setPosition(worldWidth/2, worldHeight/2 + barSpace*2 + barWidth);
  l5.setFill(20, 10, 5, 100);
  l5.setSensor(true);
  l5.setDensity(350);
  l5.setNoStroke();
  l5.setStatic(true);
  l5.setName("bar");
  world.add(l5);

  /* notes */
  n1                  = new FCircle(1);
  n1.setPosition(worldWidth+4, l2.getY());
  n1.setFill(0, 0, 0);
  n1.setDensity(600);
  n1.setSensor(true);
  n1.setNoStroke();
  n1.setStatic(true);
  n1.setName("note");
  world.add(n1);

  n2                  = new FCircle(1);
  n2.setPosition(worldWidth+2, l1.getY());
  n2.setFill(0, 0, 0);
  n2.setDensity(600);
  n2.setSensor(true);
  n2.setNoStroke();
  n2.setStatic(true);
  n2.setName("note");
  world.add(n2);

  n3                  = new FCircle(1);
  n3.setPosition(worldWidth+6, l3.getY());
  n3.setFill(0, 0, 0);
  n3.setDensity(600);
  n3.setSensor(true);
  n3.setNoStroke();
  n3.setStatic(true);
  n3.setName("note");
  world.add(n3);

  n4                  = new FCircle(1);
  n4.setPosition(worldWidth/2-3, l4.getY()-l1.getY());
  n4.setFill(0, 0, 0);
  n4.setDensity(600);
  n4.setSensor(true);
  n4.setNoStroke();
  n4.setStatic(true);
  n4.setName("note");
  world.add(n4);

  n5                  = new FCircle(1);
  n5.setPosition(worldWidth/2-6, l4.getY());
  n5.setFill(0, 0, 0);
  n5.setDensity(600);
  n5.setSensor(true);
  n5.setNoStroke();
  n5.setStatic(true);
  n5.setName("note");
  world.add(n5);

  n6                  = new FCircle(1);
  n6.setPosition(worldWidth/2-8, l2.getY()-barSpace/2);
  n6.setFill(0, 0, 0);
  n6.setDensity(600);
  n6.setSensor(true);
  n6.setNoStroke();
  n6.setStatic(true);
  n6.setName("note");
  world.add(n6);  

  /* Setup the Virtual Coupling Contact Rendering Technique */
  s                   = new HVirtualCoupling((0.75)); 
  s.h_avatar.setDensity(4); 
  s.h_avatar.setFill(255, 0, 0); 
  s.h_avatar.setSensor(false);

  s.init(world, edgeTopLeftX+worldWidth/2, edgeTopLeftY+2); 

  /* World conditions setup */
  world.setGravity((0.0), gravityAcceleration); //1000 cm/(s^2)
  world.setEdges((edgeTopLeftX), (edgeTopLeftY), (edgeBottomRightX), (edgeBottomRightY)); 
  world.setEdgesRestitution(.4);
  world.setEdgesFriction(0.5);

  world.draw();

  /* setup framerate speed */
  frameRate(baseFrameRate);

  /* setup simulation thread to run at 1kHz */
  SimulationThread st = new SimulationThread();
  scheduler.scheduleAtFixedRate(st, 1, 1, MILLISECONDS);
}
/* end setup section ***************************************************************************************************/


/* draw section ********************************************************************************************************/
void draw() {
  /* put graphical code here, runs repeatedly at defined framerate in setup, else default at 60fps: */
  if (renderingForce == false) {
    background(255);
    world.draw();
  }
}
/* end draw section ****************************************************************************************************/


/* keyboard inputs ********************************************************************************************************/
void keyPressed() {
  /*reset*/
  if (key == '1') {
    moving = false;
    toggle_lines = false;
    noteFx = -1.15;
    noteFy = -1.15;
    barFx = -0.90;
    barFy = -0.90;
    damping = 700;
  }
  /*press to feel the staff, press again to turn off*/
  if (key == '2') {
    toggle_lines = !toggle_lines;
  }
  /*press to move the notes, press to stop moving them (they will be static)*/
  if (key == '3') {
    moving = !moving;
  }
  /*tune note forces*/
  if (key == '4') {
    noteFx -= 0.1;
    noteFy -= 0.1;
  }
  if (key == '5') {
    noteFx += 0.1;
    noteFy += 0.1;
  }
  /*tune bar forces*/
  if (key == '6') {
    barFx -= 0.1;
    barFy -= 0.1;
  }
  if (key == '7') {
    barFx += 0.05;
    barFy += 0.05;
  }
  /*tune damping*/
  if (key == '8') {
    damping -= 100;
  }
  if (key == '9') {
    damping += 100;
  }
}


/* simulation section **************************************************************************************************/
class SimulationThread implements Runnable {

  public void run() {
    /* put haptic simulation code here, runs repeatedly at 1kHz as defined in setup */

    renderingForce = true;

    if (haplyBoard.data_available()) {
      /* GET END-EFFECTOR STATE (TASK SPACE) */
      widgetOne.device_read_data();

      angles.set(widgetOne.get_device_angles()); 
      posEE.set(widgetOne.get_device_position(angles.array()));
      posEE.set(posEE.copy().mult(200));
    }

    s.setToolPosition(edgeTopLeftX+worldWidth/2-(posEE).x, edgeTopLeftY+(posEE).y-7); 
    s.updateCouplingForce();


    fEE.set(-s.getVirtualCouplingForceX(), s.getVirtualCouplingForceY());
    fEE.div(100000); //dynes to newtons

    PVector force = new PVector(0, 0);

    /* toggle sticky feeling on staff */
    if (toggle_lines && (s.h_avatar.isTouchingBody(l1) || s.h_avatar.isTouchingBody(l2) || s.h_avatar.isTouchingBody(l3)
      ||s.h_avatar.isTouchingBody(l4)||s.h_avatar.isTouchingBody(l5))) {
      fEE.x = barFx;
      fEE.y = barFy;
    } else if (!toggle_lines) {
      s.h_avatar.setDamping(4);
      s.h_avatar.setDensity(4);
    }

    /* sticky feeling for notes */
    if (s.h_avatar.isTouchingBody(n1)) {
      PVector loc = new PVector(n1.getX(), n1.getY());
      PVector xDiff = new PVector(posEE.x - n1.getX() + worldWidth/2, posEE.y - n1.getY() + worldHeight/2);
      s.h_avatar.setDamping(damping);
      if ((xDiff.mag()) < threshold) {
        fEE.x = noteFx;
        fEE.y = noteFy;
      }
    } else {
      s.h_avatar.setDamping(4);
    }

    if (s.h_avatar.isTouchingBody(n2)) {
      PVector loc = new PVector(n2.getX(), n2.getY());
      PVector xDiff = new PVector(posEE.x - n2.getX() + worldWidth/2, posEE.y - n2.getY() + worldHeight/2);
      s.h_avatar.setDamping(damping);
      if ((xDiff.mag()) < threshold) {
        fEE.x = noteFx;
        fEE.y = noteFy;
      }
    } else {
      s.h_avatar.setDamping(4);
    }

    if (s.h_avatar.isTouchingBody(n3)) {
      PVector loc = new PVector(n3.getX(), n3.getY());
      PVector xDiff = new PVector(posEE.x - n3.getX() + worldWidth/2, posEE.y - n3.getY() + worldHeight/2);
      s.h_avatar.setDamping(damping);
      if ((xDiff.mag()) < threshold) {
        fEE.x = noteFx;
        fEE.y = noteFy;
      }
    } else {
      s.h_avatar.setDamping(4);
    }

    if (s.h_avatar.isTouchingBody(n4)) {
      PVector loc = new PVector(n4.getX(), n4.getY());
      PVector xDiff = new PVector(posEE.x - n4.getX() + worldWidth/2, posEE.y - n4.getY() + worldHeight/2);
      s.h_avatar.setDamping(damping);
      if ((xDiff.mag()) < threshold) {
        fEE.x = noteFx;
        fEE.y = noteFy;
      }
    } else {
      s.h_avatar.setDamping(4);
    }

    if (s.h_avatar.isTouchingBody(n5)) {
      PVector loc = new PVector(n5.getX(), n5.getY());
      PVector xDiff = new PVector(posEE.x - n5.getX() + worldWidth/2, posEE.y - n5.getY() + worldHeight/2);
      s.h_avatar.setDamping(damping);
      if ((xDiff.mag()) < threshold) {
        fEE.x = noteFx;
        fEE.y = noteFy;
      }
    } else {
      s.h_avatar.setDamping(4);
    }

    if (s.h_avatar.isTouchingBody(n6)) {
      PVector loc = new PVector(n6.getX(), n6.getY());
      PVector xDiff = new PVector(posEE.x - n6.getX() + worldWidth/2, posEE.y - n6.getY() + worldHeight/2);
      s.h_avatar.setDamping(damping);
      if ((xDiff.mag()) < threshold) {
        fEE.x = noteFx;
        fEE.y = noteFy;
      }
    } else {
      s.h_avatar.setDamping(4);
    }

    /* animate notes */
    if (moving) {
      x = n1.getX();
      y = n1.getY();
      n1.setPosition(x - 0.005, y);

      x = n2.getX();
      y = n2.getY();
      n2.setPosition(x - 0.005, y);

      x = n3.getX();
      y = n3.getY();
      n3.setPosition(x - 0.005, y);

      x = n4.getX();
      y = n4.getY();
      n4.setPosition(x - 0.005, y);

      x = n5.getX();
      y = n5.getY();
      n5.setPosition(x - 0.005, y);

      x = n6.getX();
      y = n6.getY();
      n6.setPosition(x - 0.005, y);
    } 

    if (n1.getX() <= 0) {
      n1.setPosition(30, n1.getY());
    }

    if (n2.getX() <= 0) {
      n2.setPosition(30, n2.getY());
    }

    if (n3.getX() <= 0) {
      n3.setPosition(30, n3.getY());
    }

    if (n4.getX() <= 0) {
      n4.setPosition(30, n4.getY());
    }

    if (n5.getX() <= 0) {
      n5.setPosition(30, n5.getY());
    }

    if (n6.getX() <= 0) {
      n6.setPosition(30, n6.getY());
    }
    /*end of animate note section*/

    torques.set(widgetOne.set_device_torques(fEE.array()));
    widgetOne.device_write_torques();

    world.step(1.0f/1000.0f);

    renderingForce = false;
  }
}

/* end simulation section **********************************************************************************************/


/* helper functions section, place helper functions here ***************************************************************/
PVector device_to_graphics(PVector deviceFrame) {
  return deviceFrame.set(-deviceFrame.x, deviceFrame.y);
}

PVector graphics_to_device(PVector graphicsFrame) {
  return graphicsFrame.set(-graphicsFrame.x, graphicsFrame.y);
}

/* end helper functions section ****************************************************************************************/
