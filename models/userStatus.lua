DB.Models.UserStatus = DB.Models.UserStatus or {}
DB.Models.UserStatus.__index = DB.Models.UserStatus__index

-- Define o construtor da classe User
function DB.Models.UserStatus:new(data)
  print("Instanciando um novo UserStatus...")
  print(data)

  -- Configura a metatable para a instância
  local userStatus = setmetatable(data or {}, self)
  return userStatus
end
