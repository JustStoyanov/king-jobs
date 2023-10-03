-- Set Salary --

---@param amount number
---@param charId number?
local setSalary = function(amount, charId)
    if source and not charId then
        charId = Ox.GetPlayer(source).charId;
    end
    local query = 'UPDATE `character_jobs` SET `salary` = ? WHERE `charId` = ?';
    MySQL.query(query, {amount, charId});
end
RegisterNetEvent('king-jobs:server:setSalary', setSalary);

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

-- Get Salary --

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
lib.callback.register('king-jobs:server:getSalary', getSalary);

---@param amount number
RegisterNetEvent('king-jobs:server:receiveSalary', function(amount)
    -- Bug Prevention --
    if not amount then
        return;
    end

    if not exports['ox_inventory']:CanCarryItem(source, 'cash', amount) then
        ---@diagnostic disable-next-line: param-type-mismatch
        lib.notify(source, {
            title = 'Notification',
            description = 'You can\'t carry the cash!',
            type = 'error',
            duration = 7500
        });
        return;
    end
    -- Money Receiving --
    exports['ox_inventory']:AddItem(source, 'cash', amount);
end);