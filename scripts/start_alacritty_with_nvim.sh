#!/bin/bash

alacritty -e nvim --server /tmp/godot.pipe --remote $1 
