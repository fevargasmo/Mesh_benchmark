/**
 * Flock of Boids
 * by Jean Pierre Charalambos.
 * 
 * This example displays the 2D famous artificial life program "Boids", developed by
 * Craig Reynolds in 1986 and then adapted to Processing in 3D by Matt Wetmore in
 * 2010 (https://www.openprocessing.org/sketch/6910#), in 'third person' eye mode.
 * Boids under the mouse will be colored blue. If you click on a boid it will be
 * selected as the scene avatar for the eye to follow it.
 *
 * Press ' ' to switch between the different eye modes.
 * Press 'a' to toggle (start/stop) animation.
 * Press 'p' to print the current frame rate.
 * Press 'm' to change the mesh visual mode.
 * Press 't' to shift timers: sequential and parallel.
 * Press 'v' to toggle boids' wall skipping.
 * Press 's' to call scene.fitBallInterpolation().
 */

import frames.input.*;
import frames.input.event.*;
import frames.primitives.*;
import frames.core.*;
import frames.processing.*;

Scene scene;
int flockWidth = 1280;
int flockHeight = 720;
int flockDepth = 600;
boolean avoidWalls = true;

// visual modes
// 0. Faces and edges
// 1. Wireframe (only edges)
// 2. Only faces
// 3. Only points
int mode;

int initBoidNum = 900; // amount of boids to start the program with
ArrayList<Boid> flock;
Node avatar;
boolean animate = true;

float sc = 3; // scale factor for the render of the boid
PShape pshape;

void crearPShape(){
    pushStyle();

    pshape = createShape();
    // uncomment to draw boid axes
    //scene.drawAxes(10);

    int kind = TRIANGLES;
    strokeWeight(2);
    stroke(color(0, 255, 0));
    fill(color(255, 0, 0, 125));

    // visual modes
    switch(mode) {
    case 1:
      noFill();
      break;
    case 2:
      noStroke();
      break;
    case 3:
      strokeWeight(3);
      kind = POINTS;
      break;
    }

    
    
    
    Winged_Edge_Vertex v0 = new Winged_Edge_Vertex(3 * sc, 0, 0);
    Winged_Edge_Vertex v1 = new Winged_Edge_Vertex(-3 * sc, 2 * sc, 0);
    Winged_Edge_Vertex v2 = new Winged_Edge_Vertex(-3 * sc, -2 * sc, 0);
    Winged_Edge_Vertex v3 = new Winged_Edge_Vertex(-3 * sc, 0, 2 * sc);
    
    Winged_Edge_Face f0 = new Winged_Edge_Face();
    Winged_Edge_Face f1 = new Winged_Edge_Face();
    Winged_Edge_Face f2 = new Winged_Edge_Face();
    Winged_Edge_Face f3 = new Winged_Edge_Face();
    
    Winged_Edge e0 = new Winged_Edge();    
    Winged_Edge e1 = new Winged_Edge();
    Winged_Edge e2 = new Winged_Edge();
    Winged_Edge e3 = new Winged_Edge();
    Winged_Edge e4 = new Winged_Edge();
    Winged_Edge e5 = new Winged_Edge();
    
    
    //set edges atributes
    // e0
    e0.vert0 = v0;
    e0.vert1 = v1;    
    e0.aFace = f1;
    e0.bFace = f3;
    e0.aPrev = e4;
    e0.aNext = e3;
    e0.bPrev = e1;
    e0.bNext = e2;
    // e1
    e1.vert0 = v1;
    e1.vert1 = v2;    
    e1.aFace = f3;
    e1.bFace = f2;
    e1.aPrev = e0;
    e1.aNext = e2;
    e1.bPrev = e4;
    e1.bNext = e5;
    // e2
    e2.vert0 = v0;
    e2.vert1 = v2;    
    e2.aFace = f3;
    e2.bFace = f0;
    e2.aPrev = e0;
    e2.aNext = e1;
    e2.bPrev = e3;
    e2.bNext = e5;
    // e3
    e3.vert0 = v3;
    e3.vert1 = v0;    
    e3.aFace = f1;
    e3.bFace = f0;
    e3.aPrev = e4;
    e3.aNext = e0;
    e3.bPrev = e2;
    e3.bNext = e5;
    // e4
    e0.vert0 = v3;
    e0.vert1 = v1;    
    e0.aFace = f1;
    e0.bFace = f2;
    e0.aPrev = e3;
    e0.aNext = e0;
    e0.bPrev = e1;
    e0.bNext = e5;
    // e5
    e0.vert0 = v3;
    e0.vert1 = v2;    
    e0.aFace = f0;
    e0.bFace = f2;
    e0.aPrev = e3;
    e0.aNext = e2;
    e0.bPrev = e1;
    e0.bNext = e4;
    
    
    // set edges in vertexs
    print(e0);
    v0.edges.add(e0);
    v0.edges.add(e2);
    v0.edges.add(e3);
    
    v1.edges.add(e0);
    v1.edges.add(e1);
    v1.edges.add(e4);
    
    v2.edges.add(e1);
    v2.edges.add(e2);
    v2.edges.add(e5);
    
    v3.edges.add(e3);
    v3.edges.add(e4);
    v3.edges.add(e5);
        
    
    // set edges in faces
    f0.edges.add(e2);
    f0.edges.add(e3);
    f0.edges.add(e5);
    
    f1.edges.add(e0);
    f1.edges.add(e3);
    f1.edges.add(e4);
    
    f2.edges.add(e1);
    f2.edges.add(e4);
    f2.edges.add(e5);
    
    f3.edges.add(e0);
    f3.edges.add(e1);
    f3.edges.add(e2);
    
    
    
    //draw boid
    pshape.beginShape(kind);
    pshape.vertex(3 * sc, 0, 0);
    pshape.vertex(-3 * sc, 2 * sc, 0);
    pshape.vertex(-3 * sc, -2 * sc, 0);

    pshape.vertex(3 * sc, 0, 0);
    pshape.vertex(-3 * sc, 2 * sc, 0);
    pshape.vertex(-3 * sc, 0, 2 * sc);

    pshape.vertex(3 * sc, 0, 0);
    pshape.vertex(-3 * sc, 0, 2 * sc);
    pshape.vertex(-3 * sc, -2 * sc, 0);

    pshape.vertex(-3 * sc, 0, 2 * sc);
    pshape.vertex(-3 * sc, 2 * sc, 0);
    pshape.vertex(-3 * sc, -2 * sc, 0);
    pshape.endShape();

    popStyle();
}

