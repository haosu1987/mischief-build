MODULAR_LIST :=

.PHONY: clean build

all: build

## Prebuild
$(call include-module-under,$(WORKDIR))

## Building
$(foreach MODULE_NAME,$(MODULAR_LIST),\
	$(eval include $(call module_load_makefile,$(MODULE_NAME))) \
)

clean: $(addprefix clean_,$(MODULAR_LIST))

build: $(addprefix build_,$(MODULAR_LIST))
