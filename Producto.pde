class Producto {
  ArrayList<PImage> imgs;
  boolean cargo;
  float mov, vel;
  int cant, frame;
  Producto(String src) {
    imgs = new ArrayList<PImage>();
    mov = 0; 
    vel = 1;
    cargo = false;
    File file = new File(src);
    println(file);
    File[] files = null;
    if (file.isDirectory()) {
      files = file.listFiles();
    } 
    Arrays.sort(files);
    for (int i = 0; i < files.length; i++) {
      String ruta = files[i].toString();
      //String nombre = split(files[i].getName(), ".")[0];
      String extension = ruta.substring(ruta.lastIndexOf(".") + 1, ruta.length());
      if (!extension.equals("jpg")) continue;
      println(ruta);
      PImage aux = loadImage(ruta);
      imgs.add(aux);
    }
    cargo = true;
    cant = imgs.size();
    frame = cant/2;
  }
  void update() {
    mover(vel);
    vel *= 0.85;
    draw();
  }
  void draw() {
    image(imgs.get(frame), 0, 0);
  }
  void acelerar(float a) {
    vel += a;
  }
  void mover(float m) {
    mov += m;
    if (mov < 0) {
      mov = 0;
    }
    if (mov >= cant) {
      mov = cant-1;
    }
    frame = int(mov)%cant;
  }
}
