import de.voidplus.leapmotion.*;
import java.util.Arrays;

ArrayList<Producto> productos;
boolean hayMano = false;
int numero;
LeapMotion leap;
Producto p;
PVector alm, lm;

void setup() {
  size(960, 540);   
  leap = new LeapMotion(this).withGestures("screen_tap");
  lm = new PVector(0, 0, 0);
  alm = new PVector(0, 0, 0);
  thread("cargarProductos");
}

void draw() {

  if (p != null) {
    /*
    p.acelerar((mouseX-pmouseX)/120.);
     if (abs(mouseY-pmouseY) > 40) {
     if (mouseY < pmouseY) numero++;
     if (mouseY > pmouseY) numero--;*/
    p.acelerar((lm.x-alm.x)/120.);
//    if (abs(lm.y-alm.y) > 40) {
//      if (lm.y  < alm.y) numero++;
//      if (lm.y  > alm.y) numero--;
//      if (numero < 0) {
//        numero = productos.size()-1;
//      }
//      if (numero >= productos.size()) {
//        numero = 0;
//      }
//      p = productos.get(numero);
//    }
    p.update();
  }
  leapUpdate();
  if (hayMano) ellipse(lm.x, lm.y, 10, 10);
}

void cargarProductos() {
  productos = new ArrayList<Producto>();

  File file = new File(sketchPath+"/Productos/");
  println(file);
  File[] files = null;
  if (file.isDirectory()) {
    files = file.listFiles();
  } 
  Arrays.sort(files);
  for (int i = 0; i < files.length; i++) {
    String ruta = files[i].toString();
    println(ruta);
    productos.add(new Producto(ruta));
    p = productos.get(productos.size()-1);
    numero = productos.size()-1;
  }
  /*
  productos.add(new Producto(sketchPath+"/Productos/Render001/"));
   productos.add(new Producto(sketchPath+"/Productos/Render002/"));
   */
}

// SCREEN TAP GESTURE
void leapOnScreenTapGesture(ScreenTapGesture g){
  int       id               = g.getId();
  Finger    finger           = g.getFinger();
  PVector   position         = g.getPosition();
  PVector   direction        = g.getDirection();
  long      duration         = g.getDuration();
  float     duration_seconds = g.getDurationInSeconds();
  
  numero++;
  numero %= productos.size();
  p = productos.get(numero);
  println("ScreenTapGesture: "+id);
}

void leapUpdate() {
  int fps = leap.getFrameRate();
  for (Hand hand : leap.getHands ()) {
    PVector hand_position    = hand.getPosition();
    alm.set(lm);
    lm.set(hand_position);
    if (!hayMano) alm.set(lm);
    hayMano = true;
  }
}
