local Config = require("lapis.config")
local ENV = require("lua-dotenv")
ENV.load_dotenv("./.env")

package.path = "/home/justin/App/src/?.lua;/home/justin/App/src/?/init.lua;" .. package.path

Config("development", {
	postgres = {
		host = "127.0.0.1",
		port = "5433",
		user = "justin",
		password = ENV.get("MYSQL_PASSWORD"),
		database = "lostatsea",
	},

	site_name = "[DEVE] LostAtSea",
	server = "nginx",
	code_cache = "off",
	num_workers = "1",
})
