local schema = require("lapis.db.schema")
local types = schema.types

return {
  [1769736036] = function()
    schema.create_table("users", {
			{ "id", types.serial },
			{ "name", types.text },
      { "password", types.varchar },

			"PRIMARY KEY (id)",
		})
  end,
  [1769739065] = function()
    schema.add_column("users", "email", types.varchar)
    schema.add_column("users", "image", types.foreign_key)
  end,
  [1769739250] = function()
    schema.create_table("images", {
			{ "id", types.serial },
			{ "user_id", types.integer },
      { "filename", types.text },
      { "path", types.text },
      { "mime_type", types.text },
      { "size", types.integer },
      { "created_at", types.time },

			"PRIMARY KEY (id)",
      "FOREIGN KEY (user_id) REFERENCES users(id)"
		})

    schema.create_index("images", "user_id")

    schema.drop_column("users", "password")
    schema.drop_column("users", "image")
    schema.add_column("users", "password", types.text)
    schema.add_column("users", "avatar_image_id", types.integer({null = true}))

    schema.create_index("users", "avatar_image_id")
  end,
  [1769756546] = function()
        schema.create_table("organizations", {
			{ "id", types.serial },
			{ "name", types.text },
      { "description", types.text },
      { "address", types.text },
      { "type", types.text },
      { "organization_image_id", types.integer },

			"PRIMARY KEY (id)",
		})

    schema.create_table("reports", {
			{ "id", types.serial },
			{ "name", types.text },
      { "description", types.text },
      { "type", types.text },
      { "item_image_id", types.integer },
      { "reported_at", types.time },
      { "is_approved", types.boolean },
      { "organization_id", types.integer },

			"PRIMARY KEY (id)",
      "FOREIGN KEY (organization_id) REFERENCES organizations(id)"
		})

    schema.add_column("users", "organization", types.text)
  end,
  [1769757809] = function()

    schema.drop_column("reports", "organization_id")
    schema.add_column("reports", "organization_id", types.integer({null = true}))
  end,
  [1769758058] = function()
    schema.create_table("sessions", {
			{ "id", types.serial },
			{ "expires_at", types.time },
      { "user_id", types.integer },
      { "token", types.text },

			"PRIMARY KEY (id)",
      "FOREIGN KEY (user_id) REFERENCES users(id)"
		})
  end,
  [1769758401] = function()
    schema.drop_column("reports", "organization_id")
    schema.add_column("reports", "organization_id", types.integer({null = true}))
  end,
  [1769758470] = function()
    schema.drop_column("reports", "organization_id")
    schema.add_column("reports", "organization_id", types.integer)

    schema.drop_column("users", "organization")
    schema.add_column("users", "organization_id", types.integer({null = true}))
  end,
  [1769758762] = function()
    schema.drop_column("images", "size")
  end,
  [1769771827] = function()
    schema.add_column("users", "admin", types.boolean({null = true}))
  end
}
