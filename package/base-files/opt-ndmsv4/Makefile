# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2024 Entware

include $(TOPDIR)/rules.mk

PKG_NAME:=opt-ndmsv4
PKG_VERSION:=0.0.2
PKG_RELEASE:=2

PKG_MAINTAINER:=Entware team, http://entware.net

PKG_FLAGS:=essential

include $(INCLUDE_DIR)/package.mk

define Package/opt-ndmsv4
  SECTION:=base
  CATEGORY:=Base system
  DEPENDS:=+entware-release +findutils +ldconfig \
	+libc +libgcc +libstdcpp +opkg +terminfo \
	+USE_GLIBC:locales \
	+USE_GLIBC:zoneinfo-asia \
	+USE_GLIBC:zoneinfo-europe
  TITLE:=Base filesystem for NDMS 4.x
  ifneq (,$(filter aarch64 mips mipsel,$(ARCH)))
	PKGARCH:=$(BOARD)_ndms
  endif
endef

define Package/opt-ndmsv4/description
  opt-ndmsv4 is a metapackage to install Entware basic libraries and
  scripts on Keenetic routers.
endef

Build/Prepare:=:
Build/Configure:=:
Build/Compile:=:

define Package/opt-ndmsv4/conffiles
/opt/etc/group
/opt/etc/passwd
/opt/etc/profile
/opt/etc/shadow
/opt/etc/shells
/opt/root/.profile
endef

define Package/opt-ndmsv4/install
	mkdir -p \
	$(1)/opt/bin \
	$(1)/opt/etc/init.d \
	$(1)/opt/etc/iproute2 \
	$(1)/opt/etc/ld.so.conf.d \
	$(1)/opt/etc/ndm/button.d \
	$(1)/opt/etc/ndm/fs.d \
	$(1)/opt/etc/ndm/ifcreated.d \
	$(1)/opt/etc/ndm/ifdestroyed.d \
	$(1)/opt/etc/ndm/ifip6changed.d \
	$(1)/opt/etc/ndm/ifipchanged.d \
	$(1)/opt/etc/ndm/iflayerchanged.d \
	$(1)/opt/etc/ndm/ifstatechanged.d \
	$(1)/opt/etc/ndm/l2tp_ipsec_vpn_down.d \
	$(1)/opt/etc/ndm/l2tp_ipsec_vpn_up.d \
	$(1)/opt/etc/ndm/neighbour.d \
	$(1)/opt/etc/ndm/netfilter.d \
	$(1)/opt/etc/ndm/openvpn-client-connect.d \
	$(1)/opt/etc/ndm/openvpn-client-disconnect.d \
	$(1)/opt/etc/ndm/openvpn-down.d \
	$(1)/opt/etc/ndm/openvpn-ipchange.d \
	$(1)/opt/etc/ndm/openvpn-learn-address.d \
	$(1)/opt/etc/ndm/openvpn-route-up.d \
	$(1)/opt/etc/ndm/openvpn-tls-verify.d \
	$(1)/opt/etc/ndm/openvpn-up.d \
	$(1)/opt/etc/ndm/pptp_vpn_down.d \
	$(1)/opt/etc/ndm/pptp_vpn_up.d \
	$(1)/opt/etc/ndm/schedule.d \
	$(1)/opt/etc/ndm/sms.d \
	$(1)/opt/etc/ndm/sstp_vpn_down.d \
	$(1)/opt/etc/ndm/sstp_vpn_up.d \
	$(1)/opt/etc/ndm/time.d \
	$(1)/opt/etc/ndm/usb.d \
	$(1)/opt/etc/ndm/user.d \
	$(1)/opt/etc/ndm/vip_vpn_down.d \
	$(1)/opt/etc/ndm/vip_vpn_up.d \
	$(1)/opt/etc/ndm/wan.d \
	$(1)/opt/etc/profile.d \
	$(1)/opt/etc/skel \
	$(1)/opt/home \
	$(1)/opt/lib \
	$(1)/opt/libexec \
	$(1)/opt/sbin \
	$(1)/opt/share \
	$(1)/opt/srv \
	$(1)/opt/usr/bin \
	$(1)/opt/usr/lib \
	$(1)/opt/usr/sbin \
	$(1)/opt/usr/share \
	$(1)/opt/var/cache \
	$(1)/opt/var/lib \
	$(1)/opt/var/lock \
	$(1)/opt/var/log \
	$(1)/opt/var/run \
	$(1)/opt/var/spool

	mkdir -p -m 0750 $(1)/opt/root
	mkdir -p -m 1777 $(1)/opt/tmp

	$(INSTALL_BIN) ./files/rc.unslung $(1)/opt/etc/init.d
	$(INSTALL_DATA) ./files/rc.func $(1)/opt/etc/init.d
	$(INSTALL_DATA) ./files/{group,ld.so.conf,passwd,profile,shadow,shells} \
		$(1)/opt/etc
	$(INSTALL_DATA) ./files/libc.conf $(1)/opt/etc/ld.so.conf.d
	$(INSTALL_DATA) ./files/mc.sh $(1)/opt/etc/profile.d
	$(INSTALL_DATA) ./files/.{inputrc,profile} $(1)/opt/etc/skel
	$(INSTALL_DATA) ./files/functions.sh $(1)/opt/lib
	$(INSTALL_DATA) ./files/.{inputrc,profile} $(1)/opt/root
	$(INSTALL_BIN) ./files/reboot.sh $(1)/opt/sbin

	chmod 0600 $(1)/opt/etc/shadow
endef

$(eval $(call BuildPackage,opt-ndmsv4))
