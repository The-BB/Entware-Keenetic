# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2024 Entware

include $(TOPDIR)/rules.mk

PKG_NAME:=musl-obstack
PKG_VERSION:=1.2.3
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_SOURCE_URL:=https://github.com/void-linux/musl-obstack
PKG_MIRROR_HASH:=95c1f0124dd4728867b0d22389ad887a492b301ac37a736edc9d056f2a3c19c4

PKG_LICENSE:=LGPL-2.1-only
PKG_LICENSE_FILES:=COPYING

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/musl-obstack
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=A standalone library to implement GNU libc's obstack
  URL:=https://github.com/void-linux/musl-obstack
  DEPENDS:=@!USE_GLIBC
  BUILDONLY:=1
endef

define Package/musl-obstack/description
  The musl-obstack package is a copy + paste of the obstack functions
  and macros found in GNU gcc libiberty library for use with musl libc.
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/opt/include
	$(CP) $(PKG_INSTALL_DIR)/opt/include/obstack.h $(1)/opt/include
	$(INSTALL_DIR) $(1)/opt/lib
#	$(CP) $(PKG_INSTALL_DIR)/opt/lib/libobstack.{a,so*} $(1)/opt/lib
	$(CP) $(PKG_INSTALL_DIR)/opt/lib/libobstack.a $(1)/opt/lib
	$(INSTALL_DIR) $(1)/opt/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/opt/lib/pkgconfig/*.pc $(1)/opt/lib/pkgconfig
endef

#define Package/musl-obstack/install
#	$(INSTALL_DIR) $(1)/opt/lib
#	$(CP) $(PKG_INSTALL_DIR)/opt/lib/libobstack.so* $(1)/opt/lib
#endef

$(eval $(call BuildPackage,musl-obstack))
