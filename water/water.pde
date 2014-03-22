
int HEIGHT = 100;
int WIDTH = 100;
float SCALE_CAMERA_Z = 0.5;
float DAMPING = 0.99;
int MAX_HEIGHT = 255;
int SCALE_HEIGHT_TO_255 = 2 * MAX_HEIGHT / 255;

int[][] last_heights = new int[WIDTH][HEIGHT];
int[][] next_heights = new int[WIDTH][HEIGHT];

void setup() {
  frameRate(30);
  size(1024, 768, P3D);
  zero_field(last_heights); zero_field(next_heights);
}

void draw() {
  update_fields_4();
  draw_field_solid(next_heights);
  draw_field_greyscale(next_heights);
  int[][] temp = last_heights;
  last_heights = next_heights;
  next_heights = temp;
}

void mouseDragged() {
  next_heights[int(WIDTH * mouseX / width)][int(HEIGHT * mouseY / height)] = -MAX_HEIGHT;
}

// ============

void update_fields_4() {
  int i; int j;
  for (i = 1; i < WIDTH - 1; i++) {
    for (j = 1; j < HEIGHT - 1; j++) {
      next_heights[i][j] = int(
        (last_heights[i-1][j] +
         last_heights[i+1][j] +
         last_heights[i][j-1] +
         last_heights[i][j+1]) / 2
         - next_heights[i][j]);
      next_heights[i][j] *= DAMPING;
    }
  }
}

void update_fields_8() {
  int i; int j;
  for (i = 1; i < WIDTH - 1; i++) {
    for (j = 1; j < HEIGHT - 1; j++) {
      next_heights[i][j] = int(
        (last_heights[i-1][j] +
         last_heights[i+1][j] +
         last_heights[i][j-1] +
         last_heights[i][j+1]) / 4 +
        (last_heights[i+1][j+1] +
         last_heights[i+1][j-1] +
         last_heights[i-1][j-1] +
         last_heights[i-1][j+1]) / 6
         - next_heights[i][j]);
      next_heights[i][j] *= DAMPING;
    }
  }
}

void zero_field(int[][] field) {
  int i; int j;
  for (i = 0; i < WIDTH; i++) {
    for (j = 0; j < HEIGHT; j++) {
      field[i][j] = 0;
    }
  }
}

void draw_field_greyscale(int[][] heights) {
  loadPixels();
  int i; int j;
  for (i = 0; i < WIDTH; i++) {
    for (j = 0; j < HEIGHT; j++) {
      int h = heights[i][j];
      int grey = (h + MAX_HEIGHT) / SCALE_HEIGHT_TO_255;
      //print(grey, " ");
      pixels[j * width + i] = color(grey, grey, grey);
    }
    //println();
  }
  updatePixels();
}

void draw_field_wireframe(int[][] heights) {
  background(0,0,0);
  stroke(200, 200, 200);
  noLights(); noFill();
  set_view();
  draw_mesh(heights);
}

void set_view() {
  float cameraZ = ((HEIGHT/2.0) / tan(PI*60.0/360.0));
  perspective(PI/3.0, WIDTH/HEIGHT, cameraZ / 10, cameraZ * 10);
  camera(WIDTH / 2, HEIGHT * 1.5, (HEIGHT/2.0) / tan(PI*30.0 / 180.0),
         WIDTH / 2, HEIGHT / 2, 0,
         0, 1, 0);

}

void draw_field_solid(int[][] heights) {
  background(0,0,0);
  noStroke(); //fill(200, 200, 200);
  specular(255,255,255);
  shininess(0.2);
  //lights();
  pointLight(200,200,255, 40, 40, 40);
  //directionalLight(100, 100, 100, 1, 0.5, -1);
  emissive(50,50,50);
  set_view();
  draw_mesh(heights);
}

void draw_mesh(int[][] heights) {
  int i; int j;
  float scale = float(MAX_HEIGHT / 4);
  for (j = 0; j < HEIGHT - 1; j++) {
    beginShape(TRIANGLE_STRIP);
    for (i = 0; i < WIDTH - 1; i+=2) {
      vertex(i, j, heights[i][j] / scale);
      vertex(i, j+1, heights[i][j+1] / scale);
      vertex(i+1, j, heights[i+1][j] / scale);
      vertex(i+1, j+1, heights[i+1][j+1] / scale);
    }
    endShape();
  }
}

void draw_mesh_fan(int[][] heights) {
  int i; int j;
  float scale = float(MAX_HEIGHT / 4);
  for (i = 1; i < WIDTH-1; i+=2) {
    for (j = 1; j < HEIGHT-1; j+=2) {
      beginShape(TRIANGLE_FAN);
      vertex(i, j, heights[i][j]/ scale);
      vertex(i, j-1, heights[i][j-1] / scale);
      vertex(i+1,j-1, heights[i+1][j-1] / scale);
      vertex(i+1, j, heights[i+1][j] / scale);
      vertex(i+1, j+1, heights[i+1][j+1] / scale);
      vertex(i, j+1, heights[i][j+1] / scale);
      vertex(i-1, j+1, heights[i-1][j+1] / scale);
      vertex(i-1, j, heights[i-1][j] / scale);
      vertex(i-1, j-1, heights[i-1][j-1] / scale);
      vertex(i, j-1, heights[i][j-1] / scale);
      endShape();
    }
  }
}

// ====================

