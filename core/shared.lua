-- Add Exports --

---@class gangData
---@field label string
---@field grades string[]

---@param name string
---@param data gangData
local addGang = function(name, data)
    if not Config.Gangs[name] then
        Config.Gangs[name] = data;
    else
        error(('Gang "%s" already exists!'):format(name));
    end
end
exports('addGang', addGang);

---@class jobMetadata
---@field government boolean
---@field canBeInGang boolean

---@class outfitsData
---@field male table
---@field female table

---@class gradesData
---@field label string
---@field salary number
---@field outfits outfitsData

---@class jobData
---@field label string
---@field metadata jobMetadata
---@field grades gradesData[] | false
---@field salary number?


---@param name string
---@param data jobData
local addJob = function(name, data)
    if not Config.Jobs[name] then
        Config.Jobs[name] = data;
    else
        error(('Job "%s" already exists!'):format(name));
    end
end
exports('addJob', addJob);

-- Get Exports --

---@return string
exports('getUnemployedName', function()
    return Config.Unemployed;
end);

local arr = {'Job', 'Gang'};
for i = 1, #arr do
    local value = arr[i];

    ---@return table?
    exports(('get%ss'):format(value), function()
        local data = Config[('%ss'):format(value)];
        return type(data) == 'table' and data or nil;
    end);

    ---@param key string
    ---@return table
    exports(('get%s'):format(value), function(key)
        return Config[value][key:lower()];
    end);

    ---@param key string
    ---@return string
    exports(('get%sLabel'):format(value), function(key)
        return Config[value][key:lower()].label;
    end);
end