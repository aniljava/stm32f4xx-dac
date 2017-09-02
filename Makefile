ARM_TOOLCHAIN=
CC=$(ARM_TOOLCHAIN)arm-none-eabi-gcc
LD=$(ARM_TOOLCHAIN)arm-none-eabi-gcc
AS=$(ARM_TOOLCHAIN)arm-none-eabi-gcc
OBJCOPY=$(ARM_TOOLCHAIN)arm-none-eabi-objcopy

PROJECT_NAME=$(notdir $(CURDIR))
BUILD_DIR=target
LIB_DIR=lib/
# CMD_ECHO = @

# Defines required by included libraries
DEF = -DSTM32F4XX \
	  -DMEDIA_IntFLASH \
	  -DUSE_STDPERIPH_DRIVER \
	  -DUSB_AUDIO \
	  -DUSE_DEVICE_MODE \
	  -DUSE_USB_OTG_FS \
	  -D__I2S_24BIT \
	  -D__USE_I2S_24BIT \

INC = -I. \
	  -I$(LIB_DIR)CMSIS/Include \
	  -I$(LIB_DIR)CMSIS/ST/STM32F4xx/Include \
	  -I$(LIB_DIR)STM32F4xx_StdPeriph_Driver/inc \
	  -Isrc/codecs/ \
	  -Isrc/inc/ \
	  -Isrc/usb/

LINC = -LMiddlewares/ST/STemWin/Lib 


ARCHFLAGS = -mcpu=cortex-m4 -mthumb -g2 -ffunction-sections -O3 -fdata-sections -Wl,--gc-sections
CFLAGS = $(ARCHFLAGS)

SRC_LD = src/std/LinkerScript.ld
LDFLAGS = $(ARCHFLAGS) --specs=nosys.specs
LDLIBS = 
SRC_C += $(wildcard src/main/*.c)
SRC_C += $(wildcard src/usb/*.c)
SRC_C += $(wildcard src/codecs/*.c)
SRC_C += $(wildcard lib/STM32F4xx_StdPeriph_Driver/src/*.c)


vpath %.c $(dir $(SRC_C))

FILENAMES_C = $(notdir $(SRC_C))
OBJS_C = $(addprefix $(BUILD_DIR)/, $(FILENAMES_C:.c=.o))


SRC_ASM = $(wildcard src/std/*.s)
vpath %.s $(dir $(SRC_ASM))

FILENAMES_ASM = $(notdir $(SRC_ASM))
OBJS_ASM = $(addprefix $(BUILD_DIR)/, $(FILENAMES_ASM:.s=.o))





all: $(BUILD_DIR) BINARY

$(BUILD_DIR)/%.o: %.c
	@echo "Compiling C file: $(notdir $<)"
	$(CMD_ECHO) $(CC) $(CFLAGS) $(DEF) $(INC) -c -o $@ $<

$(BUILD_DIR)/%.o: %.s
	@echo "Compiling ASM file: $(notdir $<)"
	$(CMD_ECHO) $(AS) $(CFLAGS) $(DEF) $(INC) -c -o $@ $<
	

BINARY: $(OBJS_C) $(OBJS_ASM)
	$(CMD_ECHO) $(LD) $(LDFLAGS) -T$(SRC_LD) -o $(BUILD_DIR)/$(PROJECT_NAME).elf $^ $(LDLIBS)
	$(CMD_ECHO) $(OBJCOPY) -O binary $(BUILD_DIR)/$(PROJECT_NAME).elf $(BUILD_DIR)/$(PROJECT_NAME).bin

	@echo $(BUILD_DIR)/$(PROJECT_NAME).elf
	@echo $(BUILD_DIR)/$(PROJECT_NAME).bin
	@echo $(CURDIR)

$(BUILD_DIR):
	$(CMD_ECHO) mkdir -p $(BUILD_DIR)

flash: BINARY
	$(CMD_ECHO) st-flash --reset write $(BUILD_DIR)/$(PROJECT_NAME).bin 0x8000000


clean:
	rm -f $(BUILD_DIR)/*.elf $(BUILD_DIR)/*.hex $(BUILD_DIR)/*.map $(BUILD_DIR)/*.bin
	rm -f $(BUILD_DIR)/*.o $(BUILD_DIR)/*.sym $(BUILD_DIR)/*.disasm
