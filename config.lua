local Config = require("lapis.config")
local ENV = require("lua-dotenv")
ENV.load_dotenv("./.env")

package.path = ENV.get("PACKAGE_PATH") .. package.path

Config("development", {
	postgres = {
		host = "127.0.0.1",
		port = ENV.get("PORT"),
		user = "justin",
		password = ENV.get("MYSQL_PASSWORD"),
		database = "lostatsea",
	},

	site_name = "[DEVE] LostAtSea",
	server = "nginx",
	code_cache = "off",
	num_workers = "1",
})
