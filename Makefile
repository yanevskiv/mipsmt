BUILD_DIR = build
TARGET = program
SRC_DIR = src
INC_DIR = inc
DEBUG = 1

LD_SCRIPT = linker_script.ld
C_SOURCES = $(wildcard $(SRC_DIR)/*.c)
S_SOURCES = $(wildcard $(SRC_DIR)/*.s)
OBJECTS =
OBJECTS += $(addprefix $(BUILD_DIR)/, $(notdir $(C_SOURCES:.c=.o)))
OBJECTS += $(addprefix $(BUILD_DIR)/, $(notdir $(S_SOURCES:.s=.o)))

HX = arm-none-eabi-objcopy
LD = arm-none-eabi-ld
CC = arm-none-eabi-gcc 
AS = arm-none-eabi-gcc

HX_FLAGS = -O ihex
LD_FLAGS = -T $(LD_SCRIPT)
CC_FLAGS = -I $(INC_DIR) -c -MMD -MP -mcpu=cortex-m3 -mthumb
AS_FLAGS = -c -x assembler
DEBUG_FLAGS = -g -gdwarf-2 -fdebug-prefix-map==../
DEBUG_COLORS = -fdiagnostics-color=always

ifeq ($(DEBUG), 1)
	CC_FLAGS += $(DEBUG_FLAGS) $(DEBUG_COLORS)
	AS_FLAGS += $(DEBUG_FLAGS) $(DEBUG_COLORS)
endif

all:  $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).elf Makefile | $(BUILD_DIR)

$(BUILD_DIR)/$(TARGET).hex: $(BUILD_DIR)/$(TARGET).elf Makefile | $(BUILD_DIR)
	$(HX) $(HX_FLAGS) $(<) $(@)

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) | $(BUILD_DIR)
	$(LD) $(LD_FLAGS) -o $(@) $(OBJECTS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CC_FLAGS) -o $(@) $(<)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s | $(BUILD_DIR)
	$(AS) $(AS_FLAGS) -o $(@) $(<)

clean:
	rm -rf $(BUILD_DIR)
	
.PHONY: clean	

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

-include $(wildcard $(BUILD_DIR)/*.d)
