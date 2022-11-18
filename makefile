#
# Definitions
#
# Force bash to make life easier
SHELL := /bin/bash
BIN_NAME := $(notdir $(shell pwd))
CCS_LIB_NAME := Adafruit_CCS811
CCS_LIB_VER := 1.1.1
CCS_LIB_URL := https://github.com/adafruit/Adafruit_CCS811/archive/refs/tags/1.1.1.tar.gz
BUS_LIB_NAME := Adafruit_BusIO
BUS_LIB_VER := 1.14.1
BUS_LIB_URL := https://github.com/adafruit/Adafruit_BusIO/archive/refs/tags/1.14.1.tar.gz

#
# Directories
#
# Test framework to make sure all our assumptions are correct before we start.
# Add all variables pointing to required files or directories to the following
# variable.
define TEST_FOR_EXISTENCE
$(if $(wildcard $($($(1)))),,$(error $($(1)) ($($($(1)))) does not exist))
endef

# HOME should be defined by your shell
ARDUINO_HOME_DIR := $(HOME)/.arduino15
PKG_ARDUINO_DIR := $(ARDUINO_HOME_DIR)/packages/arduino
HW_AVR_DIR := $(PKG_ARDUINO_DIR)/hardware/avr/1.8.6
HW_CORE_DIR := $(HW_AVR_DIR)/cores/arduino
HW_LIB_WIRE_DIR := $(HW_AVR_DIR)/libraries/Wire/src
HW_LIB_SPI_DIR := $(HW_AVR_DIR)/libraries/SPI/src
TOOL_GCC_DIR := $(PKG_ARDUINO_DIR)/tools/avr-gcc/7.3.0-atmel3.6.1-arduino7
TOOL_AVR_DIR := $(PKG_ARDUINO_DIR)/tools/avrdude/6.3.0-arduino17/

SRC_DIR := src
EXTRA_SRC_DIR := $(SRC_DIR)/third-party
CCS_SRC_DIR := $(EXTRA_SRC_DIR)/$(CCS_LIB_NAME)-$(CCS_LIB_VER)
BUS_SRC_DIR := $(EXTRA_SRC_DIR)/$(BUS_LIB_NAME)-$(BUS_LIB_VER)
BUILD_DIR := build
OBJ_DIR := $(BUILD_DIR)/obj
EXTRA_OBJ_DIR := $(OBJ_DIR)/third-party
CCS_OBJ_DIR := $(EXTRA_OBJ_DIR)/$(CCS_LIB_NAME)-$(CCS_LIB_VER)
BUS_OBJ_DIR := $(EXTRA_OBJ_DIR)/$(BUS_LIB_NAME)-$(BUS_LIB_VER)
HW_CORE_OBJ_DIR := $(EXTRA_OBJ_DIR)/arduino-core
HW_LIB_WIRE_OBJ_DIR := $(EXTRA_OBJ_DIR)/arduino-lib-wire
HW_LIB_SPI_OBJ_DIR := $(EXTRA_OBJ_DIR)/arduino-lib-spi
DEP_DIR := $(BUILD_DIR)/dep
EXTRA_DEP_DIR := $(DEP_DIR)/third-party
CCS_DEP_DIR := $(EXTRA_DEP_DIR)/$(CCS_LIB_NAME)-$(CCS_LIB_VER)
BUS_DEP_DIR := $(EXTRA_DEP_DIR)/$(BUS_LIB_NAME)-$(BUS_LIB_VER)
HW_CORE_DEP_DIR := $(EXTRA_DEP_DIR)/arduino-core
HW_LIB_WIRE_DEP_DIR := $(EXTRA_DEP_DIR)/arduino-lib-wire
HW_LIB_SPI_DEP_DIR := $(EXTRA_DEP_DIR)/arduino-lib-spi
BIN_DIR := $(BUILD_DIR)/bin

#
# Files
#
OUR_OBJ := $(OBJ_DIR)/$(BIN_NAME).cpp.o
CCS_OBJ := $(CCS_OBJ_DIR)/Adafruit_CCS811.cpp.o
BUS_OBJ := $(BUS_OBJ_DIR)/Adafruit_BusIO_Register.cpp.o \
	$(BUS_OBJ_DIR)/Adafruit_I2CDevice.cpp.o \
	$(BUS_OBJ_DIR)/Adafruit_SPIDevice.cpp.o
