---@param src number
---@param userid number
---@param charid number
AddEventHandler('ox:playerLoaded', function(src, userid, charid)
    ---@type table
    local player = Ox.GetPlayer(src); --[[@as OxPlayer]]
    if not player then
        return;
    end
    ---@type table?
    local rawData = MySQL.single.await([[
    SELECT `job` FROM `character_jobs` WHERE
        `userid` = ? AND `charid` = ?
    ]], {
        userid, charid
    });
    ---@type string
    local rawPlayerJobs = rawData?.job or '{"name":"unemployed"}';
    ---@type table
    local playerJobs = json.decode(rawPlayerJobs);
    ---@type table | string
    local job = playerJobs or 'unemployed';
    player.set('job', job, true);
end);

---@param src number
---@param userid number
---@param charid number
AddEventHandler('ox:playerLogout', function(src, userid, charid)
    ---@type table
    local player = Ox.GetPlayer(src); --[[@as OxPlayer]]
    if not player then
        return;
    end
    local currentJob = json.encode(player.get('job'));
    MySQL.query('SELECT * FROM `character_jobs` WHERE `userid` = ? AND `charid` = ?', {
        userid, charid
    }, function(data)
        local elsE = function()
            MySQL.insert('INSERT INTO `character_jobs` (`userid`, `charid`, `job`) VALUES (?, ?, ?)', {
                userid, charid, currentJob
            });
        end if data then
            if data[1] then
                MySQL.update('UPDATE `character_jobs` SET `job` = ? WHERE `userid` = ? AND `charid` = ?', {
                    currentJob, userid, charid
                });
            else
                elsE()
            end
        else
            elsE()
        end
    end);
end);