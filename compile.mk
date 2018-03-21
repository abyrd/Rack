ifndef RACK_DIR
$(error RACK_DIR is not defined)
endif

ifndef VERSION
$(error VERSION is not defined)
endif

include $(RACK_DIR)/arch.mk

FLAGS += -DVERSION=$(VERSION)
# Generate dependency files alongside the object files
FLAGS += -MMD -MP
FLAGS += -g
# Optimization
FLAGS += -O3 -march=nocona -ffast-math -fno-finite-math-only
FLAGS += -Wall -Wextra -Wno-unused-parameter

ifneq ($(ARCH), mac)
	CXXFLAGS += -Wsuggest-override
endif
CXXFLAGS += -std=c++11


ifeq ($(ARCH), lin)
	FLAGS += -DARCH_LIN
endif
ifeq ($(ARCH), mac)
	FLAGS += -DARCH_MAC
	CXXFLAGS += -stdlib=libc++
	LDFLAGS += -stdlib=libc++
	MAC_SDK_FLAGS = -mmacosx-version-min=10.7
	FLAGS += $(MAC_SDK_FLAGS)
	LDFLAGS += $(MAC_SDK_FLAGS)
endif
ifeq ($(ARCH), win)
	FLAGS += -DARCH_WIN
	FLAGS += -D_USE_MATH_DEFINES
endif

CFLAGS += $(FLAGS)
CXXFLAGS += $(FLAGS)


# Derive object files from sources and place them before user-defined objects
SOURCE_OBJECTS := $(patsubst %, build/%.o, $(SOURCES))
DEPS := $(patsubst %, build/%.d, $(SOURCES))


# Final targets

$(TARGET): $(RESOURCES) $(OBJECTS) $(SOURCE_OBJECTS)
	$(CXX) -o $@ $(SOURCE_OBJECTS) $(OBJECTS) $(LDFLAGS)

-include $(DEPS)

build/%.c.o: %.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c -o $@ $<

build/%.cpp.o: %.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

build/%.cc.o: %.cc
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

build/%.m.o: %.m
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c -o $@ $<
