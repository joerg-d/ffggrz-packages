local uci = require("simple-uci").cursor()
local lutil = require "gluon.web.util"
local fs = require "nixio.fs"

local site = require 'gluon.site_config'
local sysconfig = require 'gluon.sysconfig'
local util = require "gluon.util"

local pretty_hostname = require 'pretty_hostname'



local has_fastd = fs.access('/lib/gluon/mesh-vpn/fastd')
local has_tunneldigger = fs.access('/lib/gluon/mesh-vpn/tunneldigger')
local fastd_enabled = uci:get_bool("fastd", "mesh_vpn", "enabled")
local tunneldigger_enabled = uci:get_bool("tunneldigger", "mesh_vpn", "enabled")

local hostname = pretty_hostname.get(uci)
local contact = uci:get_first("gluon-node-info", "owner", "contact")

local pubkey
local msg


if has_fastd or has_tunneldigger then
	if not fastd_enabled then
		if not tunneldigger_enabled then
			msg = _translate('gluon-config-mode:novpn')
		end
	end
end
if has_fastd and fastd_enabled then
	pubkey = util.trim(lutil.exec("/etc/init.d/fastd show_key mesh_vpn"))
	msg = _translate('gluon-config-mode:pubkey')
end

if not msg then return end

renderer.render_string(msg, {
	pubkey = pubkey,
	hostname = hostname,
	site = site,
	sysconfig = sysconfig,
	contact = contact,
})
