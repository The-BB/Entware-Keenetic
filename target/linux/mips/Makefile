# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2024 Entware

include $(TOPDIR)/rules.mk

ARCH:=mips
BOARD:=mips
BOARDNAME:=Entware MIPS (big-endian)
CPU_TYPE:=mips32r2
FEATURES:=audio gpio pci usb
KERNEL_PATCHVER:=4.9
KERNEL_TESTING_PATCHVER:=5.15
#KERNEL_TESTING_PATCHVER:=6.1

include $(INCLUDE_DIR)/target.mk

define Target/Description
  Build Software Repository for MIPS (big-endian) soft float routers.
endef

#FEATURES:=$(filter-out mips16,$(FEATURES))

$(eval $(call BuildTarget))
