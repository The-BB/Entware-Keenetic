include $(TOPDIR)/rules.mk

PKG_NAME:=apk
PKG_RELEASE:=2

PKG_SOURCE_URL=https://gitlab.alpinelinux.org/alpine/apk-tools.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2025-02-08
PKG_SOURCE_VERSION:=34771ccb7964b0e7cb5d1fc64bd1b83fe73296ba
PKG_MIRROR_HASH:=fddd0334fa2ce7cc7fedb2cc95ee800caf9cbe43d617c2e612e2f58fc30b14c2

PKG_VERSION=3.0.0_pre$(subst -,,$(PKG_SOURCE_DATE))

PKG_MAINTAINER:=Paul Spooren <mail@aparcar.org>
PKG_LICENSE:=GPL-2.0-only
PKG_LICENSE_FILES:=LICENSE
PKG_INSTALL:=2

HOST_BUILD_PREFIX:=$(STAGING_DIR_HOST)
HOST_BUILD_DEPENDS:=lua/host

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/meson.mk

define Package/apk/default
  SECTION:=base
  CATEGORY:=Base system
  TITLE:=apk package manager
  DEPENDS:=+zlib +wget
  URL:=$(PKG_SOURCE_URL)
  PROVIDES:=apk
endef

define Package/apk-mbedtls
  $(Package/apk/default)
  TITLE += (mbedtls)
  DEPENDS +=+libmbedtls
  DEFAULT:=y if USE_APK
  VARIANT:=mbedtls
  DEFAULT_VARIANT:=1
  CONFLICTS:=apk-openssl
endef

define Package/apk-openssl
  $(Package/apk/default)
  TITLE += (openssl)
  DEPENDS +=+libopenssl
  VARIANT:=openssl
endef

# Entware specific(?)
# dso_dlfcn.c:(.text+0x13): undefined reference to `dlopen'
HOST_LDFLAGS += -ldl

MESON_HOST_VARS+=VERSION=$(PKG_VERSION)
MESON_VARS+=VERSION=$(PKG_VERSION)

MESON_COMMON_ARGS = \
	-Db_lto=true \
	-Dcompressed-help=false \
	-Ddocs=disabled \
	-Dhelp=enabled \
	-Dlua_version=5.1 \
	-Ddefault_library=static \
	-Durl_backend=wget \
	-Dzstd=false \
	-Dpython=disabled \
	-Dtests=disabled

MESON_HOST_ARGS += \
	$(MESON_COMMON_ARGS) \
	-Dcrypto_backend=openssl

MESON_ARGS += \
	$(MESON_COMMON_ARGS) \
	-Dcrypto_backend=$(BUILD_VARIANT)

define Package/apk/conffiles
/opt/etc/apk/repositories.d/customfeeds.list
endef

Package/apk-mbedtls/conffiles = $(Package/apk/conffiles)
Package/apk-openssl/conffiles = $(Package/apk/conffiles)

define Package/apk/default/install
	$(INSTALL_DIR) $(1)/opt/lib/apk/db

	$(INSTALL_DIR) $(1)/opt/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/opt/bin/apk $(1)/opt/bin/apk

	$(INSTALL_DIR) $(1)/opt/etc/apk/repositories.d
	$(INSTALL_DATA) ./files/customfeeds.list $(1)/opt/etc/apk/repositories.d/customfeeds.list
endef

Package/apk-mbedtls/install = $(Package/apk/default/install)
Package/apk-openssl/install = $(Package/apk/default/install)

$(eval $(call BuildPackage,apk-mbedtls))
$(eval $(call BuildPackage,apk-openssl))
$(eval $(call HostBuild))
