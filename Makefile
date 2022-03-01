# Directory configuration
BUILD_DIR = build
PRESENTATION_DIR = presentation
IMAGES_DIR = images
DIAGRAMS_DIR = diagrams

# Directory path combining
PRESENTATION_BUILD_DIR = $(BUILD_DIR)/$(PRESENTATION_DIR)
IMAGES_BUILD_DIR = $(BUILD_DIR)/$(IMAGES_DIR)
DIAGRAMS_BUILD_DIR = $(BUILD_DIR)/$(DIAGRAMS_DIR)

# TEX sources
TEX_SRCS := $(wildcard */*.sty)

# Diagrams
# DIAGRAMS_PDF = $(DIAGRAMS_BUILD_DIR)/sa_tilt.pdf $(DIAGRAMS_BUILD_DIR)/sa_thruster.pdf $(DIAGRAMS_BUILD_DIR)/ros2_control.pdf $(DIAGRAMS_BUILD_DIR)/architecture_logicielle.pdf

# Video
VIDEOS_MP4 = $(PRESENTATION_BUILD_DIR)/sphere.mp4

# Directory guard
dir_guard = @mkdir -p $(@D)

# All recipe
all: presentation

# Diagrams recipe
# diagrams: $(DIAGRAMS_PDF)

# $(DIAGRAMS_PDF): $(DIAGRAMS_BUILD_DIR)/%.pdf : $(DIAGRAMS_DIR)/%.drawio
# 	$(dir_guard)
# 	drawio -x -f pdf --crop -o $@ $<

videos: $(VIDEOS_MP4)

$(VIDEOS_MP4): $(PRESENTATION_BUILD_DIR)/%.mp4 : $(IMAGES_DIR)/sphere/*.png
	$(dir_guard)
	ffmpeg -framerate 30 -pattern_type glob -i 'images/sphere/*.png' -c:v libx264 -pix_fmt yuv420p -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" $@

# Presentation
presentation: $(PRESENTATION_BUILD_DIR)/presentation.pdf

$(PRESENTATION_BUILD_DIR)/presentation.pdf: presentation.tex $(TEX_SRCS) videos
	$(dir_guard)
	latexmk -pdf -shell-escape -output-directory=$(PRESENTATION_BUILD_DIR) $<

# Clean recipe
clean:
	rm -rf $(BUILD_DIR)