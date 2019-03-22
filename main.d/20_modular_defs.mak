##
# Definitions for modular
##

MODULAR_PATH := $(BUILD_CORE_PATH)/modular

MODULAR_CLEAR_VARIABLES             := $(MODULAR_PATH)/clear_variables.mak

MODULAR_PREBUILD_CXX_BINARY         := $(MODULAR_PATH)/prebuild_cxx_binary.mak
MODULAR_BUILD_CXX_BINARY   			:= $(MODULAR_PATH)/build_cxx_binary.mak

##
# Record the variables list
##

MODULAR_VARIABLES := $(call obtain_variables,$(MODULAR_CLEAR_VARIABLES))

MODULAR_VARIABLES += MODULE_PATH

MODULAR_VARIABLES := $(patsubst MODULE_%,%,$(MODULAR_VARIABLES))

define module_var_internal
MODULE_$(strip $(1))_$(strip $(2))
endef

define module_var_external
MODULE_$(strip $(1))
endef

define module_var_load
$($(call module_var_internal,$(1),$(2)))
endef

define module_put_var
$(eval $(call module_var_internal,$(1),$(2)) := $($(call module_var_external,$(2))))
endef

define module_get_var
$(eval $(call module_var_external,$(2)) := $($(call module_var_internal,$(1),$(2))))
endef

define module_display_var
$(info \
===> $(call module_var_internal,$(1),$(2)) \
===> $($(call module_var_internal,$(1),$(2))) \
)
endef

define module_put_vars
$(foreach var,$(MODULAR_VARIABLES),$(call module_put_var,$(1),$(var)))
endef

define module_get_vars
$(foreach var,$(MODULAR_VARIABLES),$(call module_get_var,$(1),$(var)))
endef

define module_display_vars
$(foreach var,$(MODULAR_VARIABLES),$(call module_display_var,$(1),$(var)))
endef

##
# Help load the values for the variables
##

define module_load_makefile
$(call module_var_load,$(1),MAKEFILE)
endef

define module_load_target
$(call module_var_load,$(1),TARGET)
endef

define module_load_ldpath
$(foreach t,$(call module_load_target,$(1)),$(dir $(t)))
endef

define module_load_includes
$(foreach mod,$(1),$(call module_var_load,$(mod),INC_EXPORT))
endef

define module_load_cleanable
$(call module_load_target,$(1)) \
$(call module_var_load,$(1),OBJECTS) \
$(call module_var_load,$(1),OBJDEPS)
endef

define module_load_deps
$(foreach mod,$(call module_var_load,$(1),LIBRARY_DEPS),$(mod) $(call module_load_deps,$(mod)))
endef

define module_load_ldlib
$(if $(call module_load_target,$(1)),$(1))
endef

define module_expand_deps
$(call uniq,$(2) $(foreach m,$(call module_load_deps,$(1)),$(m)))
endef

define module_expand_deps_with
$(call uniq,$(foreach m,$(call module_expand_deps,$(1),$(3)),$(call $(2),$(m))))
endef

define module_expand_target_deps
$(call module_expand_deps_with,$(1),module_load_target)
endef

define module_expand_cflags
$(addprefix -I,$(call module_expand_deps_with,$(1),module_load_includes,$(1))) \
$(call module_var_load,$(1),CFLAGS)
endef

define module_expand_ldflags
$(addprefix -L,$(call module_expand_deps_with,$(1),module_load_ldpath)) \
$(addprefix -l,$(call module_expand_deps_with,$(1),module_load_ldlib)) \
$(call module_var_load,$(1),LDFLAGS)
endef
