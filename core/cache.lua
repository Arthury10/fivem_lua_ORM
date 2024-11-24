DB.Core.Cache = DB.Core.Cache or {}
DB.Core.Cache.store = DB.Core.Cache.store or {}


-- Armazena um valor no cache
function DB.Core.Cache:Set(key, value, ttl)
  ttl = ttl or 60 -- Tempo padrão de 60 segundos
  self.store[key] = { value = value, expires = os.time() + ttl }
end

-- Obtém um valor do cache
function DB.Core.Cache:Get(key)
  local entry = self.store[key]
  if entry and entry.expires > os.time() then
    return entry.value
  else
    self.store[key] = nil -- Remove do cache se expirado
    return nil
  end
end

-- Invalida um valor do cache
function DB.Core.Cache:Invalidate(key)
  self.store[key] = nil
end
