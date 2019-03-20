MODULAR_LIST :=

.PHONY: clean build

all: build

## Prebuild
include $(call find_all_module_mak,$(WORKDIR))

## Building
$(foreach MODULE_NAME,$(MODULAR_LIST),\
	$(eval include $(call module_load_makefile,$(MODULE_NAME))) \
)

clean: $(addprefix clean_,$(MODULAR_LIST))

build: $(addprefix build_,$(MODULAR_LIST))
