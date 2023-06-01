ifeq ($(THEOS_PACKAGE_SCHEME), rootless)
export TARGET := iphone:clang:15.5:15.0
else
export TARGET := iphone:clang:13.7:13.0
export PREFIX = $(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/
endif
export ARCHS = arm64 arm64e

INSTALL_TARGET_PROCESSES = SpringBoard
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Ding

Ding_FILES = Tweak.x
Ding_CFLAGS = -fobjc-arc
Ding_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += DingPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk
