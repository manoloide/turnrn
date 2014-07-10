import de.voidplus.leapmotion.*;
import java.util.Arrays;

ArrayList<Producto> productos;
boolean hayMano = false;
float vely = 0;
int numero;
LeapMotion leap;
Producto seleccionado;
PVector antPosMano, posMano;
PVector antProDedos, proDedos;

void setup() {
  size(960, 540);   
  leap = new LeapMotion(this).withGestures("screen_tap");
  posMano = new PVector(0, 0, 0);
  antPosMano = new PVector(0, 0, 0);
  antProDedos = new PVector(0, 0, 0);
  proDedos = new PVector(0, 0, 0);
  thread("cargarProductos");
}

void draw() {
  frame.setTitle("turnrn     --    fps:"+ frameRate);
  if (seleccionado!= null) {
    /*
    seleccionado.acelerar((mouseX-pmouseX)/120.);
     if (abs(mouseY-pmouseY) > 40) {
     if (mouseY < pmouseY) numero++;
     if (mouseY > pmouseY) numero--;*/
    seleccionado.acelerar((posMano.x-antPosMano.x)/120.);
    //    if (abs(posMano.y-antPosMano.y) > 40) {
    //      if (posMano.y  < antPosMano.y) numero++;
    //      if (posMano.y  > antPosMano.y) numero--;
    //      if (numero < 0) {
    //        numero = productos.size()-1;
    //      }
    //      if (numero >= productos.size()) {
    //        numero = 0;
    //      }
    //      seleccionado = productos.get(numero);
    //    }
    seleccionado.update();
  /*
    vely += proDedos.y-antProDedos.y;
    vely *= 0.8;
    if (vely > 100) {
      numero++;
      numero %= productos.size();
      vely = 0;
      seleccionado = productos.get(numero);
    }*/
  }
  leapUpdate();
  //if (hayMano) ellipse(posMano.x, posMano.y, 10, 10);
  vely += proDedos.y-antProDedos.y;
  vely *= 0.6;
  fill(255, 0, 0);
  ellipse(width/3, height/2+vely, 10, 10);
  fill(0, 255, 0);
  ellipse(width/3*2, posMano.y, 10, 10);
}

void cargarProductos() {
  productos = new ArrayList<Producto>();
  //cargar todas las carpetas dentro de productos;
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
    if (seleccionado == null) seleccionado = productos.get(productos.size()-1);
  }
  //productos.add(new Producto(sketchPath+"/Productos/Render001/"));
  //if (seleccionado == null) seleccionado = productos.get(productos.size()-1);
  //productos.add(new Producto(sketchPath+"/Productos/Render002/"));
  numero = productos.size()-1;
}

// SCREEN TAP GESTURE
void leapOnScreenTapGesture(ScreenTapGesture g) {
  int       id               = g.getId();
  Finger    finger           = g.getFinger();
  PVector   position         = g.getPosition();
  PVector   direction        = g.getDirection();
  long      duration         = g.getDuration();
  float     duration_seconds = g.getDurationInSeconds();

  /*
  numero++;
   numero %= productos.size();
   p = productos.get(numero);
   println("ScreenTapGesture: "+id);
   */
}

void leapUpdate() {
  //int fps = leap.getFrameRate();
  int mano = 0;
  for (Hand hand : leap.getHands ()) {
    mano++;
    if (mano > 1) break;
    antProDedos.set(proDedos);
    int cantidadDedos = 0;
    proDedos = new PVector(0, 0, 0);
    for (Finger finger : hand.getFingers ()) {
      cantidadDedos++;
      proDedos.add(finger.getPosition());
    }
    if (cantidadDedos > 0) proDedos.div(cantidadDedos);
    else antProDedos.set(proDedos);
    PVector hand_position = hand.getPosition();
    antPosMano.set(posMano);
    posMano.set(hand_position);
    if (!hayMano) {
      antProDedos.set(proDedos);
      antPosMano.set(posMano);
    }
    hayMano = true;
  }
}
