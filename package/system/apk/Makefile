include $(TOPDIR)/rules.mk

PKG_NAME:=apk
PKG_RELEASE:=1

PKG_SOURCE_URL=https://gitlab.alpinelinux.org/alpine/apk-tools.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2024-08-06
PKG_SOURCE_VERSION:=54caa31be633efc5f655700b77af290124f71689
PKG_MIRROR_HASH:=f3be762deac4f1469a4a2839691175e78019cb44295089befafa279a3390067c

PKG_VERSION=3.0.0_pre$(subst -,,$(PKG_SOURCE_DATE))

PKG_MAINTAINER:=Paul Spooren <mail@aparcar.org>
PKG_LICENSE:=GPL-2.0-only
PKG_LICENSE_FILES:=LICENSE
PKG_INSTALL:=1

HOST_BUILD_PREFIX:=$(STAGING_DIR_HOST)
HOST_BUILD_DEPENDS:=lua/host

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/meson.mk

define Package/apk/default
  SECTION:=base
  CATEGORY:=Base system
  TITLE:=apk package manager
  DEPENDS:=+zlib
  URL:=$(PKG_SOURCE_URL)
  PROVIDES:=apk
endef

define Package/apk-mbedtls
  $(Package/apk/default)
  TITLE += (mbedtls)
  DEPENDS +=+libmbedtls
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

MESON_HOST_VARS+=VERSION=$(PKG_VERSION)
MESON_VARS+=VERSION=$(PKG_VERSION)

MESON_HOST_ARGS += \
	-Dcompressed-help=false \
	-Ddocs=disabled \
	-Dcrypto_backend=openssl \
	-Dzstd=false

MESON_ARGS += \
	-Dlua_version=5.1 \
	-Dcompressed-help=false \
	-Ddocs=disabled \
	-Durl_backend=wget \
	-Dcrypto_backend=$(BUILD_VARIANT) \
	-Dzstd=false

HOST_LDFLAGS += \
	-Wl,-rpath $(STAGING_DIR_HOST)/lib \
	-ldl

define Package/apk/default/install
	$(INSTALL_DIR) $(1)/opt/lib/apk/db

	$(INSTALL_DIR) $(1)/opt/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/opt/bin/apk $(1)/opt/bin/apk

	$(INSTALL_DIR) $(1)/opt/lib
	$(CP) $(PKG_INSTALL_DIR)/opt/lib/libapk.so.* $(1)/opt/lib/
endef

Package/apk-mbedtls/install = $(Package/apk/default/install)
Package/apk-openssl/install = $(Package/apk/default/install)

$(eval $(call BuildPackage,apk-mbedtls))
$(eval $(call BuildPackage,apk-openssl))
$(eval $(call HostBuild))
