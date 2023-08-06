---@param playerId number?
---@return table?
local getPlayerJob = function(playerId)
    local name = 'king-jobs:server:getPlayerJob';
    return lib.callback.await(name, false, playerId);
end
exports('getPlayerJob', getPlayerJob);

---@param playerId number?
---@return table?
local getPlayerGang = function(playerId)
    local name = 'king-jobs:server:getPlayerGang';
    return lib.callback.await(name, false, playerId);
end
exports('getPlayerGang', getPlayerGang);