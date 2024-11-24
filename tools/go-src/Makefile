# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2016-2024 Entware

include $(TOPDIR)/rules.mk

PKG_NAME:=go-src
PKG_VERSION:=1.23.3
PKG_RELEASE:=1

PKG_SOURCE:=go$(PKG_VERSION).src.tar.gz
PKG_SOURCE_URL:=\
		https://dl.google.com/go/ \
                https://mirrors.ustc.edu.cn/golang/ \
                https://mirrors.nju.edu.cn/golang/
PKG_HASH:=8d6a77332487557c6afa2421131b50f83db4ae3c579c3bc72e670ee1f6968599

HOST_BUILD_DIR:=$(STAGING_DIR_HOST)/go

# broken: make -j$(nproc): `bash: line 1: Entering: command not found`
#BOOTSTRAP_VERSION:= \
#	$(shell make --no-print-directory -C ../go-bootstrap/ val.BOOTSTRAP_VERSION V=s)
BOOTSTRAP_VERSION:= \
	$(shell grep '^PKG_VERSION' ../go-bootstrap/Makefile | cut -d= -f2 | cut -b-4 )

include $(INCLUDE_DIR)/host-build.mk

define Host/Configure
endef

define Host/Compile
	( cd $(STAGING_DIR_HOST)/go/src; \
		GOROOT_BOOTSTRAP=$(STAGING_DIR_HOST)/go$(BOOTSTRAP_VERSION) \
		./make.bash; \
	)
	( cd $(STAGING_DIR_HOST)/bin; \
		for bins in go gofmt; do ln -nsf ../go/bin/$$$$bins $$$$bins; done \
	)
endef

define Host/Install
endef

define Host/Clean
	rm -f $(STAGING_DIR_HOST)/bin/go{,fmt}
	rm -rf $(STAGING_DIR_HOST)/go
endef

$(eval $(call HostBuild))
