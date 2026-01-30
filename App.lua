local Lapis = require("lapis")
local date = require("date")

local App = Lapis.Application()
App.include = function(self, a)
	self.__class.include(self, a, nil, self)
end

App:enable("etlua")
App.layout = "layout"

App.cookie_attributes = function()
  local expires = date(true):adddays(6):fmt("${http}")
  return "Expires=" .. expires .. "; Path=/; HttpOnly"
end

App:include("apps.api")
App:include("apps.web")

return App