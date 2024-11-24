DB.Collections.UserInventory = DB.Collections.UserInventory or {}

function DB.Collections.UserInventory:GetByIdentifier(identifier, includes)
  local cacheKey = "user_inventory:" .. identifier
  local cachedUserInventory = DB.Core.Cache:Get(cacheKey)
  if cachedUserInventory then
    return cachedUserInventory
  end

  local userInventoryData = nil

  local result = DB.Core.Crud:Select(DB.Core.Config.tables.user_inventory, nil, { identifier = identifier })

  if result and result[1] then
    userInventoryData = result[1]
  else
    return
  end

  if includes then
    for _, include in ipairs(includes) do
      if DB.Core.Config.relations.user_status[include] then
        local relation = DB.Core.Config.relations.user_status[include]
        local tableRelation = DB.Core.Crud:Select(relation.table, nil, { [relation.key] = identifier })
        userInventoryData[include] = tableRelation
      end
    end
  end

  if userInventoryData then
    local userInventory = DB.Models.UserInventory:new(userInventoryData)
    DB.Core.Cache:Set(cacheKey, userInventory)
    return userInventory
  end
  return nil
end

function DB.Collections.UserInventory:Update(identifier, data)
  DB.Core.Crud:Update(DB.Core.Config.tables.user_inventory, data, { identifier = identifier })
  DB.Core.Cache:Invalidate("user_inventory:" .. identifier)
  local userInventory = DB.Models.UserInventory:new(data)
  DB.Core.Cache:Set("user_inventory:" .. identifier, userInventory)
  return userInventory
end

-- Remove um usuário
function DB.Collections.UserInventory:Delete(identifier)
  DB.Core.Crud:Delete(DB.Core.Config.tables.user_inventory, { identifier = identifier })
  DB.Core.Cache:Invalidate("user_inventory:" .. identifier)
end

function DB.Collections.UserInventory:Create(data)
  DB.Core.Crud:Insert(DB.Core.Config.tables.user_inventory, data)

  local userInventory = DB.Models.User:new(data)
  DB.Core.Cache:Set("user_inventory:" .. data.identifier, userInventory)
  return userInventory
end
