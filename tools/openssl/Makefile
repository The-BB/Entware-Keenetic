#
# Copyright (C) 2018-2025 Entware
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=openssl
PKG_VERSION:=3.5.0
PKG_RELEASE:=1

PKG_BASE:=$(subst $(space),.,$(wordlist 1,2,$(subst .,$(space),$(PKG_VERSION))))
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:= \
	https://www.openssl.org/source/ \
	https://www.openssl.org/source/old/$(PKG_BASE)/ \
	https://github.com/openssl/openssl/releases/download/$(PKG_NAME)-$(PKG_VERSION)/

PKG_HASH:=344d0a79f1a9b08029b0744e2cc401a43f9c90acd1044d09a530b4885a8e9fc0

PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE
PKG_CPE_ID:=cpe:/a:openssl:openssl

HOST_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/host-build.mk

# default target is gcc if we don't know the host system
OPENSSL_TARGET:=gcc
ifeq ($(HOST_OS),Darwin)
OPENSSL_TARGET:=darwin-$(HOST_ARCH)-cc
endif
ifeq ($(HOST_OS),Linux)
OPENSSL_TARGET:=linux-$(HOST_ARCH)
endif

ifneq ($(CONFIG_CCACHE),)
HOSTCC=$(HOSTCC_NOCACHE)
HOSTCXX=$(HOSTCXX_NOCACHE)
endif

HOST_CFLAGS += $(HOST_FPIC)

OPENSSL_OPTIONS:= no-engine no-shared zlib

OPENSSL_OPTIONS += \
	no-aria no-async no-blake2 no-camellia no-idea no-mdc2 no-rfc3779 \
	no-seed no-sm2 no-sm3 no-sm4 no-sse2 no-tests no-whirlpool 

define Host/Configure
	(cd $(HOST_BUILD_DIR); \
		./Configure $(OPENSSL_TARGET) \
		--prefix=$(STAGING_DIR_HOST) \
		--libdir=lib \
		$(HOST_CPPFLAGS) \
		$(HOST_LDFLAGS) \
		$(OPENSSL_OPTIONS) \
	)
endef

define Host/Compile
	+$(MAKE) $(PKG_JOBS) -C $(HOST_BUILD_DIR) \
		CC="$(HOSTCC)" \
		install_dev
endef

define Host/Install
	:
endef

$(eval $(call HostBuild))