void setup() {
  size(1000, 800, P3D);
  scene = new Scene(this);
  scene.setBoundingBox(new Vector(0, 0, 0), new Vector(flockWidth, flockHeight, flockDepth));
  scene.setAnchor(scene.center());
  Eye eye = new Eye(scene);
  scene.setEye(eye);
  scene.setFieldOfView(PI / 3);
  //interactivity defaults to the eye
  scene.setDefaultGrabber(eye);
  scene.fitBall();
  // create and fill the list of boids
  flock = new ArrayList();
  crearPShape();
  for (int i = 0; i < initBoidNum; i++)
    flock.add(new Boid(new Vector(flockWidth / 2, flockHeight / 2, flockDepth / 2)));
}

void draw() {
  background(0);
  ambientLight(128, 128, 128);
  directionalLight(255, 255, 255, 0, 1, -100);
  walls();
  // Calls Node.visit() on all scene nodes.
  scene.traverse();
}

void walls() {
  pushStyle();
  noFill();
  stroke(255);

  line(0, 0, 0, 0, flockHeight, 0);
  line(0, 0, flockDepth, 0, flockHeight, flockDepth);
  line(0, 0, 0, flockWidth, 0, 0);
  line(0, 0, flockDepth, flockWidth, 0, flockDepth);

  line(flockWidth, 0, 0, flockWidth, flockHeight, 0);
  line(flockWidth, 0, flockDepth, flockWidth, flockHeight, flockDepth);
  line(0, flockHeight, 0, flockWidth, flockHeight, 0);
  line(0, flockHeight, flockDepth, flockWidth, flockHeight, flockDepth);

  line(0, 0, 0, 0, 0, flockDepth);
  line(0, flockHeight, 0, 0, flockHeight, flockDepth);
  line(flockWidth, 0, 0, flockWidth, 0, flockDepth);
  line(flockWidth, flockHeight, 0, flockWidth, flockHeight, flockDepth);
  popStyle();
}

void keyPressed() {
  switch (key) {
  case 'a':
    animate = !animate;
    break;
  case 's':
    if (scene.eye().reference() == null)
      scene.fitBallInterpolation();
    break;
  case 't':
    scene.shiftTimers();
    break;
  case 'p':
    println("Frame rate: " + frameRate);
    break;
  case 'v':
    avoidWalls = !avoidWalls;
    break;
  case 'm':
    mode = mode < 3 ? mode+1 : 0;
    crearPShape();
    break;
  case ' ':
    if (scene.eye().reference() != null) {
      scene.lookAt(scene.center());
      scene.fitBallInterpolation();
      scene.eye().setReference(null);
    } else if (avatar != null) {
      scene.eye().setReference(avatar);
      scene.interpolateTo(avatar);
    }
    break;
  }
}