HW_WIRE_OBJ := $(HW_LIB_WIRE_OBJ_DIR)/Wire.cpp.o \
	$(HW_LIB_WIRE_OBJ_DIR)/twi.c.o
HW_SPI_OBJ := $(HW_LIB_SPI_OBJ_DIR)/SPI.cpp.o
HW_CORE_OBJ := $(HW_CORE_OBJ_DIR)/PluggableUSB.cpp.o \
	$(HW_CORE_OBJ_DIR)/HardwareSerial3.cpp.o \
	$(HW_CORE_OBJ_DIR)/HardwareSerial.cpp.o \
	$(HW_CORE_OBJ_DIR)/HardwareSerial1.cpp.o \
	$(HW_CORE_OBJ_DIR)/CDC.cpp.o \
	$(HW_CORE_OBJ_DIR)/HardwareSerial2.cpp.o \
	$(HW_CORE_OBJ_DIR)/IPAddress.cpp.o \
	$(HW_CORE_OBJ_DIR)/HardwareSerial0.cpp.o \
	$(HW_CORE_OBJ_DIR)/Print.cpp.o \
	$(HW_CORE_OBJ_DIR)/Stream.cpp.o \
	$(HW_CORE_OBJ_DIR)/Tone.cpp.o \
	$(HW_CORE_OBJ_DIR)/USBCore.cpp.o \
	$(HW_CORE_OBJ_DIR)/WMath.cpp.o \
	$(HW_CORE_OBJ_DIR)/WString.cpp.o \
	$(HW_CORE_OBJ_DIR)/abi.cpp.o \
	$(HW_CORE_OBJ_DIR)/new.cpp.o \
	$(HW_CORE_OBJ_DIR)/main.cpp.o \
	$(HW_CORE_OBJ_DIR)/hooks.c.o \
	$(HW_CORE_OBJ_DIR)/WInterrupts.c.o \
	$(HW_CORE_OBJ_DIR)/wiring.c.o \
	$(HW_CORE_OBJ_DIR)/wiring_analog.c.o \
	$(HW_CORE_OBJ_DIR)/wiring_digital.c.o \
	$(HW_CORE_OBJ_DIR)/wiring_pulse.c.o \
	$(HW_CORE_OBJ_DIR)/wiring_pulse.S.o \
	$(HW_CORE_OBJ_DIR)/wiring_shift.c.o

#
# Compiler Options
#
INCDIRS = -I$(HW_AVR_DIR)/cores/arduino \
	-I$(HW_AVR_DIR)/variants/eightanaloginputs \
	-I$(CCS_SRC_DIR) \
	-I$(BUS_SRC_DIR) \
	-I$(HW_AVR_DIR)/libraries/Wire/src \
	-I$(HW_AVR_DIR)/libraries/SPI/src
DEFINES := -DF_CPU=16000000L \
	-DARDUINO=10607 \
	-DARDUINO_AVR_NANO \
	-DARDUINO_ARCH_AVR
ASMFLAGS := -g \
	-x assembler-with-cpp \
	-flto \
	-mmcu=atmega328p
CFLAGS := -g \
	-Os \
	-Wall \
	-Wextra \
	-std=gnu11 \
	-ffunction-sections \
	-fdata-sections \
	-Wno-error=narrowing \
	-flto \
	-fno-fat-lto-objects \
	-mmcu=atmega328p \
	$(DEFINES)
CXXFLAGS := -g \
	-Os \
	-Wall \
	-Wextra \
	-std=gnu++11 \
	-fpermissive \
	-fno-exceptions \
	-ffunction-sections \
	-fdata-sections \
	-fno-threadsafe-statics \
	-Wno-error=narrowing \
	-flto \
	-mmcu=atmega328p \
	$(DEFINES)
LINKFLAGS := -g \
	-Os \
	-Wall \
	-Wextra \
	-flto \
	-fuse-linker-plugin \
	-Wl,--gc-sections \
	-mmcu=atmega328p


