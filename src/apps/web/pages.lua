local Lapis = require("lapis")
local App = Lapis.Application()
App.__base  = App
App.name = "web.pages."

App:before_filter(require("apps.web.internal.check_auth"))

App:match("index", "/", require("apps.web.pages.index"))
App:match("home", "/home", require("apps.web.pages.index"))
App:match("search", "/search", require("apps.web.pages.search"))
App:match("approval", "/approval", require("apps.web.pages.approval"))
App:match("report", "/report", require("apps.web.pages.report"))
App:match("login", "/login", require("apps.web.pages.login"))
App:match("signup", "/signup", require("apps.web.pages.signup"))

return App
