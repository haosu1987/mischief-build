$(call module_get_vars,$(MODULE_NAME))

MODULE_TARGET_DEPS := $(call module_expand_target_deps,$(MODULE_NAME))

MODULE_C_OBJS := $(call filter-by-suffix,$(C_SUFFIX),$(OBJ_SUFFIX),$(MODULE_OBJECTS))
MODULE_CXX_OBJS := $(call filter-by-suffix,$(CXX_SUFFIX),$(OBJ_SUFFIX),$(MODULE_OBJECTS))

.PHONY: build_$(MODULE_NAME) clean_$(MODULE_NAME) clean_$(MODULE_NAME)_deps

build_$(MODULE_NAME): $(MODULE_TARGET)

$(MODULE_TARGET): module_name := $(MODULE_NAME)

$(MODULE_EXECUTE_BINARY):$(MODULE_TARGET_DEPS) $(MODULE_OBJECTS)
	$(HIDE)echo "$(module_name) [LN] $@"
	$(HIDE)$(CC) -o $@ $(filter %.o,$^) $(call module_expand_ldflags, $(module_name))

$(MODULE_SHARED_LIBRARY):$(MODULE_TARGET_DEPS) $(MODULE_OBJECTS)
	$(HIDE)echo "$(module_name) [LN] $@"
	$(HIDE)$(CC) -shared -o $@ $(filter %.o,$^)

$(MODULE_STATIC_LIBRARY):$(MODULE_TARGET_DEPS) $(MODULE_OBJECTS)
	$(HIDE)echo "$(module_name) [AR] $@"
	$(HIDE)$(AR) -rc $@ $(filter %.o,$^)

$(MODULE_C_OBJS):$(OUT)/%.o:%
	$(HIDE)mkdir -p $(dir $@)
	$(HIDE)echo "$(module_name) [CC] $@"
	$(HIDE)$(CC) -o $@ -c $< $(call module_expand_cflags, $(module_name))

$(MODULE_CXX_OBJS):$(OUT)/%.o:%
	$(HIDE)mkdir -p $(dir $@)
	$(HIDE)echo "$(module_name) [CXX] $@"
	$(HIDE)$(CXX) -o $@ -c $< $(call module_expand_cflags, $(module_name))

sinclude $(MODULE_OBJDEPS)

clean_$(MODULE_NAME):
	$(HIDE)echo "clean $(module_name)"
	$(HIDE)$(RM) -rf $(call module_load_cleanable,$(module_name))

clean_$(MODULE_NAME)_deps: $(addprefix clean_,$(call module_expand_library_name,$(MODULE_NAME)) $(MODULE_NAME))

clean_$(MODULE_NAME): module_name := $(MODULE_NAME)

