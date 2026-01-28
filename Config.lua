local Config = require("lapis.config")

Config("development", {
  server = "nginx",
  code_cache = "off",
  num_workers = "1"
})
