---@param src number
---@param job string
---@param charId number | string | nil
---@return number?
lib.callback.register('king-jobs:server:getJobXP', function(src, job, charId)
    if not job then
        return;
    end
    -- Char Id Handling --
    if not charId then
        local player = Ox.GetPlayer(src);
        if player then
            charId = player.charid;
        end
    end
    -- Experience Getting --
    local result = MySQL.query.await('SELECT * FROM job_experience WHERE charid = ? AND job = ?', {
        charId,
        job
    });
    return result?[1]?.experience;
end);

---@param job string
---@param xp number
---@param charId number | string | nil
RegisterServerEvent('king-jobs:server:setJobXP', function(job, xp, charId)
    if not job or not xp then
        return;
    end
    -- Char Id Handling --
    if not charId then
        local player = Ox.GetPlayer(source);
        if player then
            charId = player.charid;
        end
    end
    -- Experience Adding --
    MySQL.query('SELECT * FROM job_experience WHERE charid = ? AND job = ?', {
        charId,
        job
    }, function(result)
        if result?[1] then
            MySQL.query('UPDATE job_experience SET experience = ? WHERE charid = ? AND job = ?', {
                xp,
                charId,
                job
            });
        else
            MySQL.query('INSERT INTO job_experience (charid, job, experience) VALUES (?, ?, ?)', {
                charId,
                job,
                xp
            });
        end
    end);
end);