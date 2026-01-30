local Reports = require("Models.reports")
local Controller = {}  

function Controller.post(self)
    if not self.session or not self.session.user then
		return { status = false, json = { error = "Unauthorized" } }
	end

	local Report = Reports:create{
        type = self.params.type,
        name = self.params.name,
        description = self.params.description,
        item_image_id = self.params.image_id,
        reported_at = os.date(),
        is_approved = false,
        organization_id = tonumber(self.params.organization),
    }

    if not Report then
        return { status = 400, json = { error = "Report could not be created." } }
    end

    return { status=200, json = { success = true, reports = Report } }
end

function Controller.get(self)
	local Report = Reports:find_all({tonumber(self.params.id)}, {key="organization_id", where = { is_approved = true}})
    if not Report then
        return { status = 400, json = { error = "Reports not found." } }
    end

    return { status=200, json = { success = true, reports = Report } }
end

function Controller.approve(self)
	local Report = Reports:find({id = self.params.id})

    if not Report then
        return { status = 400, json = { error = "Report not found." } }
    end

    Report:update({is_approved = true})

    return { status=200, json = { success = true, reports = Report } }
end

function Controller.getUnapproved(self)
	local Report = Reports:find_all({tonumber(self.params.id)}, {key="organization_id", where = { is_approved = false}})
    if not Report then
        return { status = 400, json = { error = "Reports not found." } }
    end

    return { status=200, json = { success = true, reports = Report } }
end

return Controller