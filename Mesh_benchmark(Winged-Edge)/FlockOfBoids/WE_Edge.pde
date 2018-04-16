class Winged_Edge {
  Winged_Edge_Vertex vert0, vert1;
  Winged_Edge_Face aFace, bFace;
  Winged_Edge aPrev, aNext, bPrev, bNext;
  
}
class Winged_Edge_Vertex {
  float x;
  float y;
  float z;
  ArrayList<Winged_Edge> edges = new ArrayList<Winged_Edge>();  
  
  Winged_Edge_Vertex (float x, float y, float z) {  
    this.x = x; 
    this.y = y;
    this.z = z;
  }
}
class Winged_Edge_Face {
  ArrayList<Winged_Edge> edges = new ArrayList<Winged_Edge>();  
}
