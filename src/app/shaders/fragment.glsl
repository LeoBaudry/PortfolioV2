uniform sampler2D uTexture;
varying vec2 vUv;
uniform vec2 uResolution;
uniform float uProgress;
uniform vec2 uContainerRes;

// Fonction pour l'amorti Ease-In-Out
float easeInOutCubic(float t) {
    return t < 0.5 ? 4.0 * t * t * t : 1.0 - pow(-2.0 * t + 2.0, 3.0) / 2.0;
}

void main() {
    // Gestion du ratio (Cover)
    float imageAspect = uResolution.x / uResolution.y;
    float containerAspect = uContainerRes.x / uContainerRes.y;
    vec2 ratio = vec2(
        min(containerAspect / imageAspect, 1.0),
        min(1.0 / (containerAspect / imageAspect), 1.0)
    );
    vec2 uv = vUv * ratio + (1.0 - ratio) * 0.5;

    // Transformation du progrès linéaire en courbe Ease-In-Out
    float easedProgress = easeInOutCubic(uProgress);
    
    // Calcul du seuil basé sur la valeur amortie
    float threshold = 1.0 - easedProgress;

    // Ligne horizontale nette
    float reveal = step(threshold, vUv.y);
    vec4 tex = texture2D(uTexture, uv);

    // Mélange final avec du blanc pur
    gl_FragColor = mix(vec4(1.0, 1.0, 1.0, 1.0), tex, reveal);
}