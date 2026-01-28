local Lapis = require("lapis")
local App = Lapis.Application()
App.__base  = App
App.include = function(self, a)
	self.__class.include(self, a, nil, self)
end

App:include("apps.web.pages")

return App