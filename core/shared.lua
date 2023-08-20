local arr = {'Job', 'Gang'};
for i = 1, #arr do
    local value = arr[i];

    ---@return table
    exports(('get%ss'):format(value), function()
        return Config[('%ss'):format(value)];
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