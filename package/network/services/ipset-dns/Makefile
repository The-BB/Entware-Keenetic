#
# Copyright (C) 2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ipset-dns
PKG_RELEASE:=2

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://git.zx2c4.com/ipset-dns
PKG_SOURCE_DATE:=2017-10-08
PKG_SOURCE_VERSION:=ade2cf88e933f4f90451e0a6171f0aa4a523f989
PKG_MIRROR_HASH:=94478078566bb8ddd76063607780f899646eacd2414e60d799231ff9391ce540
PKG_MAINTAINER:=Jo-Philipp Wich <jo@mein.io>

PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=COPYING

include $(INCLUDE_DIR)/package.mk

define Package/ipset-dns/Default
endef

define Package/ipset-dns
  SECTION:=net
  CATEGORY:=Network
  TITLE:=A lightweight DNS forwarder to populate ipsets
  URL:=http://git.zx2c4.com/ipset-dns/about/
  DEPENDS:=+libmnl
endef

define Package/ipset-dns/description
 The ipset-dns daemon is a lightweight DNS forwarding server that adds all
 resolved IPs to a given netfilter ipset. It is designed to be used in
 conjunction with dnsmasq's upstream server directive.

 Practical use cases include routing over a given gateway traffic for
 particular web services or webpages that do not have a priori predictable
 IP addresses and instead rely on dizzying arrays of DNS resolutions.
endef


define Package/ipset-dns/install
	$(INSTALL_DIR) $(1)/opt/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ipset-dns $(1)/opt/sbin/ipset-dns
endef

$(eval $(call BuildPackage,ipset-dns))
