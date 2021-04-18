/** Just an extra file to organize pantograph specific things. */

/* Screen and world setup parameters */
float             pixelsPerMeter                      = 4000.0;
float             radsPerDegree                       = 0.01745;

/* pantagraph link parameters in meters */
float             l                                   = 0.07;
float             L                                   = 0.09;

/* device graphical position */
PVector           deviceOrigin                        = new PVector(0, 0);

/* end effector radius in meters */
//float             rEE                                 = 0.006;
float rEE = Score.lineSpacing / 2 / pixelsPerMeter;

PShape pGraph, joint, endEffector;

void panto_setup() {
  deviceOrigin.add(width / 2, 0);
  create_pantagraph();
}

void create_pantagraph(){
  pushMatrix();
  float lAni = pixelsPerMeter * l;
  float LAni = pixelsPerMeter * L;
  float rEEAni = pixelsPerMeter * rEE;
  
  pGraph = createShape();
  pGraph.beginShape();
  pGraph.fill(255, 0);
  pGraph.stroke(0);
  pGraph.strokeWeight(2);
  
  pGraph.vertex(deviceOrigin.x, deviceOrigin.y);
  pGraph.vertex(deviceOrigin.x, deviceOrigin.y);
  pGraph.vertex(deviceOrigin.x, deviceOrigin.y);
  pGraph.vertex(deviceOrigin.x, deviceOrigin.y);
  pGraph.endShape(CLOSE);
  
  joint = createShape(ELLIPSE, deviceOrigin.x, deviceOrigin.y, rEEAni, rEEAni);
  joint.setStroke(color(0));
  
  endEffector = createShape(ELLIPSE, deviceOrigin.x, deviceOrigin.y, 2*rEEAni, 2*rEEAni);
  endEffector.setStroke(color(0));
  strokeWeight(5);
  popMatrix();
}

void update_animation(float th1, float th2, float xE, float yE){
  pushMatrix();
  float lAni = pixelsPerMeter * l;
  float LAni = pixelsPerMeter * L;
  
  xE = pixelsPerMeter * xE;
  yE = pixelsPerMeter * yE;
  
  th1 = 3.14 - th1;
  th2 = 3.14 - th2;
  
  pGraph.setVertex(1, deviceOrigin.x + lAni*cos(th1), deviceOrigin.y + lAni*sin(th1));
  pGraph.setVertex(3, deviceOrigin.x + lAni*cos(th2), deviceOrigin.y + lAni*sin(th2));
  pGraph.setVertex(2, deviceOrigin.x + xE, deviceOrigin.y + yE);
  
  System.out.println("Pos.y: "+posEE.y);
  if(posEE.y>0.06 && posEE.y<0.11){ //if we are within the score, don't draw it, otherwise do
    
  }
  else{
    shape(pGraph);
    shape(joint);
  
  
    translate(xE, yE);
    shape(endEffector);
  }
  popMatrix();
}
