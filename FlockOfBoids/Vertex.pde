public class Vertex{
  float x;
  float y;
  float z;
  ArrayList<String> neighboringVectors = new ArrayList<String>();
  
  Vertex (float x, float y, float z) {  
    this.x = x; 
    this.y = y;
    this.z = z;
  }
  
  
  
  ArrayList<String> getNeighboringVectors(){
    return this.neighboringVectors;
  }
  
  void setNeighboringVectors(String v){
    this.neighboringVectors.add(v);
  }
}
