return function(self)

	self.page_title = "Report"

	self.Organizations = require("apps.api.core.organizations").get().json.organizations
	if self.params.organization then

		self.params.id = self.params.organization
		self.Organization = require("apps.api.core.organizations").getOne(self).json.organization
	end

	return { render = "pages.report" }
end