
void main(void) {
  
  if (length(gl_PointCoord - vec2(0.5)) > 0.5)
    discard;
  gl_FragColor = vec4(1, 1, 1, 0.7);
}
