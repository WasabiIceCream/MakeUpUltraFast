#include "/lib/config.glsl"

/* Color utils */

#ifdef THE_END
    #include "/lib/color_utils_end.glsl"
#elif defined NETHER
    #include "/lib/color_utils_nether.glsl"
#else
    #include "/lib/color_utils.glsl"
#endif

/* Uniforms */

uniform sampler2D tex;

#ifdef NETHER
    uniform vec3 fogColor;
#endif

/* Ins / Outs */

varying vec2 texcoord;
varying vec4 tintColor;
varying float sky_luma_correction;  // Flat

#ifdef GAMEOVERSE_MOD_SKY
    varying float goTwinkle;
    uniform int renderStage;
#endif

// MAIN FUNCTION ------------------

void main() {
    #if defined THE_END
        #if MC_VERSION >= 12109
            vec4 blockColor = vec4(ZENITH_DAY_COLOR, 0.0);  // End Flashes Fix
        #else
            vec4 blockColor = vec4(ZENITH_DAY_COLOR, 1.0);
        #endif
    #elif defined NETHER  // Unused
        vec4 background_color_full = vec4(mix(fogColor * 0.1, vec3(1.0), 0.04), 1.0);
        vec3 background_color = background_color_full.rgb;
        vec4 blockColor = vec4(background_color, 1.0);
    #else
        // Toma el color puro del bloque
        vec4 blockColor = texture2D(tex, texcoord) * tintColor;

        #ifdef GAMEOVERSE_MOD_SKY
            // Mod pipelines never change renderStage, so anything that isn't the sun or moon
            // here is a mod sky object (Cosmos stars; additive blend, SRC_ALPHA ONE). Squaring
            // the 3x3 sprite's alpha drops its faint edges, and the night luma boost is skipped:
            // together they turned every star into a bright square.
            if (renderStage != MC_RENDER_STAGE_SUN && renderStage != MC_RENDER_STAGE_MOON) {
                vec4 sprite = texture2D(tex, texcoord);
                blockColor = vec4(sprite.rgb * tintColor.rgb * goTwinkle * GO_MOD_SKY_BRIGHTNESS,
                                  sprite.a * sprite.a * tintColor.a);
            } else {
                blockColor.rgb *= sky_luma_correction;
            }
        #else
            blockColor.rgb *= sky_luma_correction;
        #endif
    #endif

    #include "/src/writebuffers.glsl"
}
