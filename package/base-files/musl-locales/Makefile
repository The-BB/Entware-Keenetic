# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2024-2025 Entware

include $(TOPDIR)/rules.mk

PKG_NAME:=musl-locales
PKG_REAL_VERSION:=0.1.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2025-01-18
PKG_SOURCE_VERSION:=173065ec1733ca0f0212895584af640cd88d45ee
PKG_SOURCE_URL:=https://git.adelielinux.org/adelie/musl-locales
PKG_MIRROR_HASH:=20328279032316151ede97c71ba4831ccc7755b2c949db75822ab01b1d91bd30

PKG_VERSION:=$(PKG_REAL_VERSION)_git$(subst -,,$(PKG_SOURCE_DATE))~$(call version_abbrev,$(PKG_SOURCE_VERSION))

PKG_LICENSE:=LGPL-3.0-only MIT
PKG_LICENSE_FILES:=LICENSE LICENSE.MIT

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/musl-locales
  SECTION:=base
  CATEGORY:=Base system
  TITLE:=Locale program for musl libc
  URL:=https://git.adelielinux.org/adelie/musl-locales
  DEPENDS:=@USE_MUSL
endef

define Package/musl-locales/description
  Locale program for musl libc.
  cs_CZ - Fully translated.
  de_DE - Date/time strings only.
  en_GB - Messages translated where different from en_US.
  es_ES - Fully translated.
  fi_FI - Date/time strings only.
  fr_FR - Date/time strings only.
  it_IT - Date/time strings only.
  nb_NO - Date/time strings only.
  nl_NL - Date/time strings only.
  pt_BR - Fully translated.
  pt_PT - Fully translated.
  ru_RU - Fully translated.
  sr_RS - Fully translated.
  sv_SE - Date/time strings only.
endef

define Package/musl-locales/install
	$(INSTALL_DIR) $(1)/opt/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/opt/bin/locale $(1)/opt/bin
	$(INSTALL_DIR) $(1)/opt/etc/profile.d
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/opt/etc/profile.d/00locale.sh \
		$(1)/opt/etc/profile.d
	$(INSTALL_DIR) $(1)/opt/share
	$(CP) $(PKG_INSTALL_DIR)/opt/share/i18n $(1)/opt/share
endef

$(eval $(call BuildPackage,musl-locales))
