
MODULE_OUT_PATH := $(OUT)/$(MODULE_PATH)

MODULE_TYPE_SELECTIONS := shared static binary both

MODULE_STATIC_LIBRARY += $(MODULE_OUT_PATH)/lib$(MODULE_NAME).a
MODULE_SHARED_LIBRARY += $(MODULE_OUT_PATH)/lib$(MODULE_NAME).so
MODULE_EXECUTE_BINARY += $(MODULE_OUT_PATH)/$(MODULE_NAME)

ifneq ($(filter-out $(MODULE_TYPE_SELECTIONS),$(MODULE_TYPE)),)
$(error MODULE_TYPE should be evalued as '$(MODULE_TYPE_SELECTIONS)')
endif

ifeq ($(strip $(MODULE_TYPE)),)
	MODULE_TYPE := both
endif

ifeq ($(strip $(MODULE_TYPE)),both)
	MODULE_TYPE := shared static
endif

MODULE_TARGET :=

ifeq ($(filter shared,$(MODULE_TYPE)),shared)
MODULE_TARGET += $(MODULE_SHARED_LIBRARY)
endif

ifeq ($(filter static,$(MODULE_TYPE)),static)
MODULE_TARGET += $(MODULE_STATIC_LIBRARY)
endif

ifeq ($(filter binary,$(MODULE_TYPE)),binary)
MODULE_TARGET += $(MODULE_EXECUTE_BINARY)
endif

MODULE_OBJECTS := $(patsubst %,$(OUT)/%.o,$(MODULE_SRC_FILES))
MODULE_OBJDEPS := $(patsubst %.o,%.d,$(MODULE_OBJECTS))

MODULE_MAKEFILE := $(MODULAR_BUILD_CXX_BINARY)

MODULE_CFLAGS += -fPIC -MMD

$(call module_put_vars, $(MODULE_NAME))

MODULAR_LIST += $(MODULE_NAME)
