#!/bin/sh
# Builds MakeUp-UltraFast-9.6.zip with the same layout as the upstream zip (files at the root).
set -e
cd "$(dirname "$0")"
rm -f MakeUp-UltraFast-9.6.zip
zip -qr MakeUp-UltraFast-9.6.zip Credits ForDevelopers.EN.md helpful.txt LICENSE ParaDesarrolladores.ES.md README.md shaders
echo "wrote MakeUp-UltraFast-9.6.zip"
