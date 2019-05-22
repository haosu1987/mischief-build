HIDE ?= @
SKIP ?=

C_SUFFIX ?= .c
CXX_SUFFIX ?= .cpp .cxx .cc
OBJ_SUFFIX ?= .o

IGNORE_PATH ?= out .git .gitignore

##
# Wildcard all files and paths under the path, 
# and exclude assigned paths or files.
#
# $(1): the root path that will be expanded
# $(2): the exclude files or paths.
##
define wildcard-under
$(filter-out $(addprefix %/,$(2)),$(wildcard $(1)/*))
endef

##
# Find the first file under the path.
#
# $(1): the target path
# $(2): the target file or path will be found
# $(3): the exclude path that not search in.
##
define find-first
$(if $(wildcard $(1)/$(2)),\
	$(1)/$(2),\
	$(foreach dir,\
		$(call wildcard-under,$(1),$(3)),\
		$(call find-first,$(dir),$(2),$(3))\
	)\
)
endef

define find-module-make-under
$(call find-first,$(1),module.mak,$(IGNORE_PATH))
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
