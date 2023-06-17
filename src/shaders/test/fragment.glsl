#define PI 3.1415926535897932384626433832795

varying vec2 vUv;
varying float vElevation;
varying float vRandom;

float random(vec2 st)
{
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

vec2 rotate(vec2 uv, float rotation, vec2 mid)
{
    return vec2(
      cos(rotation) * (uv.x - mid.x) + sin(rotation) * (uv.y - mid.y) + mid.x,
      cos(rotation) * (uv.y - mid.y) - sin(rotation) * (uv.x - mid.x) + mid.y
    );
}

//	Classic Perlin 2D Noise 
//	by Stefan Gustavson
//
vec2 fade(vec2 t)
{
    return t*t*t*(t*(t*6.0-15.0)+10.0);
}

vec4 permute(vec4 x)
{
    return mod(((x*34.0)+1.0)*x, 289.0);
}

float cnoise(vec2 P)
{
    vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
    vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
    Pi = mod(Pi, 289.0); // To avoid truncation effects in permutation
    vec4 ix = Pi.xzxz;
    vec4 iy = Pi.yyww;
    vec4 fx = Pf.xzxz;
    vec4 fy = Pf.yyww;
    vec4 i = permute(permute(ix) + iy);
    vec4 gx = 2.0 * fract(i * 0.0243902439) - 1.0; // 1/41 = 0.024...
    vec4 gy = abs(gx) - 0.5;
    vec4 tx = floor(gx + 0.5);
    gx = gx - tx;
    vec2 g00 = vec2(gx.x,gy.x);
    vec2 g10 = vec2(gx.y,gy.y);
    vec2 g01 = vec2(gx.z,gy.z);
    vec2 g11 = vec2(gx.w,gy.w);
    vec4 norm = 1.79284291400159 - 0.85373472095314 * vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11));
    g00 *= norm.x;
    g01 *= norm.y;
    g10 *= norm.z;
    g11 *= norm.w;
    float n00 = dot(g00, vec2(fx.x, fy.x));
    float n10 = dot(g10, vec2(fx.y, fy.y));
    float n01 = dot(g01, vec2(fx.z, fy.z));
    float n11 = dot(g11, vec2(fx.w, fy.w));
    vec2 fade_xy = fade(Pf.xy);
    vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
    float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
    return 2.3 * n_xy;
}


float getPatternIndex(float time) {
    float patternCount = 50.0;
    float patternDuration = 1.0;
    float patternIndex = mod(time, patternCount * patternDuration);
    return floor(patternIndex / patternDuration);
}
uniform float uTime;
uniform vec3 blackColor;
uniform vec3 uvColor;


