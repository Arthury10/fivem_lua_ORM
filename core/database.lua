DB.Core.Database = DB.Core.Database or {}

-- Executa uma query de SELECT
function DB.Core.Database:Select(query, params)
  DB.Core.Logger:LogQuery(query, params) -- Loga a query
  return MySQL.Sync.fetchAll(query, params)
end

-- Executa uma query de INSERT/UPDATE/DELETE
function DB.Core.Database:Execute(query, params)
  DB.Core.Logger:LogQuery(query, params) -- Loga a query
  MySQL.Sync.execute(query, params)
end
