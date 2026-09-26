# MakeUp Ultra Fast (Gameoverse fork)

Upstream: `github.com/javiergcim/MakeUpUltraFast` (LGPL-3.0), released on Modrinth as
`makeup-ultra-fast-shaders`. `origin` fetches upstream; its push URL is deliberately invalid.
Branch `gameoverse`, based on upstream `e0c2e06` ("Version 9.5e"), which is identical file
for file to the 9.5e zip we shipped before this fork.

## Change

Spyglass Astronomy's stars are drawn by Cosmos, which `gameoverse-sky-sync` registers with
Iris as `SKY_TEXTURED`, so MakeUp draws them in `gbuffers_skytextured` alongside the sun and
moon. There they showed as bright squares: the 3x3 star sprite's faint edge texels, times
MakeUp's night `sky_luma_correction` boost, under Cosmos's additive blend (`SRC_ALPHA ONE`).

`common/skytextured_fragment.glsl`: for anything that isn't `MC_RENDER_STAGE_SUN`/`MOON`
(mod pipelines never change `renderStage`), square the sprite alpha, skip the luma boost and
scale by `GO_MOD_SKY_BRIGHTNESS`. `common/skytextured_vertex.glsl`: Cosmos's twinkle (its own
vertex shader is replaced by the pack), on `frameTimeCounter`. `lib/config.glsl`: the
`GAMEOVERSE_MOD_SKY` switch and the brightness option, shown as "Spyglass Stars Brightness"
on the Compatibility screen. Same approach as `../eclipse-shader-gameoverse`.

## Build

    ./build.sh   # MakeUp-UltraFast-9.5e.zip, same layout and name as the release zip

Copy it to `fabric 26.1/automodpack/host-modpack/main/shaderpacks/`. Keeping the release file
name keeps players' selected pack and saved settings.

## Updating

`scripts/check_mod_updates.py` reports a new Modrinth release under "Upstream watch".
Then: `git fetch origin`, find the commit named after the release on `origin/master`, rebase
`gameoverse` onto it, rename the zip in `build.sh` if the version changed (and the settings
`.txt` in host-modpack with it), rebuild, check the night sky in game.
