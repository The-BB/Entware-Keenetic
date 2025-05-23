#
# Copyright (C) 2010-2019 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=elfutils
PKG_VERSION:=0.192
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://sourceware.org/$(PKG_NAME)/ftp/$(PKG_VERSION) \
                https://mirrors.kernel.org/sourceware/$(PKG_NAME)/$(PKG_VERSION)
PKG_HASH:=616099beae24aba11f9b63d86ca6cc8d566d968b802391334c91df54eab416b4

PKG_MAINTAINER:=Luiz Angelo Daros de Luca <luizluca@gmail.com>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=COPYING COPYING-GPLV2 COPYING-LGPLV3
PKG_CPE_ID:=cpe:/a:elfutils_project:elfutils

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1
PKG_BUILD_DEPENDS:=!USE_GLIBC:argp-standalone USE_MUSL:musl-obstack

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/elfutils/Default
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=ELF manipulation libraries
  URL:=https://fedorahosted.org/elfutils/
  ABI_VERSION:=1
endef

define Package/libasm
  $(call Package/elfutils/Default)
  TITLE+= (libasm)
  DEPENDS:=+libelf +libdw
endef

define Package/libdw
  $(call Package/elfutils/Default)
  DEPENDS:=+libelf +libbz2 +USE_MUSL:musl-fts
  TITLE+= (libdw)
endef

define Package/libelf
  $(call Package/elfutils/Default)
  DEPENDS:=$(INTL_DEPENDS) +zlib
  TITLE+= (libelf)
  PROVIDES:=libelf1
endef

define Package/elfutils
  $(call Package/elfutils/Default)
  SECTION:=devel
  CATEGORY:=Development
  TITLE:=tools for ELF files
  DEPENDS:=+libasm +libstdcpp $(INTL_DEPENDS)
endef

ifeq ($(CONFIG_BUILD_NLS),y)
TARGET_LDFLAGS += -lintl
else
CONFIGURE_ARGS += --disable-nls
endif

HOST_CONFIGURE_ARGS += \
	--disable-shared \
	--disable-nls \
	--disable-debuginfod \
	--disable-libdebuginfod \
	--without-bzlib \
	--without-lzma \
	--without-zstd

CONFIGURE_ARGS += \
	--program-prefix=eu- \
	--disable-debuginfod \
	--disable-libdebuginfod \
	--without-bzlib \
	--without-lzma \
	--without-zstd \
	--disable-symbol-versioning

CONFIGURE_ARGS += \
	--enable-progs

HOST_CONFIGURE_VARS += \
	ac_cv_search__obstack_free=yes

CONFIGURE_VARS += \
	ac_cv_search__obstack_free=yes

TARGET_CFLAGS += \
	-D_GNU_SOURCE \
	-Wno-unused-result \
	-Wno-format-nonliteral

# XXX Entware specific: GCC-8.x.x (cc1: error: -Werror=use-after-free: no option -Wuse-after-free)
ifneq ($(or $(CONFIG_GCC_USE_VERSION_8),$(CONFIG_GCC_USE_VERSION_11)),y)
TARGET_CFLAGS += \
	-Wno-error=use-after-free
endif

ifneq ($(CONFIG_USE_MUSL),y)
TARGET_CFLAGS += \
	-DHAVE_ERROR_H
else
TARGET_CFLAGS += \
	-Wno-error -DFNM_EXTMATCH=0

TARGET_CXXFLAGS += \
	-Wno-error

CONFIGURE_VARS += \
	fts_LIBS='-lfts' \
	obstack_LIBS='-lobstack' \
	ac_cv_search__obstack_free=-lobstack
endif


define Build/InstallDev
	$(INSTALL_DIR) $(1)/opt/include
	$(CP) $(PKG_INSTALL_DIR)/opt/include/* $(1)/opt/include/
	$(INSTALL_DIR) $(1)/opt/lib
	$(CP) $(PKG_INSTALL_DIR)/opt/lib/libasm*.{a,so*} $(1)/opt/lib/
	$(CP) $(PKG_INSTALL_DIR)/opt/lib/libdw*.{a,so*} $(1)/opt/lib/
	$(CP) $(PKG_INSTALL_DIR)/opt/lib/libelf*.{a,so*} $(1)/opt/lib/
	$(INSTALL_DIR) $(1)/opt/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/opt/lib/pkgconfig/libelf.pc $(1)/opt/lib/pkgconfig/
	$(CP) $(PKG_INSTALL_DIR)/opt/lib/pkgconfig/libdw.pc $(1)/opt/lib/pkgconfig/
endef

define Package/libasm/install
	$(INSTALL_DIR) $(1)/opt/lib
	$(CP) $(PKG_INSTALL_DIR)/opt/lib/libasm{-*.so,*.so.*} $(1)/opt/lib/
endef

define Package/libdw/install
	$(INSTALL_DIR) $(1)/opt/lib
	$(CP) $(PKG_INSTALL_DIR)/opt/lib/libdw{-*.so,*.so.*} $(1)/opt/lib/
endef

define Package/libelf/install
	$(INSTALL_DIR) $(1)/opt/lib
	$(CP) $(PKG_INSTALL_DIR)/opt/lib/libelf{-*.so,*.so.*} $(1)/opt/lib/
endef

define Package/elfutils/install
	$(INSTALL_DIR) $(1)/opt/bin
	$(CP) $(PKG_INSTALL_DIR)/opt/bin/* $(1)/opt/bin/
endef

# these lines need to be ordered by dependency because of ABI versioning
$(eval $(call BuildPackage,libelf))
$(eval $(call BuildPackage,libdw))
$(eval $(call BuildPackage,libasm))
$(eval $(call BuildPackage,elfutils))
