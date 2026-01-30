local Bcrypt = require("bcrypt")
local uuid = require("resty.uuid")
local JWT = require("resty.jwt")

local Sessions = require("Models.sessions")

return function(self)
  local Token = self.cookies.access_token
  if not Token then
    return
  end

  local JWTObject = JWT:verify("silly bob", Token)
   if not JWTObject.verified or JWTObject.payload.expires < os.time() then
        self.cookies.access_token = nil
        return false, JWTObject
    end

    local Session = Sessions:find({token = JWTObject.payload.token})
    if not Session then
        return false
    end

    self.session.user = require("apps.api.core.accounts").get({ params = { id = Session.user_id } }).json.user
end