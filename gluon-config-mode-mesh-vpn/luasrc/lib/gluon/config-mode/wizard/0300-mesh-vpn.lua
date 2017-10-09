local fs = require "nixio.fs"

local has_fastd = fs.access('/lib/gluon/mesh-vpn/fastd')
local has_tunneldigger = fs.access('/lib/gluon/mesh-vpn/tunneldigger')

return function(form, uci)
	if not (has_fastd or has_tunneldigger) then
		return
	end

local fastd_enabled = uci:get_bool('fastd', 'mesh_vpn', 'enabled')
local tunneldigger_enabled = uci:get_bool('tunneldigger', 'mesh_vpn', 'enabled')

	local msg = translate(
		'Your internet connection can be used to establish a ' ..
	        'VPN connection with other nodes. ' ..
	        'Enable this option if there are no other nodes reachable ' ..
	        'over WLAN in your vicinity or you want to make a part of ' ..
	        'your connection\'s bandwidth available for the network. You can limit how ' ..
	        'much bandwidth the node will use at most.'
	)

	local s = form:section(Section, nil, msg)

	local o

	local meshvpn = s:option(Flag, "meshvpn", translate("Use internet connection (mesh VPN)"))
	meshvpn.default = fastd_enabled or tunneldigger_enabled
	function meshvpn:write(data)
		if has_fastd then
			if has_tunneldigger and tunneldigger_enabled then
				uci:set("fastd", "mesh_vpn", "enabled", "0")
			else
				uci:set("fastd", "mesh_vpn", "enabled", data)
			end
		end
		if has_tunneldigger then
			if has_fastd and fastd_enabled then
				uci:set("tunneldigger", "mesh_vpn", "enabled", "0")
			else
				uci:set("tunneldigger", "mesh_vpn", "enabled", data)
			end
		end
	end

	local limit = s:option(Flag, "limit_enabled", translate("Limit bandwidth"))
	limit:depends(meshvpn, true)
	limit.default = uci:get_bool("simple-tc", "mesh_vpn", "enabled")
	function limit:write(data)
		uci:set("simple-tc", "mesh_vpn", "interface")
		uci:set("simple-tc", "mesh_vpn", "enabled", data)
		uci:set("simple-tc", "mesh_vpn", "ifname", "mesh-vpn")
	end

	o = s:option(Value, "limit_ingress", translate("Downstream (kbit/s)"))
	o:depends(limit, true)
	o.default = uci:get("simple-tc", "mesh_vpn", "limit_ingress")
	o.datatype = "uinteger"
	function o:write(data)
		uci:set("simple-tc", "mesh_vpn", "limit_ingress", data)
	end

	o = s:option(Value, "limit_egress", translate("Upstream (kbit/s)"))
	o:depends(limit, true)
	o.default = uci:get("simple-tc", "mesh_vpn", "limit_egress")
	o.datatype = "uinteger"
	function o:write(data)
		uci:set("simple-tc", "mesh_vpn", "limit_egress", data)
	end

	return {'fastd', 'tunneldigger', 'simple-tc'}
end
