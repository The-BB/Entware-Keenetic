# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2018-2024 Entware

include $(TOPDIR)/rules.mk

ARCH:=mipsel
BOARD:=mipsel
BOARDNAME:=Entware MIPS (little-endian)
CPU_TYPE:=mips32r2
FEATURES:=audio gpio pci usb
KERNEL_PATCHVER:=4.9
KERNEL_TESTING_PATCHVER:=5.15
#KERNEL_TESTING_PATCHVER:=6.1

include $(INCLUDE_DIR)/target.mk

define Target/Description
  Build Software Repository for MIPS (little-endian) soft float routers.
endef

#FEATURES:=$(filter-out mips16,$(FEATURES))

$(eval $(call BuildTarget))
