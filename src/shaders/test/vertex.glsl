varying vec2 vUv;
varying float vElevation;

uniform float uTime;
uniform vec2 ufrequency;
uniform float uWavesElevation;
uniform float uAnimat;

attribute float aRandom;



void main()
{
    // gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    vec4 modelPosition = modelMatrix * vec4(position, 1.0);
    
    float elevation = sin(modelPosition.x * ufrequency.x + uTime) * 0.1;
    elevation += step(0.9,  max(sin(modelPosition.x * ufrequency.x + uTime) - 0.25, 0.2));

    modelPosition.z += elevation * uAnimat;
    // modelPosition.y += 0.5;
    //modelPosition.y += uTime;
      modelPosition.z += aRandom * 0.5 * uWavesElevation;
    // modelPosition.y += 1.0;
            
    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition   ;
    
    gl_Position = projectedPosition;
    //  gl_Position = projectionMatrix * viewMatrix * modelViewMatrix * vec4(position, 1.0);
    
    // vRandom = aRandom;
    vUv = uv;
    vElevation = elevation;
}