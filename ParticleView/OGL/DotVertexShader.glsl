
attribute vec4 Position;
attribute float PointSize;

void main(void) {
  gl_Position = Position;
  gl_PointSize = PointSize;
}
