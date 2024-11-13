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
PKG_VERSION:=1.36.1
PKG_RELEASE:=2

PKG_SOURCE:=busybox-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://www.busybox.net/downloads \
		http://sources.buildroot.net
PKG_HASH:=b8cc24c9574d809e7279c3be349795c5d5ceb6fdf19ca709f80cde50e47de314

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
	ln lock ls \
	readlink rm \
	sed sh \
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
