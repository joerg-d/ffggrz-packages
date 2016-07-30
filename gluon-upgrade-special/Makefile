# Copyright (C) 2016 Jörg Deckert <joergd at bitquell.de>
# This is free software, licensed under the Apache 2.0 license.

include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-upgrade-special
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GLUONDIR)/include/package.mk

define Package/gluon-upgrade-special
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Upgrade special
  DEPENDS:=+gluon-core
endef

define Package/gluon-upgrade-special/description
	Do special things during upgrades.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/gluon-upgrade-special/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,gluon-upgrade-special))
