# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2024 Entware

include $(TOPDIR)/rules.mk

ARCH:=aarch64
BOARD:=aarch64
BOARDNAME:=Entware ARM64 (AArch64)
CPU_TYPE:=cortex-a53
FEATURES:=audio gpio pci usb
KERNEL_PATCHVER:=4.9
KERNEL_TESTING_PATCHVER:=5.15
#KERNEL_TESTING_PATCHVER:=6.1

include $(INCLUDE_DIR)/target.mk

define Target/Description
  Build Software Repository for ARM64 routers.
endef

$(eval $(call BuildTarget))
