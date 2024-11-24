DB.Core.Crud = DB.Core.Crud or {}


local function escapeIdentifier(identifier)
  if type(identifier) ~= "string" then
    error("Identifier deve ser uma string.")
  end
  -- Escapa backticks no nome para evitar quebras de sintaxe
  return string.format("`%s`", identifier:gsub("`", "``"))
end


-- Insert
function DB.Core.Crud:Insert(tableName, data)
  if not tableName or type(data) ~= "table" or next(data) == nil then
    error("Insert: tableName ou data inválido.")
  end

  local columns, placeholders, values = {}, {}, {}
  for column, value in pairs(data) do
    table.insert(columns, escapeIdentifier(column)) -- Escapa o nome da coluna
    table.insert(placeholders, "?")
    table.insert(values, value)
  end

  local query = string.format("INSERT INTO %s (%s) VALUES (%s)",
    escapeIdentifier(tableName), -- Escapa o nome da tabela
    table.concat(columns, ", "),
    table.concat(placeholders, ", "))

  DB.Core.Logger:LogQuery(query, values)
  local success, err = MySQL.Sync.execute(query, values)
  if not success then
    error(string.format("DB was unable to execute a query! %s", err))
  end
end

-- Update
function DB.Core.Crud:Update(tableName, data, conditions)
  if not tableName or not data or not conditions or next(conditions) == nil then
    error("Update: Dados ou condições inválidas.")
  end

  local setParts, whereParts, values = {}, {}, {}
  for column, value in pairs(data) do
    table.insert(setParts, string.format("%s = ?", escapeIdentifier(column)))
    table.insert(values, value)
  end

  for column, value in pairs(conditions) do
    table.insert(whereParts, string.format("%s = ?", escapeIdentifier(column)))
    table.insert(values, value)
  end

  local query = string.format("UPDATE %s SET %s WHERE %s",
    escapeIdentifier(tableName),
    table.concat(setParts, ", "),
    table.concat(whereParts, " AND "))

  DB.Core.Logger:LogQuery(query, values)
  local success, err = MySQL.Sync.execute(query, values)
  if not success then
    error(string.format("DB was unable to execute a query! %s", err))
  end
end

-- Delete
function DB.Core.Crud:Delete(tableName, conditions)
  if not tableName or not conditions or next(conditions) == nil then
    error("Delete: Condições inválidas.")
  end

  local whereParts, values = {}, {}
  for column, value in pairs(conditions) do
    table.insert(whereParts, string.format("%s = ?", escapeIdentifier(column)))
    table.insert(values, value)
  end

  local query = string.format("DELETE FROM %s WHERE %s",
    escapeIdentifier(tableName),
    table.concat(whereParts, " AND "))

  DB.Core.Logger:LogQuery(query, values)
  local success, err = MySQL.Sync.execute(query, values)
  if not success then
    error(string.format("DB was unable to execute a query! %s", err))
  end
end

-- Select
function DB.Core.Crud:Select(tableName, columns, conditions, orderBy, limit)
  if not tableName then
    error("Select: Nome da tabela é obrigatório.")
  end

  columns = columns or {}
  local whereParts, values = {}, {}

  for column, value in pairs(conditions or {}) do
    table.insert(whereParts, string.format("%s = ?", escapeIdentifier(column)))
    table.insert(values, value)
  end

  local query = string.format("SELECT %s FROM %s",
    #columns > 0 and table.concat(vim.tbl_map(escapeIdentifier, columns), ", ") or "*",
    escapeIdentifier(tableName))

  if next(whereParts) then
    query = query .. " WHERE " .. table.concat(whereParts, " AND ")
  end

  if orderBy then
    query = query .. " ORDER BY " .. escapeIdentifier(orderBy)
  end

  if limit then
    query = query .. " LIMIT " .. tonumber(limit)
  end

  DB.Core.Logger:LogQuery(query, values)
  return MySQL.Sync.fetchAll(query, values)
end
