---@param src number
---@param palyerId number
---@return table?
lib.callback.register('king-jobs:server:getPlayerJob', function(src, palyerId)
    ---@type table
    local player = Ox.GetPlayer(palyerId or src); --[[@as OxPlayer]]
    if not player then
        return nil;
    end
    return player.get('job');
end);

---@param src number
---@param palyerId number
---@return table?
lib.callback.register('king-jobs:server:getPlayerGang', function(src, palyerId)
    ---@type table
    local player = Ox.GetPlayer(palyerId or src); --[[@as OxPlayer]]
    if not player then
        return nil;
    end
    return player.get('gang');
end);

---@param src number
---@param charid number
---@return nil
AddEventHandler('ox:playerLoaded', function(src, _, charid)
    ---@type table
    local player = Ox.GetPlayer(src); --[[@as OxPlayer]]
    if not player then
        return;
    end
    ---@type table?
    local data = MySQL.single.await([[
    SELECT `job`, `job_grade`, `gang`, `gang_grade` FROM `character_jobs` WHERE
        `charid` = ?
    ]], {
        charid
    });
    ---@type table
    local job = {
        name = data?.job or 'unemployed',
        grade = data?.job_grade or 0
    };
    player.set('job', job, true);
    ---@type table
    local gang = {
        name = data?.gang or nil,
        grade = data?.gang_grade or 0
    };
    player.set('gang', gang, true);
end);

---@param src number
---@param charid number
---@return nil
AddEventHandler('ox:playerLogout', function(src, _, charid)
    ---@type table
    local player = Ox.GetPlayer(src); --[[@as OxPlayer]]
    if not player then
        return;
    end
    local job, gang = player.get('job'), player.get('gang');
    MySQL.query('SELECT * FROM `character_jobs` WHERE `charid` = ?', {
        charid
    }, function(data)
        local elsE = function()
            MySQL.insert([[
                INSERT INTO `character_jobs` (
                    `charid`,
                    `job`,
                    `job_grade`,
                    `gang`,
                    `gang_grade`
                ) VALUES (?, ?, ?, ?, ?)
            ]], {
                charid, job.name, job.grade, gang.name, gang.grade
            });
        end

        if data then
            if data[1] then
                MySQL.update([[
                    UPDATE `character_jobs` SET
                    `job` = ?,
                    `job_grade` = ?,
                    `gang` = ?,
                    `gang_grade` = ?
                    WHERE `charid` = ?
                ]], {
                    job.name, job.grade, gang.name, gang.grade, charid
                });
            else
                elsE();
            end
        else
            elsE();
        end
    end);
end);