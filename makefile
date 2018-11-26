#STM32 makefile

# 生成的文件名<项目名>
PROJECT 				 = stm32

#GNU前缀
GNUGCC					 = arm-none-eabi-

# Build path
BUILD_DIR = Output

# 定义文件格式和文件名
TARGET 					:= $(PROJECT)
TARGET_ELF	 			:= $(TARGET).elf
TARGET_BIN 				:= $(TARGET).bin
TARGET_HEX 				:= $(TARGET).hex
OBJCPFLAGS_ELF_TO_BIN 	 = -Obinary
OBJCPFLAGS_ELF_TO_HEX 	 = -Oihex
OBJCPFLAGS_BIN_TO_HEX 	 = -Ibinary -Oihex

# 定义路径
TOP_DIR		 = .
SCRIPT_DIR	:= $(TOP_DIR)/Core
STARTUP_DIR := $(TOP_DIR)/third_party/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/startup
INC_DIR     := -I $(TOP_DIR)/App -I $(TOP_DIR)/Core -I $(TOP_DIR)/Libraries -I $(TOP_DIR)/User

# 设置shell环境变量
#export LD_LIBRARY_PATH = $LD_LIBRARY_PATH:/Users/ch-yanghl/gcc-arm-none-eabi/arm-none-eabi/lib/thumb/

# 设置ld链接脚本文件
LDSCRIPT 	:= $(SCRIPT_DIR)/stm32_flash.ld

# 定义编译工具
CC 			= $(GNUGCC)gcc
AS 			= $(GNUGCC)as
LD 			= $(GNUGCC)ld
AR 			= $(GNUGCC)ar
OBJCP 	= $(GNUGCC)objcopy

# 定义编译标志
CCFLAGS 	+= -Wall -mcpu=cortex-m3 -mthumb -g -mfloat-abi=soft -march=armv7-m
ASFLAGS		+= -Wall -mcpu=cortex-m3 -mthumb
LDFLAGS 	+= -T $(LDSCRIPT) #-A armv7-m
LDFLAGS 	+= -L D:/cc2601-tiny/gcc-arm-none-eabi-7-2018/lib/gcc/arm-none-eabi/7.3.1
LDFLAGS 	+= -L D:/cc2601-tiny/gcc-arm-none-eabi-7-2018/arm-none-eabi/lib/thumb

# 要链接的静态库
#LDLIBS 		+= /Users/ch-yanghl/gcc-arm-none-eabi/arm-none-eabi/lib/thumb/libc.a
#LDLIBS 		+= /Users/ch-yanghl/gcc-arm-none-eabi/arm-none-eabi/lib/thumb/libg.a
#LDLIBS 		+= /Users/ch-yanghl/gcc-arm-none-eabi/arm-none-eabi/lib/thumb/libm.a
#LDLIBS     += /Users/ch-yanghl/gcc-arm-none-eabi/lib/gcc/arm-none-eabi/5.4.1/libgcc.a
#LDLIBS     += /Users/ch-yanghl/gcc-arm-none-eabi/arm-none-eabi/lib/thumb/libnosys.a
#LDLIBS 		+= ./STM32F10xD.LIB


# .c文件中的头文件引用查找路径
CCFLAGS		+= $(INC_DIR)

# .s文件的flags
#ASFLAGS		+=

# .c文件编译时定义宏
#CCFLAGS		+= -D STM32F10X_MD -D USE_STDPERIPH_DRIVER

# 添加启动文件
#SOURCE 		+= $(SCRIPT_DIR)/startup_stm32f10x_md.c
SOURCE_ASM 		+= $(SCRIPT_DIR)/startup_stm32f10x_hd.s

# 展开工作 子目录中的inc文件（inc文件中添加需要编译链接的.c，.s等文件）
-include $(TOP_DIR)/User/make.inc
#-include $(TOP_DIR)/third_party/make.inc

# 替换文件后缀
C_OBJS		:= $(SOURCE:%.c=%.o)
ASM_OBJS	:= $(SOURCE_ASM:%.s=%.o)

# 编译命令的定义
COMPILE		= $(CC) $(CCFLAGS) -c $< -o $@
ASSEMBLE	= $(AS) $(ASFLAGS) -c $< -o $@
LINK		= $(LD) $+ $(LDFLAGS) $(LDLIBS) -o $@
ELF_TO_BIN	= $(OBJCP) $(OBJCPFLAGS_ELF_TO_BIN) $< $@
BIN_TO_HEX	= $(OBJCP) $(OBJCPFLAGS_BIN_TO_HEX) $< $@

# 定义伪目标
.PHONY: all clean printf

# 定义规则
all: $(BUILD_DIR)/$(TARGET_HEX)
	@echo "build done"

$(BUILD_DIR)/$(TARGET_HEX): $(BUILD_DIR)/$(TARGET_BIN)
	$(BIN_TO_HEX)

$(BUILD_DIR)/$(TARGET_BIN): $(BUILD_DIR)/$(TARGET_ELF)
	$(ELF_TO_BIN)

$(BUILD_DIR)/$(TARGET_ELF): $(C_OBJS) $(ASM_OBJS)
	$(LINK)

$(C_OBJS):%.o:%.c
	$(COMPILE)

$(ASM_OBJS):%.o:%.s
	$(ASSEMBLE)

printf:
	@echo $(ASM_OBJS)
	@echo $(ASSEMBLE)

# 清理项
clean:
	rm -f $(BUILD_DIR)/$(TARGET_HEX)
	rm -f $(BUILD_DIR)/$(TARGET_BIN)
	rm -f $(BUILD_DIR)/$(TARGET_ELF)
	rm -f $(C_OBJS) $(ASM_OBJS)
	@echo "clean done"

