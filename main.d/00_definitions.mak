HIDE ?= @
SKIP ?=

C_SUFFIX ?= .c
CXX_SUFFIX ?= .cpp .cxx .cc
OBJ_SUFFIX ?= .o

IGNORE_PATH ?= out .git .gitignore

define expand-files-under
$(filter-out $(addprefix %/,$(2)),$(wildcard $(1)/*))
endef

define find-files-under
$(eval files := $(call expand-files-under,$(2),$(3)))\
$(if $(filter $(2)/$(1),$(files)),$(2)/$(1),$(foreach dir,$(files),$(call find-files-under,$(1),$(dir),$(3))))
endef

define find-module-make-under
$(call find-files-under,module.mak,$(1),$(IGNORE_PATH))
endef

define include-module-under
$(eval include $(call find-module-make-under,$(1)))
endef

define include-submodule-under
$(foreach d,$(wildcard $(1)/*),$(call include-module-under,$(d)))
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
