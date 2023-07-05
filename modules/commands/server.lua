---@param job string
---@param job_grade number
---@return string
local formateJobMSG = function(job, job_grade)
    local msg = 'You are unemployed!';
    if job and job ~= 'unemployed' then
        local cfgJobs = Config.Jobs[job];
        if not cfgJobs?.label then
            goto skip
        end
        msg = 'You are working as: '..cfgJobs.label;
        if job_grade then
            if not cfgJobs?.grades?[job_grade]?.label then
                goto skip
            end
            msg = msg..' - '..cfgJobs.grades[job_grade].label;
        end
    end
    ::skip::
    return msg;
end

lib.addCommand('myjob', {
    help = 'Check your jobs'
}, function(src)
    local player = Ox.GetPlayer(src); --[[@as OxPlayer]]
    ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
    local job, grade_id = player.get('job').name, player.get('job').grade;
    local msg = formateJobMSG(job, grade_id);
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Notification',
        description = msg,
        duration = 5000,
        type = 'info'
    });
end);

---@param gang string
---@param gang_grade number
local formateGangMSG = function(gang, gang_grade)
    local msg = 'You are not in a gang!';
    if gang then
        local cfgGangs = Config.Gangs[gang];
        if not cfgGangs?.label then
            goto skip
        end
        msg = msg..'\n\n Gang: '..cfgGangs.label;
        if gang_grade then
            if not cfgGangs?.grades?[gang_grade] then
                goto skip
            end
            msg = msg..' - '..cfgGangs.grades[gang_grade];
        end
    end
    ::skip::
    return msg;
end

lib.addCommand('mygang', {
    help = 'Check your gang'
}, function(src)
    local player = Ox.GetPlayer(src); --[[@as OxPlayer]]
    ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
    local gang, gang_grade = player.get('gang').name, player.get('gang').grade;
    local msg = formateGangMSG(gang, gang_grade);
    TriggerClientEvent('ox_lib:notify', src, {
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
            name = 'unemployed',
            grade = 0
        };
        ---@diagnostic disable-next-line: unused-function, param-type-mismatch
        player.set('job', jobData, true);
        return;
    end
    -- Grade Handling --
    if Config.Jobs[job].grades then
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
        ---@diagnostic disable-next-line: unused-function, param-type-mismatch
        player.set('job', jobData, true);
    end
end

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
            type = 'string'
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
        ---@diagnostic disable-next-line: unused-function, param-type-mismatch
        player.set('gang', gangData, true);
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
        ---@type table
        local gangData = {
            name = gang,
            grade = grade
        };
        ---@diagnostic disable-next-line: unused-function, param-type-mismatch
        player.set('gang', gangData, true);
    end
end

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
            type = 'string'
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
    if not src then
        return;
    end
    changeGang(args.playerId, args.gangName, args.gangGrade)
end);