
CCFLAGS	+= -I $(TOP_DIR)/User

#SOURCE	+= $(wildcard $(TOP_DIR)/User/*.c)
#SOURCE	+= $(wildcard $(STM32_LIB_DIR)/CMSIS/Device/ST/STM32F2xx/Source/Templates/*.c)
SOURCE	+= $(TOP_DIR)/User/main.c
#SOURCE_ASM	+= $(STM32_LIB_DIR)/CMSIS/CM3/DeviceSupport/ST/STM32F10x/startup/gcc_ride7/startup_stm32f10x_md.s
