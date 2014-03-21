
int HEIGHT = 30;
int WIDTH = 30;
float SCALE_CAMERA_Z = 0.5;
float DAMPING = 0.99;
int MAX_HEIGHT = 255;
int SCALE_HEIGHT_TO_255 = 2 * MAX_HEIGHT / 255;
int SCALE_SCREEN_TO_WORLD = 512 / WIDTH;

int[][] last_heights = new int[WIDTH][HEIGHT];
int[][] next_heights = new int[WIDTH][HEIGHT];

void setup() {
  frameRate(10);
  size(512, 512, P3D);
  zero_field(last_heights); zero_field(next_heights);
}

void draw() {
  update_fields();
  draw_field_wireframe(next_heights);
  draw_field_greyscale(next_heights);
  int[][] temp = last_heights;
  last_heights = next_heights;
  next_heights = temp;
}

void mouseDragged() {
  next_heights[mouseX / SCALE_SCREEN_TO_WORLD][mouseY / SCALE_SCREEN_TO_WORLD] = -MAX_HEIGHT;
}

// ============


void update_fields() {
  int i; int j;
  for (i = 1; i < WIDTH - 1; i++) {
    for (j = 1; j < HEIGHT - 1; j++) {
      next_heights[i][j] = int(
        (last_heights[i - 1][j] +
         last_heights[i + 1][j] +
         last_heights[i][j - 1] +
         last_heights[i][j + 1]) / 2 - next_heights[i][j]);
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
  //perspective();
  float cameraZ = ((HEIGHT/2.0) / tan(PI*60.0/360.0));
  perspective(PI/3.0, WIDTH/HEIGHT, cameraZ / 10, cameraZ * 10);
  camera(WIDTH / 2, HEIGHT / 2, (HEIGHT/2.0) / tan(PI*30.0 / 180.0),
         WIDTH / 2, HEIGHT / 2, 0,
         0, 1, 0);
  //camera();
//  box(WIDTH, HEIGHT, 10);
  draw_mesh(heights);
}

void draw_field_solid(int[][] heights) {
  background(0,0,0);
  noStroke(); //fill(200, 200, 200);
  //specular(150,150,150);
  //lights();
  pointLight(0,0,200, 0, 0, 500);
  //emissive(100,100,100);
  shininess(0.5);
  //perspective();
//  camera(WIDTH / 2, HEIGHT / 2, CAMERA_Z,
//         WIDTH / 2, HEIGHT / 2, 0,
//         0, 1, 0);
  draw_mesh(heights);
}

void draw_mesh(int[][] heights) {
  int i; int j;
  for (j = 0; j < HEIGHT - 1; j++) {
    beginShape(TRIANGLE_STRIP);
    for (i = 0; i < WIDTH - 1; i++) {
      vertex(i, j, heights[i][j] / MAX_HEIGHT);
      vertex(i, j+1, heights[i][j+1] / MAX_HEIGHT);
      vertex(i+1, j, heights[i+1][j] / MAX_HEIGHT);
      vertex(i+1, j+1, heights[i+1][j+1] / MAX_HEIGHT);
    }
    endShape();
  }
}

// ====================

