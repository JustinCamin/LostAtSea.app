return function(self)

	self.page_title = "Approval"

    self.Organizations = require("apps.api.core.organizations").get().json.organizations
	if self.params.organization then

		self.params.id = self.params.organization
		self.Organization = require("apps.api.core.organizations").getOne(self).json.organization
		self.Reports = require("apps.api.core.reports").getUnapproved(self).json.reports
	end

	return { render = "pages.approval" }
end