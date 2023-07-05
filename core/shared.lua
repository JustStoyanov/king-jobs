-- Jobs --

---@return table
exports('getJobs', function()
    return Config.Jobs;
end);

---@param job string
---@return table
exports('getJob', function(job)
    return Config.Jobs[job:lower()];
end);

---@param job string
---@return string
exports('getJobLabel', function(job)
    return Config.Jobs[job:lower()].label;
end);

-- Gangs --

---@return table
exports('getGangs', function()
    return Config.Gangs;
end);

---@param gang string
---@return table
exports('getGang', function(gang)
    return Config.Gangs[gang:lower()];
end);

---@param gang string
---@return string
exports('getGangLabel', function(gang)
    return Config.Gangs[gang:lower()].label;
end);