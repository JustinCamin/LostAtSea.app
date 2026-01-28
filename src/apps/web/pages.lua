local Lapis = require("lapis")
local App = Lapis.Application()
App.__base  = App
App.name = "web.pages."

App:match("index", "/", require("apps.web.pages.index"))

return App
