#include <flutter/runtime_effect.glsl>
out vec4 fragColor;
uniform vec2 uSize;
uniform float iTime;
uniform float val;
uniform sampler2D uTexture;

vec2 mirror(vec2 uv) {
    uv = fract(uv);  // Ensure UV coordinates are in the [0, 1] range
    uv = 2.0 * abs(fract(uv) - 0.5);  // Apply mirror effect
    return uv;
}

vec2 kaleidoscope(vec2 uv, float angle, float segments) {
    // Calculate the displacement from the center
    vec2 center = vec2(0.5, 0.5);
    vec2 delta = uv - center;

    // Calculate the polar coordinates (angle and radius)
    float radius = length(delta);
    float currentAngle = atan(delta.y, delta.x);

    // Adjust the angle to create the kaleidoscope effect
    float kaleidoscopeAngle = mod(currentAngle - angle, 2.0 * 3.14159265 / segments);

    // Convert back to Cartesian coordinates
    vec2 transformedUV = center + radius * vec2(cos(kaleidoscopeAngle), sin(kaleidoscopeAngle));

    return transformedUV;
}

vec2 rotate2D(vec2 coordinates, float angle) {
    float tempX = coordinates.x;
    coordinates.x = cos(-angle) * tempX - sin(-angle) * coordinates.y;
    coordinates.y = sin(-angle) * tempX + cos(-angle) * coordinates.y;

    return coordinates;
}
const int max_its = 100;

vec2 Kaleidoscope(vec2 worldCoordinates, float angle, float segments, float _Progress) {
    int i = 0;
    float segmentOffset = clamp(3.1415 / segments, 0.0, 3.1415);

    int j = 0;
    for (int i = 0; i < max_its; i++) {
        worldCoordinates.x = abs(worldCoordinates.x);
        worldCoordinates.xy = rotate2D(worldCoordinates.xy, angle);

        worldCoordinates.x = abs(worldCoordinates.x);
        worldCoordinates.xy = rotate2D(worldCoordinates.xy, -angle);
        angle += segmentOffset;
         j = i; 
    }

    worldCoordinates.x -= _Progress / 100.0;
    angle += (segments - float(j)) * segmentOffset;
    worldCoordinates.x = abs(worldCoordinates.x);
    worldCoordinates.xy = rotate2D(worldCoordinates.xy, angle);
    worldCoordinates.x = abs(worldCoordinates.x);
    worldCoordinates.xy = rotate2D(worldCoordinates.xy, -angle);
    
    return worldCoordinates;
}
/* 
vec2 Kaleidoscope(vec2 worldCoordinates, float angle, float segments, float _Aspect) {
    float segmentOffset = clamp(3.1415 / segments, 0.0, 3.1415);

    int j = 0;
    for (int i = 0; i < max_its; i++) {
        if(i >= int(segments)){
          break; 
        }
        worldCoordinates.x = abs(worldCoordinates.x);
        worldCoordinates.xy = rotate2D(worldCoordinates.xy, angle);
        worldCoordinates.x = abs(worldCoordinates.x);
        worldCoordinates.xy = rotate2D(worldCoordinates.xy, -angle);

        angle += segmentOffset;
        j = i; 
    }
    angle += (segments - float(j)) * segmentOffset;

    worldCoordinates.x = abs(worldCoordinates.x);
    worldCoordinates.xy = rotate2D(worldCoordinates.xy, angle);
    worldCoordinates.x = abs(worldCoordinates.x);
    worldCoordinates.xy = rotate2D(worldCoordinates.xy, -angle);

    return worldCoordinates;
}

 */

void main() {
  //fragColor = vec4(1.,0.,0.,1.);
  vec2 uv = FlutterFragCoord().xy / uSize;
  fragColor = vec4((sin(iTime)+1.)*0.5,0.,0.,1.); 
  //fragColor = texture(uTexture, kaleidoscope(uv, 60, 9.+0.1*sin(iTime)));
  float change = (sin(iTime)+1)*0.5*3.; 
  
  float _Aspect = uSize.x / uSize.y; 
  uv = uv - 0.5;
  uv = _Aspect < 1? uv*vec2(_Aspect, 1):uv / vec2(1, _Aspect);
  uv = Kaleidoscope(uv, 0., 12., iTime);
  uv += 0.5;
  uv = mirror(uv);
  fragColor = texture(uTexture, uv);
  /* fragColor = texture(uTexture, kaleidoscope(uv, 1+val, 12.+change)); */
  /* if (uv.x > 0.5) {
    fragColor = vec4(1., 0., 0., 1.);
  } else {
    fragColor = vec4(0., 0., 1., 1.);
  } */
}