usage:
	@echo ""
	@echo "This makefile implements the following targets:"
	@echo ""
	@echo "- pull        pulls down and extracts third-party dependencies"
	@echo "- build       creates all libraries and binaries"
	@echo "- clean       removes all build artifacts"
	@echo "- full-clean  performs \"clean\" and removes extracted library code from src"
	@echo "- upload      pushes the binaries to the device"
	@echo ""

pull: test-variables
	mkdir -p $(BUILD_DIR)/tmp
	wget -O $(BUILD_DIR)/tmp/$(CCS_LIB_NAME)-$(CCS_LIB_VER).tar.gz $(CCS_LIB_URL)
	wget -O $(BUILD_DIR)/tmp/$(BUS_LIB_NAME)-$(BUS_LIB_VER).tar.gz $(BUS_LIB_URL)
	tar -xvf $(BUILD_DIR)/tmp/$(CCS_LIB_NAME)-$(CCS_LIB_VER).tar.gz
	tar -xvf $(BUILD_DIR)/tmp/$(BUS_LIB_NAME)-$(BUS_LIB_VER).tar.gz
	mv $(CCS_LIB_NAME)-$(CCS_LIB_VER) $(EXTRA_SRC_DIR)/
	mv $(BUS_LIB_NAME)-$(BUS_LIB_VER) $(EXTRA_SRC_DIR)/

build: test-variables $(OUR_OBJ) $(CCS_OBJ) $(BUS_OBJ) $(HW_WIRE_OBJ) $(HW_SPI_OBJ) $(HW_CORE_OBJ) board-archive link
	@echo ""
	@echo "Build successful"
	@echo ""

clean:
	rm -r $(BUILD_DIR)

full-clean: clean
	rm -r $(EXTRA_SRC_DIR)

upload:
	$(TOOL_AVR_DIR)/bin/avrdude -C$(TOOL_AVR_DIR)/etc/avrdude.conf -v -V -patmega328p -carduino "-P/dev/ttyUSB0" -b115200 -D "-Uflash:w:$(BIN_DIR)/$(BIN_NAME).hex:i"

setup: REQ_DIRS := $(EXTRA_SRC_DIR) $(CCS_SRC_DIR) $(BUS_SRC_DIR) $(BUILD_DIR) \
	$(OBJ_DIR) $(HW_CORE_OBJ_DIR) $(EXTRA_OBJ_DIR) $(CCS_OBJ_DIR) \
	$(BUS_OBJ_DIR) $(HW_LIB_WIRE_OBJ_DIR) $(HW_LIB_SPI_OBJ_DIR) $(DEP_DIR) \
	$(HW_CORE_DEP_DIR) $(EXTRA_DEP_DIR) $(CCS_DEP_DIR) $(BUS_DEP_DIR) \
	$(HW_LIB_WIRE_DEP_DIR) $(HW_LIB_SPI_DEP_DIR) $(BIN_DIR)
setup:
	$(foreach dir,$(REQ_DIRS),$(shell mkdir -p $(dir)))

test-variables: DIRS_UNDER_TEST := ARDUINO_HOME_DIR PKG_ARDUINO_DIR HW_AVR_DIR \
	TOOL_GCC_DIR TOOL_AVR_DIR HW_CORE_DIR HW_LIB_WIRE_DIR HW_LIB_SPI_DIR \
	SRC_DIR CCS_SRC_DIR BUS_SRC_DIR EXTRA_SRC_DIR BUILD_DIR OBJ_DIR \
	HW_CORE_OBJ_DIR EXTRA_OBJ_DIR CCS_OBJ_DIR BUS_OBJ_DIR HW_LIB_WIRE_OBJ_DIR \
	HW_LIB_SPI_OBJ_DIR DEP_DIR HW_CORE_DEP_DIR EXTRA_DEP_DIR CCS_DEP_DIR \
	BUS_DEP_DIR HW_LIB_WIRE_DEP_DIR HW_LIB_SPI_DEP_DIR BIN_DIR
test-variables: setup
	$(foreach fut,$(DIRS_UNDER_TEST),$(call TEST_FOR_EXISTENCE,fut))

