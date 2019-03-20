HIDE ?= @
SKIP ?=

C_SUFFIX ?= .c .cc
CXX_SUFFIX ?= .cpp .cxx
OBJ_SUFFIX ?= .o

define findall
$(shell find $(1) -name .git -prune -o -name out -prune -o -name $(2) -print)
endef

define find_all_module_mak
$(call findall,$(1),module.mak)
endef

define latest-val
$(word $(words $(1)),$(1))
endef

define my-dir
$(patsubst %/,%,$(dir $(call latest-val, $(MAKEFILE_LIST))))
endef

define upper
$(shell echo $(strip $(1)) | tr '[a-z]' '[A-Z]')
endef

define lower
$(shell echo $(strip $(1)) | tr '[A-Z]' '[a-z]')
endef

define obtain_variables
$(eval _variables := $(.VARIABLES))\
$(eval include $(1))\
$(eval _variables := $(filter-out _variables $(_variables),$(.VARIABLES)))\
$(strip $(_variables))
endef

define uniq
$(eval seen :=) \
$(foreach _,$(1),$(if $(filter $_,$(seen)),,$(eval seen += $_))) \
${seen}
endef

define filter-by-suffix
$(filter $(addprefix %,$(addsuffix $(2),$(1))),$(3))
endef

define all-files-under
$(wildcard $(addprefix $(1)/*,$(2)))
endef

define all-c-files-under
$(call all-files-under,$(1),$(C_SUFFIX))
endef

define all-cxx-files-under
$(call all-files-under,$(1),$(CXX_SUFFIX))
endef

define all-clike-files-under
$(call all-c-files-under,$(1)) \
$(call all-cxx-files-under,$(1))
endef