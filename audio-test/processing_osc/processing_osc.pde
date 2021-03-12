import oscP5.*;
import netP5.*;

OscP5 oscP5;

NetAddress destination;

void setup() {
  size(400, 400);
  oscP5 = new OscP5(this, 4200);
  destination = new NetAddress("127.0.0.1", 8080);
}

void draw() {
}

void mousePressed( ){
  println("A4 for 250 ms");
  OscMessage test = new OscMessage("/crescendo/play");
  test.add(440);
  test.add(250);
  oscP5.send(test, destination);
}
