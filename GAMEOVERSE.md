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

`common/skytextured_fragment.glsl`: for mod stars, take the sprite alpha to the 4th power
(squared still left a visible cross), skip the luma boost and scale by `GO_MOD_SKY_BRIGHTNESS`
(default 0.15). Mod pipelines never change `renderStage`, and Cosmos draws right after the
moon, so its stars arrive tagged `MOON` (found with a colour-coded build: red/green/blue per
branch). The vertex shader tells them apart by geometry instead: Cosmos stars sit on a
100-block sphere (corners under 100.5 from the origin), the sun and moon quads well beyond.

`common/skytextured_vertex.glsl`: Cosmos's twinkle (its own vertex shader is replaced by
the pack), on `frameTimeCounter`, and that radius test. `lib/config.glsl`: the
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
