# example makefile to build imgui and wrapper files into
# a static library
IMGUI_SRCS=$(shell find imgui/ -maxdepth 2 -name '*.cpp')
IMGUI_OBJS=$(IMGUI_SRCS:.cpp=.o)

all: libimgui.a

libimgui.a: CXXFLAGS += -I imgui/imgui/ -O2
libimgui.a: $(IMGUI_OBJS)
	ar rs $@ $^

