local Config = require("lapis.config")

package.path = "/home/justin/App/src/?.lua;/home/justin/App/src/?/init.lua"

Config("development", {
	site_name = "[DEVE] LostAtSea",
	server = "nginx",
	code_cache = "off",
	num_workers = "1",
})
