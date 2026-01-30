local ENV = require("lua-dotenv")
ENV.load_dotenv("./.env")

local Model = require("Models.users")
local Sessions = require("Models.sessions")
local Bcrypt = require("bcrypt")
local uuid = require("resty.uuid")
local JWT = require("resty.jwt")

local Controller = {}  

local function ValidateUser(type, info)
    return Model:find({[type] = info})
end


function Controller.get(self)

    local User = ValidateUser("id", self.params.id)
    if not User then
        return { status = 400, json = { error = "Account not found." } }
    end

    return { status=200, json = { success = true, user = {
        id = User.id,
        created_at = User.created_at,
        email = User.email,
        name = User.name,
        avatar_image_id = User.avatar_image_id,
        organization = User.organization,
        admin = User.admin,
    } } }
end

function Controller.signup(self)
	
    print("GOT HEER")
    if ValidateUser("email", self.params.email) then
        return { status = 400, json = { error = "Email already in use." } }
    end

    self.params.password = Bcrypt.digest(self.params.password, 12)
    print(self.params.password)
    return { status = 200, json = { success = true, user = Model:create(self.params) } }
end

function Controller.login(self)
	
    print(self.params.password)

    if self.cookies.access_token then
        return { status = 400, json = { error = "Already logged in." } }
    end

    local User = ValidateUser("email", self.params.email)
    if not User then
        return { status = 400, json = { error = "Account not found." } }
    end

    if not Bcrypt.verify(self.params.password, User.password) then
        return { status = 400, json = { error = "Invalid credentials." } }
    end

    local Token = uuid.generate()
    Sessions:create({
        expires_at = os.date("%Y-%m-%d %H:%M:%S", os.time() + (7 * 24 * 60 * 60)),
        user_id = User.id, 
        token = Token, 
    })

    local TokenLoad = JWT:sign("silly bob", {
        payload = {
            token = Token, 
            expires = os.time() + (7 * 24 * 60 * 60)
        },
        header = { typ = "JWT", alg = "HS256" }
      })

    self.cookies.access_token = TokenLoad
    self.session.user = User

    return { status = 200, json = { success = true } }
end

return Controller