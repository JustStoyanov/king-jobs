---@param amount number
---@param charId number?
local setSalary = function(amount, charId)
    if source and not charId then
        charId = Ox.GetPlayer(source).charId;
    end
    local query = 'UPDATE `character_jobs` SET `salary` = ? WHERE `charId` = ?';
    MySQL.query(query, {amount, charId});
end
exports('SetSalary', setSalary);
RegisterNetEvent('king-jobs:server:setSalary', setSalary);

---@param src number
---@return number?
local getSalary = function(src)
    local player = Ox.GetPlayer(src);
    local charId = player?.charId;
    local query = 'SELECT `salary` FROM `character_jobs` WHERE `charId` = ?';
    local data = MySQL.query.await(query, {charId});
    if not data or not data?[1] then
        return;
    end
    return data[1].salary;
end
exports('GetSalary', getSalary);
lib.callback.register('king-jobs:server:getSalary', getSalary);

---@param amount number
RegisterNetEvent('king-jobs:server:addMoneyItem', function(amount)
    exports['ox_inventory']:AddItem(source, 'cash', amount);
end);

lib.addCommand('setsalary',  {
    help = 'Add money to your salary.',
    params = {
        {
            name = 'playerId',
            help = 'The player id.',
            type = 'playerId'
        },
        {
            name = 'amount',
            help = 'The amount of money to add.',
            type = 'number'
        }
    },
    restricted = 'group.admin'
}, function(_, args)
    local player = Ox.GetPlayer(args.playerId);
    local charId = player?.charId;
    setSalary(args.amount, charId);
end);