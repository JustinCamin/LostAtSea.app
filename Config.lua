local Config = require("lapis.config")

package.path = "/home/justin/App/src/?.lua;/home/justin/App/src/?/init.lua"

Config("development", {
	site_name = "[DEVE] LostAtSea",
	--lua_path = lua_path,
	--lua_cpath = lua_cpath,
	server = "nginx",
	code_cache = "off",
	num_workers = "1",
})
