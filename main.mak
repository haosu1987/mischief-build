###
# Makefile for Mischief
#

.PHONY: all

all:

WORKDIR ?= .

OUT ?= $(WORKDIR)/out

BUILD_CORE_PATH := $(WORKDIR)/build/core

MAIN_DIR := $(BUILD_CORE_PATH)/main.d

include $(sort $(wildcard $(MAIN_DIR)/*.mak))
