
int HEIGHT = 512;
int WIDTH = 512;
float DAMPING = 0.99;
int MAX_HEIGHT = 65535;
int SCALE_HEIGHT_TO_255 = 2 * MAX_HEIGHT / 255;

int[][] last_heights = new int[WIDTH][HEIGHT];
int[][] next_heights = new int[WIDTH][HEIGHT];

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

void setup() {
  frameRate(30);
  size(WIDTH, HEIGHT);
  zero_field(last_heights); zero_field(next_heights);
}

void draw() {
  update_fields();
  draw_field(next_heights);
  int[][] temp = last_heights;
  last_heights = next_heights;
  next_heights = temp;
}

void mouseDragged() {
  next_heights[mouseX][mouseY] = -MAX_HEIGHT;
}

void draw_field(int[][] heights) {
  loadPixels();
  int i; int j;
  for (i = 0; i < WIDTH; i++) {
    for (j = 0; j < HEIGHT; j++) {
      int height = heights[i][j];
      int grey = (height + MAX_HEIGHT) / SCALE_HEIGHT_TO_255;
      //print(grey, " ");
      pixels[j * WIDTH + i] = color(grey, grey, grey);
    }
    //println();
  }
  updatePixels();
}

