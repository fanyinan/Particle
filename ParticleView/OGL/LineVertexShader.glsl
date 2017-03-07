
attribute vec4 Position;
attribute vec4 Color;

varying vec4 frag_Color;

void main(void) {
  frag_Color = Color;
  gl_Position = Position;
}
