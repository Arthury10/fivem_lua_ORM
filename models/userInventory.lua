DB.Models.UserInventory = DB.Models.UserInventory or {}
DB.Models.UserInventory.__index = DB.Models.UserInventory.__index

-- Define o construtor da classe User
function DB.Models.UserInventory:new(data)
  print("Instanciando um novo UserInventoryModel...")
  print(data)

  -- Configura a metatable para a instância
  local userInventory = setmetatable(data or {}, self)
  return userInventory
end
