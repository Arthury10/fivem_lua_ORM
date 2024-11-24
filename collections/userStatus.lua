DB.Collections.UserStatus = DB.Collections.UserStatus or {}

function DB.Collections.UserStatus:GetByIdentifier(identifier, includes)
  local cacheKey = "user_status:" .. identifier
  local cachedUser = DB.Core.Cache:Get(cacheKey)
  if cachedUser then
    return cachedUser
  end

  local userStatusData = nil

  local result = DB.Core.Crud:Select(DB.Core.Config.tables.user_status, nil, { identifier = identifier })

  if result and result[1] then
    userStatusData = result[1]
  else
    return
  end

  if includes then
    for _, include in ipairs(includes) do
      if DB.Core.Config.relations.user_status[include] then
        local relation = DB.Core.Config.relations.user_status[include]
        local tableRelation = DB.Core.Crud:Select(relation.table, nil, { [relation.key] = identifier })
        userStatusData[include] = tableRelation
      end
    end
  end

  if userStatusData then
    local userStatus = DB.Models.UserStatus:new(userStatusData)
    DB.Core.Cache:Set(cacheKey, userStatus)
    return userStatus
  end
  return nil
end

function DB.Collections.UserStatus:Update(identifier, data)
  DB.Core.Crud:Update(DB.Core.Config.tables.user_status, data, { identifier = identifier })
  DB.Core.Cache:Invalidate("user_status:" .. identifier)
  local userStatus = DB.Models.UserStatus:new(data)
  DB.Core.Cache:Set("user_status:" .. identifier, userStatus)
  return userStatus
end

function DB.Collections.UserStatus:Delete(identifier)
  DB.Core.Crud:Delete(DB.Core.Config.tables.user_status, { identifier = identifier })
  DB.Core.Cache:Invalidate("user_status:" .. identifier)
end

function DB.Collections.UserStatus:Create(data)
  DB.Core.Crud:Insert(DB.Core.Config.tables.user_status, data)

  local userStatus = DB.Models.UserStatus:new(data)
  DB.Core.Cache:Set("user_status:" .. data.identifier, userStatus)
  return userStatus
end
