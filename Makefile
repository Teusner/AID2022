.ONESHELL:
SHELL=/bin/bash

# Directory configuration
BUILD_DIR = build
PRESENTATION_DIR = presentation
IMAGES_DIR = images
DIAGRAMS_DIR = diagrams
SCRIPT_DIR = scripts

# Directory path combining
PRESENTATION_BUILD_DIR = $(BUILD_DIR)/$(PRESENTATION_DIR)
IMAGES_BUILD_DIR = $(BUILD_DIR)/$(IMAGES_DIR)

# TEX sources
TEX_SRCS := $(wildcard */*.sty)

# Video
VIDEOS_MP4 = $(PRESENTATION_BUILD_DIR)/sphere.mp4

# Images PDF
IMAGES_PDF = $(IMAGES_BUILD_DIR)/reciprocity_forward.pdf $(IMAGES_BUILD_DIR)/reciprocity_backward.pdf
CONDA_ACTIVATE=source $$(conda info --base)/etc/profile.d/conda.sh ; conda activate ; conda activate

# Directory guard
dir_guard = @mkdir -p $(@D)

# All recipe
all: presentation

# Images recipe
images : $(IMAGES_PDF)

$(IMAGES_PDF): $(IMAGES_BUILD_DIR)/%.pdf : $(SCRIPT_DIR)/%.py
	$(dir_guard)
	$(CONDA_ACTIVATE) proteus ; python3 $< $@

# Video recipe
videos: $(VIDEOS_MP4)

$(VIDEOS_MP4): $(PRESENTATION_BUILD_DIR)/%.mp4 : $(IMAGES_DIR)/sphere/*.png
	$(dir_guard)
	ffmpeg -framerate 30 -pattern_type glob -i 'images/sphere/*.png' -c:v libx264 -pix_fmt yuv420p -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" $@

# Presentation
presentation: $(PRESENTATION_BUILD_DIR)/presentation.pdf

$(PRESENTATION_BUILD_DIR)/presentation.pdf: presentation.tex $(TEX_SRCS) images videos
	$(dir_guard)
	latexmk -pdf -shell-escape -output-directory=$(PRESENTATION_BUILD_DIR) $<

# Clean recipe
clean:
	rm -rf $(BUILD_DIR)