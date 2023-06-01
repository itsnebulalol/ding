ifeq ($(ROOTLESS), 1)
TARGET := iphone:clang:14.5:latest
THEOS_PACKAGE_SCHEME = rootless
else
TARGET := iphone:clang:13.7:13.0
PREFIX = $(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/
endif

INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = arm64 arm64e
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Ding

$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = UIKitCore IOKit
$(TWEAK_NAME)_FRAMEWORKS = UIKit 
$(TWEAK_NAME)_EXTRA_FRAMEWORKS += Cephei

$(TWEAK_NAME)_FILES = Ding.xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += DingPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk