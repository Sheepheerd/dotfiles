#!/bin/bash
# Detect the system type (you can modify this condition based on your specific requirements)
if [[ "$(hostname)" == "deathstar" ]]; then
    export LIBVA_DRIVER_NAME=nvidia
    export GBM_BACKEND=nvidia-drm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia

elif [[ "$(hostname)" == "novastar" ]]; then
    export GDK_BACKEND=wayland
fi

