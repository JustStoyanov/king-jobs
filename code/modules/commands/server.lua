---@diagnostic disable: missing-parameter, param-type-mismatch

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

lib.addCommand('myjob', {
    help = 'Check your jobs',
    params = {}
}, function(src)
    local player = Ox.GetPlayer(src);
    local job, grade_id = player.get('job').name, player.get('job').grade;
    -- Message Formating --
    local msg = 'You are unemployed!';
    if job ~= Config.Unemployed then
        msg = formateGroupMSG({
            type = 'job',
            group = job,
            grade = grade_id
        });
    end
    -- Notification --
    lib.notify(src, {
        title = 'Notification',
        description = msg,
        duration = 5000,
        type = 'info'
    });
end);

lib.addCommand('mygang', {
    help = 'Check your gang',
    params = {}
}, function(src)
    local player = Ox.GetPlayer(src);
    local gang, gang_grade = player.get('gang').name, player.get('gang').grade;
    -- Message Formating --
    local msg = 'You are not in a gang!';
    if gang then
        msg = formateGroupMSG({
            type = 'gang',
            group = gang,
            grade = gang_grade
        });
    end
    -- Notification --
    lib.notify(src, {
        title = 'Notification',
        description = msg,
        duration = 5000,
        type = 'info'
    });
end);

---@param src number
---@param job string?
---@param grade number?
local changeJob = function(src, job, grade)
    -- Bug Prevention --
    if not src then
        return;
    end
    local player = Ox.GetPlayer(src); --[[@as OxPlayer]]
    if not job then
        ---@type table
        local jobData = {
            name = Config.Unemployed,
            grade = 0
        };
        player.set('job', jobData, true);
        return;
    end
    -- Gang Prevention --
    if player.get('gang').name then
        if not Config.Jobs[job].metadata.canBeInGang then
            lib.notify(src, {
                title = 'Notification',
                description = 'You can\'t work this job if you are in a gang!',
                duration = 5000,
                type = 'error'
            });
            return;
        end
    end
    -- Grade Handling --
    if Config.Jobs?[job]?.grades then
        if not grade then
            grade = 1;
        end
    else
        grade = nil;
    end
    -- Job Changing --
    if job and src and player then
        ---@type table
        local jobData = {
            name = job,
            grade = grade
        };
        player.set('job', jobData, true);
        TriggerClientEvent('king-jobs:jobUpdate', src, job, grade);
    end
end
exports('ChangeJob', changeJob);

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
    changeJob(src, job, grade);
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
}, function(src, args)
    if not src then
        return;
    end
    changeJob(args.playerId, args.jobName, args.jobGrade)
end);

---@param src number
---@param gang string?
---@param grade number?
local changeGang = function(src, gang, grade)
    -- Bug Prevention --
    if not src then
        return;
    end
    local player = Ox.GetPlayer(src); --[[@as OxPlayer]]
    if not gang then
        ---@type table
        local gangData = {
            name = nil,
            grade = 0
        };
        player.set('gang', gangData, true);
        return;
    end
    local job = player.get('job').name;
    if not Config.Jobs[job].metadata.canBeInGang then
        lib.notify(src, {
            title = 'Notification',
            description = 'You can\'t be in a gang with this job!',
            duration = 5000,
            type = 'error'
        });
        return;
    end
    -- Grade Handling --
    if Config.Gangs[gang].grades then
        if not grade then
            grade = 1;
        end
    else
        grade = nil;
    end
    -- Gang Changing --
    if gang and src and player then
        player.set('gang', {
            name = gang,
            grade = grade
        }, true);
        TriggerClientEvent('king-jobs:gangUpdate', src, gang, grade);
    end
end
exports('ChangeGang', changeGang);

---@param gang string?
---@param grade number?
RegisterNetEvent('king-jobs:server:changeGang', function(gang, grade)
    local src = source;
    if not src or type(src) ~= 'number' then
        return;
    end
    changeGang(src, gang, grade);
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
}, function(src, args)
    changeGang(args.playerId, args.gangName, args.gangGrade)
end);