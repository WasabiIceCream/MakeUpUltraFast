#include "/lib/config.glsl"

/* Color utils */

#ifdef THE_END
    #include "/lib/color_utils_end.glsl"
#elif defined NETHER
    #include "/lib/color_utils_nether.glsl"
#else
    #include "/lib/color_utils.glsl"
#endif

/* Ins / Outs */

varying vec2 texcoord;
varying vec4 tintColor;
varying float sky_luma_correction;

#ifdef GAMEOVERSE_MOD_SKY
    varying float goTwinkle;
    uniform float frameTimeCounter;
#endif

#if AA_TYPE > 0
    #include "/src/taa_offset.glsl"
#endif

/* Utility functions */

#include "/lib/luma.glsl"

// MAIN FUNCTION ------------------

void main() {
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    tintColor = gl_Color;

    #ifdef GAMEOVERSE_MOD_SKY
        // Cosmos twinkles its stars in its own vertex shader, which a shader pack replaces.
        // Same maths (per-vertex seed, speed 1.0 to 3.0), on real time.
        float goSeed = fract(sin(dot(gl_Vertex.xy, vec2(12.9898, 78.233))) * 43758.5453);
        goTwinkle = 0.5 + 0.5 * sin(frameTimeCounter * mix(1.0, 3.0, goSeed));
        if (gl_Color.rgb == vec3(1.0)) goTwinkle = 2.0;  // Cosmos: pure white stars hold steady
    #endif

    sky_luma_correction = luma(dayBlend(LIGHT_SUNSET_COLOR, LIGHT_DAY_COLOR, LIGHT_NIGHT_COLOR));

    #if defined UNKNOWN_DIM
        sky_luma_correction = 1.0;
    #else
        #if (VOL_LIGHT == 1 && !defined NETHER) || (VOL_LIGHT == 2 && defined SHADOW_CASTING && !defined NETHER)
            sky_luma_correction = 3.5 / ((sky_luma_correction * -2.5) + 3.5);
        #else
            sky_luma_correction = 1.5 / ((sky_luma_correction * -2.5) + 3.5);
        #endif
    #endif

    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;

    #if AA_TYPE > 0
        gl_Position.xy += taaOffset * gl_Position.w;
    #endif
}
