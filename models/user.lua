DB.Models.User = DB.Models.User or {}
DB.Models.User.__index = DB.Models.User

-- Define o construtor da classe User
function DB.Models.User:new(data)
  print("Instanciando um novo UserModel...")
  print(data)

  -- Configura a metatable para a instância
  local user = setmetatable(data or {}, self)
  return user
end