$(OBJ_DIR)/%.cpp.o: $(SRC_DIR)/%.cpp
	$(TOOL_GCC_DIR)/bin/avr-g++ -c $(CXXFLAGS) -MMD -MF $(DEP_DIR)/$*.cpp.d $(INCDIRS) $< -o $@

$(CCS_OBJ_DIR)/%.cpp.o: $(CCS_SRC_DIR)/%.cpp
	$(TOOL_GCC_DIR)/bin/avr-g++ -c $(CXXFLAGS) -MMD -MF $(CCS_DEP_DIR)/$*.cpp.d $(INCDIRS) $< -o $@

$(BUS_OBJ_DIR)/%.cpp.o: $(BUS_SRC_DIR)/%.cpp
	$(TOOL_GCC_DIR)/bin/avr-g++ -c $(CXXFLAGS) -MMD -MF $(BUS_DEP_DIR)/$*.cpp.d $(INCDIRS) $< -o $@

$(HW_LIB_WIRE_OBJ_DIR)/%.cpp.o: $(HW_LIB_WIRE_DIR)/%.cpp
	$(TOOL_GCC_DIR)/bin/avr-g++ -c $(CXXFLAGS) -MMD -MF $(HW_LIB_WIRE_DEP_DIR)/$*.cpp.d $(INCDIRS) $< -o $@

$(HW_LIB_WIRE_OBJ_DIR)/%.c.o: $(HW_LIB_WIRE_DIR)/utility/%.c
	$(TOOL_GCC_DIR)/bin/avr-gcc -c $(CFLAGS) -MMD -MF $(HW_LIB_WIRE_DEP_DIR)/$*.c.d $(INCDIRS) $< -o $@

$(HW_LIB_SPI_OBJ_DIR)/%.cpp.o: $(HW_LIB_SPI_DIR)/%.cpp
	$(TOOL_GCC_DIR)/bin/avr-g++ -c $(CXXFLAGS) -MMD -MF $(HW_LIB_SPI_DEP_DIR)/$*.cpp.d $(INCDIRS) $< -o $@

$(HW_CORE_OBJ_DIR)/%.cpp.o: $(HW_CORE_DIR)/%.cpp
	$(TOOL_GCC_DIR)/bin/avr-g++ -c $(CXXFLAGS) -MMD -MF $(HW_CORE_DEP_DIR)/$*.cpp.d $(INCDIRS) $< -o $@

$(HW_CORE_OBJ_DIR)/%.c.o: $(HW_CORE_DIR)/%.c
	$(TOOL_GCC_DIR)/bin/avr-gcc -c $(CFLAGS) -MMD -MF $(HW_CORE_DEP_DIR)/$*.c.d $(INCDIRS) $< -o $@

$(HW_CORE_OBJ_DIR)/%.S.o: $(HW_CORE_DIR)/%.S
	$(TOOL_GCC_DIR)/bin/avr-gcc -c $(ASMFLAGS) -MMD -MF $(HW_CORE_DEP_DIR)/$*.S.d $(INCDIRS) $< -o $@

board-archive: $(HW_CORE_OBJ)
	$(TOOL_GCC_DIR)/bin/avr-gcc-ar rcs $(BIN_DIR)/core.a $^

link: $(OUR_OBJ) $(CCS_OBJ) $(BUS_OBJ) board-archive
	$(TOOL_GCC_DIR)/bin/avr-gcc $(LINKFLAGS) -o $(BIN_DIR)/$(BIN_NAME).elf $(OUR_OBJ) $(CCS_OBJ) $(BUS_OBJ) $(HW_WIRE_OBJ) $(HW_SPI_OBJ) $(BIN_DIR)/core.a -lm
	$(TOOL_GCC_DIR)/bin/avr-objcopy -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 $(BIN_DIR)/$(BIN_NAME).elf $(BIN_DIR)/$(BIN_NAME).eep
	$(TOOL_GCC_DIR)/bin/avr-objcopy -O ihex -R .eeprom $(BIN_DIR)/$(BIN_NAME).elf $(BIN_DIR)/$(BIN_NAME).hex
	$(TOOL_GCC_DIR)/bin/avr-size -A $(BIN_DIR)/$(BIN_NAME).elf
