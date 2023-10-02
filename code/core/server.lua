---@diagnostic disable: missing-parameter, param-type-mismatch

---@param src number
---@param palyerId number
---@return table?
lib.callback.register('king-jobs:server:getPlayerJob', function(src, palyerId)
    local player = Ox.GetPlayer(palyerId or src);
    if not player then
        return nil;
    end
    return player.get('job');
end);

---@param src number
---@param palyerId number
---@return table?
lib.callback.register('king-jobs:server:getPlayerGang', function(src, palyerId)
    local player = Ox.GetPlayer(palyerId or src);
    if not player then
        return nil;
    end
    return player.get('gang');
end);

---@param src number
---@param charId number
---@return nil
AddEventHandler('ox:playerLoaded', function(src, _, charId)
    ---@type table
    local player = Ox.GetPlayer(src);
    if not player then
        return;
    end
    ---@type table?
    local data = MySQL.single.await([[
    SELECT `job`, `job_grade`, `gang`, `gang_grade` FROM `character_jobs` WHERE
        `charId` = ?
    ]], {
        charId
    });

    player.set('job', {
        name = data?.job or 'unemployed',
        grade = data?.job_grade or 0
    }, true);

    player.set('gang', {
        name = data?.gang or nil,
        grade = data?.gang_grade or 0
    }, true);
end);

---@param src number
---@param charId number
---@return nil
AddEventHandler('ox:playerLogout', function(src, _, charId)
    local player = Ox.GetPlayer(src);
    if not player then
        return;
    end
    local job, gang = player.get('job'), player.get('gang');
    MySQL.query('SELECT * FROM `character_jobs` WHERE `charId` = ?', {
        charId
    }, function(data)
        local elsE = function()
            MySQL.insert([[
                INSERT INTO `character_jobs` (
                    `charId`,
                    `job`,
                    `job_grade`,
                    `gang`,
                    `gang_grade`
                ) VALUES (?, ?, ?, ?, ?)
            ]], {
                charId, job.name, job.grade, gang.name, gang.grade
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
                    WHERE `charId` = ?
                ]], {
                    job.name, job.grade, gang.name, gang.grade, charId
                });
            else
                elsE();
            end
        else
            elsE();
        end
    end);
end);