[#ftl]
[@pp.dropOutputFile /]
[@pp.changeOutputFile name="Makefile" /]
##############################################################################
# Build global options
# NOTE: Can be overridden externally.
#

# Compiler options here.
ifeq ($(USE_OPT),)
  USE_OPT = ${conf.instance.build_settings.optimization_level.value[0]} ${conf.instance.build_settings.common_options.value[0]}
endif

# C specific options here (added to USE_OPT).
ifeq ($(USE_COPT),)
  USE_COPT = ${conf.instance.build_settings.c_options.value[0]}
endif

# C++ specific options here (added to USE_OPT).
ifeq ($(USE_CPPOPT),)
  USE_CPPOPT = ${conf.instance.build_settings.cpp_options.value[0]}
endif

# Enable this if you want the linker to remove unused code and data
ifeq ($(USE_LINK_GC),)
  USE_LINK_GC = ${conf.instance.build_settings.use_linker_gc.value[0]}
endif

# If enabled, this option allows to compile the application in THUMB mode.
ifeq ($(USE_THUMB),)
  USE_THUMB = yes
endif

# Enable this if you want to see the full log while compiling.
ifeq ($(USE_VERBOSE_COMPILE),)
  USE_VERBOSE_COMPILE = ${conf.instance.build_settings.use_verbose_compile.value[0]}
endif

#
# Build global options
##############################################################################

##############################################################################
# Architecture or project specific options
#

# Enables the use of FPU on Cortex-M4.
# Enable this if you really want to use the STM FWLib.
ifeq ($(USE_FPU),)
  USE_FPU = no
endif

#
# Architecture or project specific options
##############################################################################

##############################################################################
# Project, sources and paths
#

# Define project name here
PROJECT = ${conf.instance.build_settings.application_name.value[0]}

# Imported source files
include components/components.mak

# Checks if there is a user mak file in the project directory.
ifneq ($(wildcard user.mak),) 
    include user.mak
endif

# Define linker script file here
LDSCRIPT= application.ld

# C sources here.
CSRC =      ./components/components.c \
            $(LIB_C_SRC) \
            $(APP_C_SRC) \
            $(U_C_SRC)

# C++ sources here.
CPPSRC =    $(LIB_CPP_SRC) \
            $(APP_CPP_SRC) \
            $(U_CPP_SRC)

# List ASM source files here
ASMSRC =    $(LIB_ASM_SRC) \
            $(APP_ASM_SRC) \
            $(U_ASM_SRC)

INCDIR =    ./components \
            $(LIB_INCLUDES) \
            $(APP_INCLUDES)

#
# Project, sources and paths
##############################################################################

##############################################################################
# Compiler settings
#

MCU  = cortex-m4

TRGT = ${conf.instance.build_settings.compiler_variant.value[0]}
CC   = $(TRGT)gcc
CPPC = $(TRGT)g++
# Enable loading with g++ only if you need C++ runtime support.
# NOTE: You can use C++ even without C++ support if you are careful. C++
#       runtime support makes code size explode.
LD   = $(TRGT)gcc
#LD   = $(TRGT)g++
CP   = $(TRGT)objcopy
AS   = $(TRGT)gcc -x assembler-with-cpp
OD   = $(TRGT)objdump
HEX  = $(CP) -O ihex
BIN  = $(CP) -O binary

# ARM-specific options here
AOPT =

# THUMB-specific options here
TOPT = -mthumb -DTHUMB

# Define C warning options here
CWARN = -Wall -Wextra -Wstrict-prototypes

# Define C++ warning options here
CPPWARN = -Wall -Wextra

#
# Compiler settings
##############################################################################

##############################################################################
# Start of default section
#

# List all default C defines here, like -D_DEBUG=1
DDEFS   = -D${conf.instance.platform_settings.specific_model.value[0]}

# List all default ASM defines here, like -D_DEBUG=1
DADEFS  =

# List all default directories to look for include files here
DINCDIR =

# List the default directory to look for the libraries here
DLIBDIR =

# List all default libraries here
DLIBS   =

#
# End of default section
##############################################################################

ifeq ($(USE_FPU),yes)
  USE_OPT += -mfloat-abi=softfp -mfpu=fpv4-sp-d16 -fsingle-precision-constant
  DDEFS += -DCORTEX_USE_FPU=TRUE
else
  DDEFS += -DCORTEX_USE_FPU=FALSE
endif

include ${global.component_path}/lib/rsc/rules.mk
