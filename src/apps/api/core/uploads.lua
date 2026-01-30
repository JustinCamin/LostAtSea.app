local ENV = require("lua-dotenv")
ENV.load_dotenv("./.env")

local mimetypes = require("mimetypes")

local Images = require("Models.images")
local Controller = {}  

function Controller.get(self)
	local Id = self.params.id 
	if not Id then
		return { status = false, json = { error = "No image id" } }
	end

	if Id == 0 then
		return {
        redirect_to = "http://localhost:8080/static/beachlanding.jpg"
    }
end

	local Image = Images:find({id = tonumber(Id)})
	if not Image then
		return { redirect_to = "http://localhost:8080/static/beachlanding.jpg" }
	end

	return {
        redirect_to = "http://localhost:8080" ..Image.path
    }
end

function Controller.post(self)

	if not self.session or not self.session.user then
		return { status = false, json = { error = "Unauthorized" } }
	end

	local File = self.params.file
	if not File then
		return { status = 12, json = { error = "No file uploaded" } }
	end

	local Extension = File.filename:match("^.+(%..+)$") or ""
	local Name = ngx.md5(File.filename .. ngx.now()) .. Extension
    print(Extension)

	local Path = ENV.get("UPLOAD_PATH").."/" .. Name

    
	if not Images:create({
		user_id = self.session.user.id,
		filename = File.filename,
		path = "/uploads/" .. Name,
		mime_type = mimetypes.guess(Name),
		created_at = os.date(),
	}) then
		return { status = false, json = { error = "Failed to save file metadata." } }
	end

	local f = assert(io.open(Path, "wb"))
	f:write(File.content)
	f:close()

	return { status = 200, json = { success = true, image_id = Images:find({filename = File.filename}).id } }
end

return Controller