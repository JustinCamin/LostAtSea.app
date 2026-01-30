local Organizations = require("Models.organizations")
local Controller = {}  

function Controller.get(self)
	local Orgs = Organizations:select()

    if not Orgs then
        return { status = 400, json = { error = "Organizations not found." } }
    end

    return { status=200, json = { success = true, organizations = Orgs } }
end

function Controller.getOne(self)
	local Org = Organizations:find({id = tonumber(self.params.id)})
    if not Org then
        return { status = 400, json = { error = "Organization not found." } }
    end
    
    return { status=200, json = { success = true, organization = Org } }
end

return Controller