import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
import * as dat from 'lil-gui'
import testVertexShader from './shaders/test/vertex.glsl'
import testFragmentShader from './shaders/test/fragment.glsl'
import { FontLoader } from 'three/examples/jsm/loaders/FontLoader.js'
import { TextGeometry } from 'three/examples/jsm/geometries/TextGeometry.js'
import  gsap from 'gsap'
/**
 * Base
 */
// Debug
const gui = new dat.GUI()
const debugObject = {}

// Colors
debugObject.blackColor = '#000'
debugObject.uvColor = '#887AC3'



// Canvas
const canvas = document.querySelector('canvas.webgl')

// Scene
const scene = new THREE.Scene()





//-------------------------------------

// Material
const material = new THREE.ShaderMaterial({
    vertexShader: testVertexShader,
    fragmentShader: testFragmentShader,
    side: THREE.DoubleSide,
    uniforms:
    {
        ufrequency: { value: new THREE.Vector2(10, 5)},// { value: 20},
        uTime : { value: 0},
        blackColor: { value: new THREE.Color(debugObject.blackColor) },
        uvColor: { value: new THREE.Color(debugObject.uvColor) },
        uWavesElevation: { value: 0.0 },
        uAnimat: { value: 1.0 },


    }
})
let mesh;
function addMesh(geometry) {
    const count = geometry.attributes.position.count
    const randoms = new Float32Array(count)
    
    for(let i = 0; i < count; i++)
    {
        randoms[i] = Math.random()
    }
    geometry.setAttribute('aRandom', new THREE.BufferAttribute(randoms, 1))
    
    mesh = new THREE.Mesh(geometry, material)

    scene.add(mesh);
}
function createDebugUI() {
    const guiControls = new function () {
    this.currentShapeType = "Plane";
    }();
function updateMesh() {
    scene.remove(mesh);

    switch (guiControls.currentShapeType) {
    case "Plane":
        addMesh(new THREE.PlaneGeometry(2, 2, 32, 32));
        break;
    case "Box":
        addMesh(new THREE.BoxGeometry());
        break;    
    case "Cylinder":
        addMesh(new THREE.CylinderGeometry());
        break;
    case "Circle":
        addMesh(new THREE.CircleGeometry()); 
        break;
    case "Sphere":
        addMesh(new THREE.SphereGeometry()); 
        break;  
    case "Torus":
        addMesh(new THREE.TorusGeometry()); 
        break;         
    }
}

//debug
    gui.add(guiControls, "currentShapeType", ["Plane", "Box", "Cylinder", "Circle", "Sphere", "Torus"])
    .name("Shape Type")
    .onChange(() => {
        updateMesh();
    });
}

gui.addColor(debugObject, 'blackColor').onChange(() => {
    material.uniforms.blackColor.value.set(debugObject.blackColor)
    })
gui.addColor(debugObject, 'uvColor').onChange(() => {
    material.uniforms.uvColor.value.set(debugObject.uvColor) 
    })

gui.add(material.uniforms.ufrequency.value, 'x').min(0).max(20).step(0.01).name('frequencyX')
gui.add(material.uniforms.ufrequency.value, 'y').min(0).max(20).step(0.01).name('frequencyY')
gui.add(material.uniforms.uWavesElevation, 'value').min(0).max(1).step(0.001).name('WavesElevation')
gui.add(material.uniforms.uAnimat, 'value').min(0).max(1).step(1).name('Animat')

//--------------------------------------
/**
 * Sizes
 */
const sizes = {
    width: window.innerWidth,
    height: window.innerHeight
}

window.addEventListener('resize', () =>
{
    // Update sizes
    sizes.width = window.innerWidth
    sizes.height = window.innerHeight

    // Update camera
    camera.aspect = sizes.width / sizes.height
    camera.updateProjectionMatrix()

    // Update renderer
    renderer.setSize(sizes.width, sizes.height)
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
})

/**
 * Camera
 */
// Base camera
const camera = new THREE.PerspectiveCamera(75, sizes.width / sizes.height, 0.1, 100)
camera.position.set(0.25, - 0.25, 5)
scene.add(camera)

// Controls
const controls = new OrbitControls(camera, canvas)
controls.enableDamping = true

/**
 * Renderer
 */
const renderer = new THREE.WebGLRenderer({
    canvas: canvas
})
renderer.setSize(sizes.width, sizes.height)
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
//...
/**
 * Textures
 */
const textureLoader = new THREE.TextureLoader()
const matcapTexture = textureLoader.load('textures/matcaps/2.png')
/**
 * Fonts
 */

const fontLoader = new FontLoader()

fontLoader.load(
    '/fonts/helvetiker_regular.typeface.json',
    (font) =>
    {
        // Material
        const material = new THREE.MeshMatcapMaterial({ color: '0xe9c512', matcap: matcapTexture})//matcap: matcapTexture })

        // Text
        const textGeometry = new TextGeometry(

            'Pattern ',
            {
                font: font,
                size: 0.4,
                height: 0.2,
                curveSegments: 12,
                bevelEnabled: true,
                bevelThickness: 0.03,
                bevelSize: 0.001,
                bevelOffset: 0,
                bevelSegments: 0
            }
        )
        textGeometry.center()

        const text = new THREE.Mesh(textGeometry, material)
        text.position.set(0, 1.5,0)
        scene.add(text)
    })

        // Counter
fontLoader.load('fonts/helvetiker_regular.typeface.json', function(font) {
    const material = new THREE.MeshMatcapMaterial({ color: '0x66699E'})//matcap: matcapTexture })
    function createTextMesh(text) {
        const textGeometry = new TextGeometry(text, {
            font: font,
            size: 0.4,
            height: 0.2,
            curveSegments: 12,
            bevelEnabled: true,
            bevelThickness: 0.03,
            bevelSize: 0.001,
            bevelOffset: 0,
            bevelSegments: 0
        });
        const textMesh = new THREE.Mesh(textGeometry, material);
        textMesh.position.set(1, 1.2,0)

        scene.add(textMesh);
        return textMesh;
    }

    let textMesh = createTextMesh('1');
    
    // count
    let count = 1;
    setInterval(function() {
        if (count >= 50) {
            count = 1;
            scene.remove(textMesh);
            textMesh = createTextMesh(count.toString());
        } else {
            count++;
            scene.remove(textMesh);
            textMesh = createTextMesh(count.toString());
        }
    }, 1010); 
});
/**
 * Animate
 */
const clock = new THREE.Clock()
addMesh(new THREE.PlaneGeometry(2, 2, 32, 32));
createDebugUI();

const tick = () =>
{
    const elapsedTime = clock.getElapsedTime()
    
    //update Material
    material.uniforms.uTime.value = elapsedTime 
    // const time = performance.now() / 1500;
    // material.uniforms.uTime.value = time;
    
    // Update controls
    controls.update()

    // Render
    renderer.render(scene, camera)

    // Call tick again on the next frame
    window.requestAnimationFrame(tick)
}

tick()