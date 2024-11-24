DB.Core.Logger = DB.Core.Logger or {}

function DB.Core.Logger:LogQuery(query, values)
  print("[DB QUERY]: " .. query)
  print("[DB VALUES]: " .. json.encode(values))
end

function DB.Core.Logger:Log(...)
  if not ... then
    print("[DB]: nil")
    print(...)
    return
  else
    print("[DB]: " .. ...)
  end
end