void main()
{
    //pattern1 
    //gl_FragColor = vec4(vUv.x,vUv.y, 1.0, 1.0);

    //pattern2 used in game
    //gl_FragColor = vec4(vUv, 0.0, 1.0);


float time = uTime;
    float patternIndex = getPatternIndex(time);
    float strength = 0.0;
    float barX = 0.0;
    float barY =0.0;
    float lightX = 0.0;
    float lightY = 0.0; 
    float angle = 0.0;
    if (patternIndex == 0.0) {
        //Pattern 3
        strength = vUv.x ;
    } else if (patternIndex == 1.0) {
        //Pattern 4
        strength = vUv.y ; 
    } else if (patternIndex == 2.0) {
        //Pattern 5
        strength = 1.0 - vUv.y ;
    } else if (patternIndex == 3.0) {
        //Pattern 6
        strength =  vUv.y * 10.0 ;
    } else if (patternIndex == 4.0) {
        //Pattern 7
        strength = mod(vUv.y * 10.0, 1.0); //sin(vUv.y * 10.0) ;
    } else if (patternIndex == 5.0) {
        //Pattern 8
         strength = mod(vUv.y * 10.0, 1.0); 
        strength = strength < 0.5 ? 0.0 : 1.0;
        //or anther sloution 
        // strength = step(0.5, strength);//as if cond...
    }else if (patternIndex == 6.0) {
        //Pattern 9
        strength = mod(vUv.y * 10.0, 1.0); 
        strength = step(0.8, strength);
    }else if (patternIndex == 7.0) {
        //Pattern 10
        strength = mod(vUv.x * 10.0, 1.0); 
        strength = step(0.8, strength);
        
    }else if (patternIndex == 8.0) {
        //Pattern 11
        strength = step(0.8, mod(vUv.x * 10.0, 1.0));
        strength += step(0.8, mod(vUv.y * 10.0, 1.0));

    }else if (patternIndex == 9.0) {
        //Pattern 12
        strength = step(0.8, mod(vUv.x * 10.0, 1.0));
        strength *= step(0.8, mod(vUv.y * 10.0, 1.0));

    }else if (patternIndex == 10.0) {
        //Pattern 13
        strength = step(0.8, mod(vUv.y * 10.0, 1.0)) ;

    }else if (patternIndex == 11.0) {
        //Pattern 14
        barX = step(0.8, mod(vUv.y * 10.0, 1.0)) ;
        barX *= step(0.4, mod(vUv.x * 10.0, 1.0)) ;
        barY = step(0.4, mod(vUv.y * 10.0, 1.0)) ;
        barY *= step(0.8, mod(vUv.x * 10.0, 1.0)) ;
        strength = barX + barY ;
    }
    else if (patternIndex == 12.0) {
        //Pattern 15
        barX = step(0.4, mod(vUv.x * 10.0, 1.0)) ;
        barX *= step(0.8, mod(vUv.y * 10.0 + 0.2, 1.0)) ;
        barY = step(0.8, mod(vUv.x * 10.0 + 0.2, 1.0)) ;
        barY *= step(0.4, mod(vUv.y * 10.0, 1.0)) ;
        strength = barX + barY ;

    }
    else if (patternIndex == 13.0) {
        //Pattern 16
        strength = abs(vUv.x - 0.5);// pattern i did => (vUv.x - 0.5 ) / (vUv.y - 0.5) ;

    }else if (patternIndex == 14.0) {
        //Pattern 17
        strength = min(abs(vUv.x - 0.5), abs(vUv.y - 0.5));

    }else if (patternIndex == 15.0) {
        //Pattern 18
        strength = max(abs(vUv.x - 0.5), abs(vUv.y - 0.5));

    }else if (patternIndex == 16.0) {
        //Pattern 19
        strength = step(0.2, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));

    }else if (patternIndex == 17.0) {
        //Pattern 20
        float square1 = step(0.2, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));
        float square2 = 1.0 - step(0.25, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));
        strength = square2 * square1;

    }else if (patternIndex == 18.0) {
        //Pattern 21
        strength = floor(vUv.x * 10.0) / 10.0;

    }else if (patternIndex == 19.0) {
        //Pattern 22
        strength = floor(vUv.x * 10.0) / 10.0;
        strength *= floor(vUv.y * 10.0) / 10.0;

    }else if (patternIndex == 20.0) {
        //Pattern 23
        strength = random(vUv) ;

    }else if (patternIndex == 21.0) {
        //Pattern 24
        vec2 gridUv = vec2(
            floor(vUv.x * 10.0) / 10.0,
            floor(vUv.y * 10.0) / 10.0
        );
        strength = random(gridUv) ; 

    }else if (patternIndex == 22.0) {
        //Pattern 25
        vec2 gridUv = vec2(
            floor(vUv.x * 10.0) / 10.0,
            floor((vUv.y + vUv.x * 0.5) * 10.0) / 10.0
        );
        strength = random(gridUv) ; 

    }else if (patternIndex == 23.0) {
        //Pattern 26
        strength = length(vUv) ; 

    }
    else if (patternIndex == 24.0) {
        //Pattern 27
        strength = distance(vUv, vec2(0.5)) ; 

    }
    else if (patternIndex == 25.0) {
        //Pattern 28
        strength = 1.0 - distance(vUv, vec2(0.5)) ;

    }else if (patternIndex == 26.0) {
        //Pattern 29
        strength = 0.015 / distance(vUv, vec2(0.5)) ;

    }
    else if (patternIndex == 27.0) {
        //Pattern 30
        vec2 lightUv = vec2(
            vUv.x * 0.1 + 0.45,
            vUv.y * 0.5 + 0.25
        );
        strength = 0.015 / distance(lightUv, vec2(0.5)) ; 

    }else if (patternIndex == 28.0) {
        //Pattern 31
        vec2 lightUvX = vec2(vUv.x * 0.1 + 0.45,vUv.y * 0.5 + 0.25);
        lightX = 0.015 / distance(lightUvX, vec2(0.5)) ; 
        vec2 lightUvY = vec2(vUv.y * 0.1 + 0.45,vUv.x * 0.5 + 0.25);
        lightY = 0.015 / distance(lightUvY, vec2(0.5)) ; 
        strength = lightX * lightY ;

    }else if (patternIndex == 29.0) {
        //Pattern 32
        vec2 rotatedUv = rotate(vUv, PI * 0.25, vec2(0.5));
        vec2 lightUvX = vec2(rotatedUv.x * 0.1 + 0.45,rotatedUv.y * 0.5 + 0.25);
        lightX = 0.015 / distance(lightUvX, vec2(0.5)) ; 
        vec2 lightUvY = vec2(rotatedUv.y * 0.1 + 0.45,rotatedUv.x * 0.5 + 0.25);
        lightY = 0.015 / distance(lightUvY, vec2(0.5)) ; 
        strength = lightX * lightY ;

    }else if (patternIndex == 30.0) {
        //Pattern 33
        strength = step(0.25, distance(vUv, vec2(0.5)));

    }else if (patternIndex == 31.0) {
        //Pattern 34
        strength = abs(distance(vUv, vec2(0.5)) - 0.25);

    }else if (patternIndex == 32.0) {
        //Pattern 35
        strength = step(0.01, abs(distance(vUv, vec2(0.5)) - 0.25));

    }else if (patternIndex == 33.0) {
        //Pattern 36
        strength = 1.0 - step(0.01, abs(distance(vUv, vec2(0.5)) - 0.25));

    }else if (patternIndex == 34.0) {
        //Pattern 37
        vec2 wavedUv = vec2(
            vUv.x,
            vUv.y + sin(vUv.x * 30.0) * 0.1
        );
        strength = 1.0 - step(0.01, abs(distance(wavedUv, vec2(0.5)) - 0.25));

    }else if (patternIndex == 35.0) {
        //Pattern 38
        vec2 wavedUv = vec2(
            vUv.x + sin(vUv.y * 30.0) * 0.1,
            vUv.y + sin(vUv.x * 30.0) * 0.1
        );
        strength = 1.0 - step(0.01, abs(distance(wavedUv, vec2(0.5)) - 0.25));

    }else if (patternIndex == 36.0) {
        //Pattern 39
        vec2 wavedUv = vec2(
            vUv.x + sin(vUv.y * 100.0) * 0.1,
            vUv.y + sin(vUv.x * 100.0) * 0.1
        );
        strength = 1.0 - step(0.01, abs(distance(wavedUv, vec2(0.5)) - 0.25));

    }else if (patternIndex == 37.0) {
        //Pattern 40
        angle = atan(vUv.x, vUv.y);
        strength = angle;

    }else if (patternIndex == 38.0) {
        //Pattern 41
        angle = atan(vUv.x - 0.5, vUv.y - 0.5);
        strength = angle;

    }else if (patternIndex == 39.0) {
        //Pattern 42
        angle = atan(vUv.x - 0.5, vUv.y - 0.5);
        angle /= PI * 2.0;
        angle += 0.5;
        strength = angle;

    }else if (patternIndex == 40.0) {
        //Pattern 43
        angle = atan(vUv.x - 0.5, vUv.y - 0.5);
        angle /= PI * 2.0;
        angle += 0.5;
        angle *= 20.0; //100.0
        angle = mod(angle, 1.0);
        strength = angle;


    }else if (patternIndex == 41.0) {
        //Pattern 44
        angle = atan(vUv.x - 0.5, vUv.y - 0.5);
        angle /= PI * 2.0;
        angle += 0.5;
        strength = sin(angle * 100.0);

    }else if (patternIndex == 42.0) {
        //Pattern 45
        angle = atan(vUv.x - 0.5, vUv.y - 0.5);
        angle /= PI * 2.0;
        angle += 0.5;
        float sinusoid = sin(angle * 100.0);
        float radius = 0.25 + sinusoid * 0.02;
        strength = 1.0 - step(0.01, abs(distance(vUv, vec2(0.5)) - radius));

    }else if (patternIndex == 43.0) {
        //Pattern 46
        strength = cnoise(vUv * 10.0);

    }else if (patternIndex == 44.0) {
        //Pattern 47
        strength = step(0.0, cnoise(vUv * 10.0));

    }else if (patternIndex == 45.0) {
        //Pattern 48
        strength = abs( cnoise(vUv * 10.0));

    }else if (patternIndex == 46.0) {
        //Pattern 49
        strength = 1.0 - abs( cnoise(vUv * 10.0));

    }else if (patternIndex == 47.0) {
        //Pattern 50
        strength = sin( cnoise(vUv * 10.0) * 20.0);

    }else if (patternIndex == 48.0) {
        //Pattern 51
        strength = step(0.8, mod(vUv.y * 10.0, 1.0)) ;

    }else if (patternIndex == 49.0) {
        //Pattern 52
        strength = step(0.5, sin( cnoise(vUv * 10.0) * 20.0) );

    }
    //Clamp the strength
    strength = clamp(strength, 0.0, 1.0);  

    //Colored version
    // vec3 blackColor1 = vec3(0.0);
    vec3 uvColor1 = vec3(vUv ,1.0);
    vec3 mixedColor =   mix(blackColor , uvColor1  , strength);
      //vec3 mixedColor += vElevation * 1.5 ;
    gl_FragColor = vec4( mixedColor, 1.0);

    //black and white color
    //gl_FragColor = vec4(strength, strength, strength, 1.0);
}
