---@param playerId number?
---@return table?
local getPlayerJob = function(playerId)
    if not playerId then
        return player.job;
    end
    local name = 'king-jobs:server:getPlayerJob';
    return lib.callback.await(name, false, playerId);
end
exports('getPlayerJob', getPlayerJob);

---@param job string
---@param grade number
RegisterNetEvent('king-jobs:jobUpdate', function(job, grade)
    if Config.Debug then
        print(('Job Updated: %s | %s'):format(job, grade));
    end
end);

---@param playerId number?
---@return table?
local getPlayerGang = function(playerId)
    if not playerId then
        return player.gang;
    end
    local name = 'king-jobs:server:getPlayerGang';
    return lib.callback.await(name, false, playerId);
end
exports('getPlayerGang', getPlayerGang);

---@param gang string
---@param grade number
RegisterNetEvent('king-jobs:gangUpdate', function(gang, grade)
    if Config.Debug then
        print(('Gang Updated: %s | %s'):format(gang, grade));
    end
end);