---@diagnostic disable: missing-parameter, param-type-mismatch

-- myjob/mygang commands --

---@param data table
local formateGroupMSG = function(data)
    local msg = '';
    if data.group then
        local cfgGroups = Config[data.type == 'job' and 'Jobs' or 'Gangs'][data.group];
        if not cfgGroups?.label then
            return msg;
        end
        msg = ('%s: %s'):format(data.type == 'job' and 'You are working as' or 'You are part of', cfgGroups.label);
        if data.grade then
            local grade = cfgGroups?.grades?[data.grade];
            local grade_txt = data.type == 'job' and grade.label or grade;
            if not grade_txt then
                return msg;
            end
            msg = ('%s - %s'):format(msg, grade_txt);
        end
    end
    return msg;
end

---@param src number
---@param type 'job' | 'gang'
local myGroup = function(src, type)
    local player = Ox.GetPlayer(src);
    local group, grade = player.get(type).name, player.get(type).grade;
    -- Message Formating --
    local msg = type == 'job' and 'You are unemployed!' or 'You are not a part of any gang!';
    if group then
        msg = formateGroupMSG({
            type = type,
            group = group,
            grade = grade
        });
    end
    -- Notification --
    lib.notify(src, {
        title = 'Notification',
        description = msg,
        duration = 7500,
        type = 'info'
    });
end

lib.addCommand('myjob', {
    help = 'Check your job',
    params = {}
}, function(src)
    myGroup(src, 'job');
end);

lib.addCommand('mygang', {
    help = 'Check your gang',
    params = {}
}, function(src)
    myGroup(src, 'gang');
end);

-- change job/gang commands --

---@param src number
---@param groupType 'job' | 'gang'
---@param group string
---@param grade number?
local changeGroup = function(src, groupType, group, grade)
    -- Bug Prevention --
    if not src then
        return;
    end
    local player = Ox.GetPlayer(src); --[[@as OxPlayer]]
    if not group then
        local groupData = {
            name = groupType == 'job' and Config.Unemployed or nil,
            grade = 0
        };
        player.set(groupType, groupData, true);
        return;
    end
    -- Gang Prevention --
    if groupType == 'job' then
        if player.get('gang').name then
            if not Config.Jobs[group].metadata.canBeInGang then
                lib.notify(src, {
                    title = 'Notification',
                    description = 'You can\'t work this job if you are in a gang!',
                    duration = 7500,
                    type = 'error'
                });
                return;
            end
        end
    else
        local job = player.get('job').name;
        if not Config.Jobs[job].metadata.canBeInGang then
            lib.notify(src, {
                title = 'Notification',
                description = 'You can\'t be in a gang with this job!',
                duration = 7500,
                type = 'error'
            });
            return;
        end
    end
    -- Grade Handling --
    if Config[groupType == 'job' and 'Jobs' or 'Gangs'][group].grades then
        if not grade then
            grade = 1;
        end
    else
        grade = nil;
    end
    -- Group Changing --
    if group and src and player then
        -- Bug Prevention --
        local oldGroup, oldGrade = player.get(groupType).name, player.get(groupType).grade;
        if oldGroup == group and oldGrade == grade then
            return;
        end
        -- Group Changing --
        player.set(groupType, {
            name = group,
            grade = grade
        }, true);
        TriggerClientEvent(('king-jobs:client:%sUpdate'):format(groupType), src, group, grade, oldGroup, oldGrade);
    end
end

---@param job string?
---@param grade number?
RegisterNetEvent('king-jobs:server:changeJob', function(job, grade)
    ---@type number
    ---@diagnostic disable-next-line: assign-type-mismatch
    local src = source;
    if not source then
        return;
    end if type(source) ~= 'number' then
        return;
    end
    changeGroup(src, 'job', job, grade);
end);

lib.addCommand('changejob', {
    help = 'Set someone\'s job',
    params = {
        {
            name = 'playerId',
            help = 'The player\'s server ID',
            type = 'number'
        },
        {
            name = 'jobName',
            help = 'The job name',
            type = 'string',
            optional = true
        },
        {
            name = 'jobGrade',
            help = 'The job grade',
            type = 'number',
            optional = true
        }
    },
    restricted = 'group.admin'
}, function(_, args)
    changeGroup(args.playerId, 'job', args.jobName, args.jobGrade)
end);

---@param gang string?
---@param grade number?
RegisterNetEvent('king-jobs:server:changeGang', function(gang, grade)
    local src = source;
    if not src or type(src) ~= 'number' then
        return;
    end
    changeGroup(src, 'gang', gang, grade);
end);

lib.addCommand('changegang', {
    help = 'Set someone\'s gang',
    params = {
        {
            name = 'playerId',
            help = 'The player\'s server ID',
            type = 'number'
        },
        {
            name = 'gangName',
            help = 'The gang name',
            type = 'string',
            optional = true
        },
        {
            name = 'gangGrade',
            help = 'The gang grade',
            type = 'number',
            optional = true
        }
    },
    restricted = 'group.admin'
}, function(_, args)
    changeGroup(args.playerId, 'gang', args.gangName, args.gangGrade)
end);