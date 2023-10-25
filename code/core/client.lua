---@todo job change 

-- Duty Handler --

local state = LocalPlayer.state;
state:set('onDuty', false, false);

---@param onDuty boolean
local setDuty = function(onDuty)
    if onDuty == nil then
        return;
    end
    state:set('onDuty', onDuty, false);
end
exports('setDuty', setDuty);

-- Update Handler --

---@param job string
---@param grade number
---@param oldJob string
---@param oldGrade number
RegisterNetEvent('king-jobs:client:jobUpdate', function(job, grade, oldJob, oldGrade)
    if Config.Debug then
        print(('Job Updated: %s | %s  \n Old Job: %s | %s'):format(job, grade, oldJob, oldGrade));
    end
    setDuty(false);
end);

---@param gang string
---@param grade number
---@param oldGang string
---@param oldGrade number
RegisterNetEvent('king-jobs:client:gangUpdate', function(gang, grade, oldGang, oldGrade)
    if Config.Debug then
        print(('Gang Updated: %s | %s  \n Old Gang: %s | %s'):format(gang, grade, oldGang, oldGrade));
    end
end);

-- Fetch Handler --

---@param playerId number?
---@return table?
local getPlayerJob = function(playerId)
    if not playerId or playerId == cache.serverId then
        return player.job;
    end
    return lib.callback.await('king-jobs:server:getPlayerJob', false, playerId);
end
exports('getPlayerJob', getPlayerJob);

---@param playerId number?
---@return table?
local getPlayerGang = function(playerId)
    if not playerId or playerId == cache.serverId then
        return player.gang;
    end
    return lib.callback.await('king-jobs:server:getPlayerGang', false, playerId);
end
exports('getPlayerGang', getPlayerGang);