DB.Collections.User = DB.Collections.User or {}

function DB.Collections.User:GetByIdentifier(identifier, includes)
  local cacheKey = "user:" .. identifier
  local cachedUser = DB.Core.Cache:Get(cacheKey)
  if cachedUser then
    return cachedUser
  end

  local userData = nil

  local result = DB.Core.Crud:Select(DB.Core.Config.tables.users, nil, { identifier = identifier })

  if result and result[1] then
    userData = result[1]
  else
    return
  end

  if includes then
    for _, include in ipairs(includes) do
      if DB.Core.Config.relations.user[include] then
        local relation = DB.Core.Config.relations.user[include]
        local tableRelation = DB.Core.Crud:Select(relation.table, nil, { [relation.key] = identifier })
        userData[include] = tableRelation
      end
    end
  end

  if userData then
    local user = DB.Models.User:new(userData)
    DB.Core.Cache:Set(cacheKey, user)
    return user
  end
  return nil
end

function DB.Collections.User:Update(identifier, data)
  DB.Core.Crud:Update(DB.Core.Config.tables.users, data, { identifier = identifier })
  DB.Core.Cache:Invalidate("user:" .. identifier) -- Remove o cache antigo
  local user = DB.Models.User:new(data)
  DB.Core.Cache:Set("user:" .. identifier, user)  -- Armazena o novo cache
  return user
end

function DB.Collections.User:Delete(identifier)
  DB.Core.Crud:Delete(DB.Core.Config.tables.users, { identifier = identifier })
  DB.Core.Cache:Invalidate("user:" .. identifier)
end

function DB.Collections.User:Create(data)
  DB.Core.Crud:Insert(DB.Core.Config.tables.users, data)

  -- Cria um novo objeto UserModel
  local user = DB.Models.User:new(data)
  DB.Core.Cache:Set("user:" .. data.identifier, user) -- Armazena no cached
  return user
end
