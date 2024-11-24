DB.Core = DB.Core or {}
DB.Core.Config = DB.Core.Config or {}

-- Adicione os valores iniciais sem sobrescrever
DB.Core.Config.tables = DB.Core.Config.tables or {
  users = "users",
  user_status = "user_status",
  user_inventory = "user_inventory"
}

DB.Core.Config.relations = DB.Core.Config.relations or {
  user = {
    user_status = { table = "user_status", key = "identifier" },
    user_inventory = { table = "user_inventory", key = "identifier" }
  },
  user_status = {
    user = { table = "users", key = "identifier" }
  },
  user_inventory = {
    user = { table = "users", key = "identifier" }
  }
}
