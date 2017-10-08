include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-web-mesh-vpn-select
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include ../gluon.mk

PKG_CONFIG_DEPENDS += $(GLUON_I18N_CONFIG)


define Package/gluon-web-mesh-vpn-fastd
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=gluon-web module to select the type of mesh VPN
  DEPENDS:=+gluon-web-admin +gluon-mesh-vpn-fastd +gluon-mesh-vpn-tunneldigger
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GluonBuildI18N,gluon-mesh-vpn-fastd,gluon-mesh-vpn-tunneldigger,i18n)
	$(call GluonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/gluon-web-mesh-vpn-select/install
	$(CP) ./files/* $(1)/
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
	$(call GluonInstallI18N,gluon-mesh-vpn-fastd,gluon-mesh-vpn-tunneldigger,$(1))
endef

$(eval $(call BuildPackage,gluon-web-mesh-vpn-fastd,gluon-web-mesh-vpn-tunneldigger))
