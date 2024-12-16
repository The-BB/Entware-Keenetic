# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2019-2024 Entware

# Этот вариант busysbox с минимумом апплетов для систем, где busybox вообще нет.
# 0. Можно понизить версию.
# 1. Для изменения конфигурации следует выполнить make package/poorbox/configure.
# 2. Зайти в папку poorbox, выполнить make menuconfig.
# 3. Изменить интересующие пункты в меню. Сохранить настройки.
# 4. Обновленный .config положить в src.

include $(TOPDIR)/rules.mk

PKG_NAME:=poorbox
PKG_REAL_NAME:=busybox
PKG_VERSION:=1.37.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_REAL_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://www.busybox.net/downloads \
		https://sources.buildroot.net/$(PKG_REAL_NAME)
PKG_HASH:=3311dff32e746499f4df0d5df04d7eb396382d7e108bb9250e7b519b837043a4

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_BUILD_PARALLEL:=1
PKG_CHECK_FORMAT_SECURITY:=0

#Busybox use it's own PIE config flag and LDFLAGS are used with ld, not gcc.
PKG_ASLR_PIE:=0

PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=LICENSE archival/libarchive/bz/LICENSE
PKG_CPE_ID:=cpe:/a:busybox:busybox

include $(INCLUDE_DIR)/package.mk

PKG_UNPACK:=$(HOST_TAR) -C $(PKG_BUILD_DIR) --strip-components=1 -xf $(DL_DIR)/$(PKG_SOURCE)

define Package/poorbox
  SECTION:=base
  CATEGORY:=Base system
  TITLE:=A special version of BusyBox
  URL:=http://busybox.net/
  PKGARCH:=$(BOARD)_ndms
  PKG_DEFAULT_DEPENDS:=
endef

define Package/poorbox/description
 The Swiss Army Knife of embedded Linux.
 It slices, it dices, it makes Julian Fries.
endef

ifndef CONFIG_USE_MUSL
LDLIBS:=m
endif

LDLIBS += c gcc_pic

MAKE_VARS :=
MAKE_FLAGS += \
	EXTRA_CFLAGS="$(TARGET_CFLAGS) $(TARGET_CPPFLAGS)" \
	EXTRA_LDFLAGS="-static -Wl,--gc-sections" \
	LDLIBS="$(LDLIBS)" \
	LD="$(TARGET_CC)" \
	SKIP_STRIP=y

ifneq ($(findstring c,$(OPENWRT_VERBOSE)),)
  MAKE_FLAGS += V=1
endif

define Build/Compile
	$(call Build/Compile/Default, \
		CONFIG_PREFIX="$(PKG_INSTALL_DIR)/opt" \
		all \
	)
endef

BB_APPS:= \
	[ \
	ash \
	basename \
	cat cp cut \
	echo egrep \
	fgrep \
	grep gunzip gzip \
	head \
	ln lock logger ls \
	pgrep printf \
	readlink rm \
	sed sh sleep \
	tar \
	wget

define Package/poorbox/install
	$(INSTALL_DIR) $(1)/opt/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/busybox $(1)/opt/usr/bin

	for bb_apps in $(BB_APPS); do \
		$(LN) busybox $(1)/opt/usr/bin/"$$$$bb_apps"; \
	done
endef

$(eval $(call BuildPackage,poorbox))
