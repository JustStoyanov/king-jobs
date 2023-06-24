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