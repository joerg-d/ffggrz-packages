local uci = require("simple-uci").cursor()
local util = gluon.web.util

local f = Form(translate('Mesh VPN'))

local s = f:section(Section)

local mode = s:option(Value, 'mode')
mode.template = "gluon/model/mesh-vpn-select"

if uci:get_bool('tunneldigger', 'mesh_vpn', 'enabled') then
	mode.default = 'performance'
else
	mode.default = 'security'
end

function mode:write(data)

	if data == 'performance' then
		uci:set("fastd", "mesh_vpn", "enabled", false)
		uci:set("tunneldigger", "mesh_vpn", "enabled", true)
	else
		uci:set("fastd", "mesh_vpn", "enabled", true)
		uci:set("tunneldigger", "mesh_vpn", "enabled", false)
	end

	uci:save('fastd')
	uci:commit('fastd')
	uci:save('tunneldigger')
	uci:commit('tunneldigger')
end

return f
