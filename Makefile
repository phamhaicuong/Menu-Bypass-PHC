TARGET := iphone:clang:latest:14.0
ARCHS := arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME := CuongBypass

CuongBypass_FILES := Tweak.xm
CuongBypass_FRAMEWORKS := UIKit Foundation CoreGraphics QuartzCore
CuongBypass_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/tweak.mk
