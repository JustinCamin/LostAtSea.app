local Lapis = require("lapis")
local R2      = require("lapis.application").respond_to
local App = Lapis.Application()
App.__base = App

App:post("/api/signup", require("apps.api.core.accounts").signup)
App:post("/api/login", require("apps.api.core.accounts").login)

App:post("/api/upload", require("apps.api.core.uploads").post)
App:get("/api/images/:id", require("apps.api.core.uploads").get)

App:get("/api/organizations", require("apps.api.core.organizations").get)

App:get("/api/reports", require("apps.api.core.reports").get)
App:post("/api/reports", require("apps.api.core.reports").post)
App:post("/api/reports/approve", require("apps.api.core.reports").approve)

return App