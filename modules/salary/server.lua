---@param amount number
---@param charid number?
local setSalary = function(amount, charid)
    if source and not charid then
        charid = Ox.GetPlayer(source).charid;
    end
    local query = 'UPDATE `character_jobs` SET `salary` = ? WHERE `charid` = ?';
    MySQL.query(query, {amount, charid});
end
exports('SetSalary', setSalary);
RegisterServerEvent('king-jobs:server:setSalary', setSalary);

---@param src number
---@return number?
lib.callback.register('king-jobs:server:getSalary', function(src)
    local player = Ox.GetPlayer(src); --[[@as OxPlayer]]
    local charid = player.charid;
    local query = 'SELECT `salary` FROM `character_jobs` WHERE `charid` = ?';
    local data = MySQL.query.await(query, {charid});
    if not data or not data?[1] then
        return;
    end
    return data[1].salary;
end);

---@param amount number
RegisterServerEvent('king-jobs:server:addMoneyItem', function(amount)
    exports['ox_inventory']:AddItem(source, 'cash', amount);
end);