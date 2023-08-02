ifeq ($(ROOTFUL), 1)
TARGET := iphone:clang:13.7:13.0
PREFIX = /Applications/Xcode-11.7.0.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/
else
TARGET := iphone:clang:15.5:15.0
THEOS_PACKAGE_SCHEME = rootless
endif

INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = arm64 arm64e
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Ding

$(TWEAK_NAME)_FILES = Ding.xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -Wc++11-extensions -std=c++11
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = UIKitCore IOKit
$(TWEAK_NAME)_FRAMEWORKS = UIKit CoreTelephony
$(TWEAK_NAME)_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += DingPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk
