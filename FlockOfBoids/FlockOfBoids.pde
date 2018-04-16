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
 * Press 'q' to mode Vertex-Vertex representation.
 * Press 'w' to mode Face-Vertex representation.
 */

import java.util.Hashtable;
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
int modeRepresentation;
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


    //draw boid
    pshape.beginShape(kind);
    if(modeRepresentation == 0){
    Vertex v0 = new Vertex(3 * sc, 0, 0);
    Vertex v1 = new Vertex(-3 * sc, 2 * sc, 0);
    Vertex v2 = new Vertex(-3 * sc, -2 * sc, 0);
    Vertex v3 = new Vertex(-3 * sc, 0, 2 * sc);
    
    
    //vecinos de v0
    v0.setNeighboringVectors("v1");
    v0.setNeighboringVectors("v2");
    v0.setNeighboringVectors("v3");
    //vecinos de v1
    v1.setNeighboringVectors("v0");
    v1.setNeighboringVectors("v2");
    v1.setNeighboringVectors("v3");
    //vecinos de v2
    v2.setNeighboringVectors("v0");
    v2.setNeighboringVectors("v1");
    v2.setNeighboringVectors("v3");
    //vecinos de v3
    v3.setNeighboringVectors("v0");
    v3.setNeighboringVectors("v1");
    v3.setNeighboringVectors("v2");
    
    
    pshape.vertex(v0.x, v0.y, v0.z);
    pshape.vertex(v1.x, v1.y, v1.z);
    pshape.vertex(v2.x, v2.y, v2.z);
    pshape.vertex(v0.x, v0.y, v0.z);
    pshape.vertex(v1.x, v1.y, v1.z);
    pshape.vertex(v3.x, v3.y, v3.z);
    pshape.vertex(v0.x, v0.y, v0.z);
    pshape.vertex(v3.x, v3.y, v3.z);
    pshape.vertex(v2.x, v2.y, v2.z);
    pshape.vertex(v3.x, v3.y, v3.z);
    pshape.vertex(v1.x, v1.y, v1.z);
    pshape.vertex(v2.x, v2.y, v2.z);
    
    
    pshape.endShape();
    }else if(modeRepresentation == 1){
    Hashtable<String, PVector> vectors = new Hashtable<String, PVector>();
    PVector v0 = new PVector(3 * sc, 0, 0); // v0
    vectors.put("v0",v0);
    PVector v1 = new PVector(-3 * sc, 2 * sc, 0); // v1
    vectors.put("v1",v1);
    PVector v2 = new PVector(-3 * sc, -2 * sc, 0); // v2
    vectors.put("v2",v2);
    PVector v3 = new PVector(-3 * sc, 0, 2 * sc); // v3
    vectors.put("v3",v3);
    
    //Face1
    ArrayList<String> face1 = new ArrayList<String>();    
    face1.add("v0");    
    face1.add("v1");    
    face1.add("v2");
    
    //Face2   
    ArrayList<String> face2 = new ArrayList<String>();
    face2.add("v0"); 
    face2.add("v1"); 
    face2.add("v3");
    
    //Face3
    ArrayList<String> face3 = new ArrayList<String>();
    face3.add("v0"); 
    face3.add("v3");
    face3.add("v2");
    
    //Face4
    ArrayList<String> face4 = new ArrayList<String>();
    face4.add("v3");
    face4.add("v1"); 
    face4.add("v2");
    
    //Shape
    ArrayList<ArrayList<String>> shape = new ArrayList<ArrayList<String>>();
    shape.add(face1);
    shape.add(face2);
    shape.add(face3);
    shape.add(face4);
 
    //draw boid
    pshape.beginShape(kind);
    
    // FACE-VERTEX
    PVector vertice;
    String a;
    
    for (ArrayList<String> shp : shape) {
        for (int i = 0; i < shp.size(); i++) {
           a = shp.get(i);           
           vertice = vectors.get(a);
           pshape.vertex(vertice.x,vertice.y,vertice.z);      
           
        }
      }
      
    pshape.endShape();
    }
    popStyle();
}

void setup() {  
  size(1000, 800, P3D);
  delay(100);
 
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
  case 'q':
    modeRepresentation = 0;    
    break;
  case 'w':
    modeRepresentation = 1;    
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
