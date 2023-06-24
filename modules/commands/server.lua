lib.addCommand('myjob', {
    help = 'Check your jobs'
}, function(src)
    local player = Ox.GetPlayer(src); --[[@as OxPlayer]]
    ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
    local rawJobData = player.get('job');
    -- Message --
    local data, message = Config.Jobs[rawJobData.name], nil;
    local grade = rawJobData.grade;
    message = data.label if grade then
        message = message..' '..data.grades[rawJobData.grade].label;
    end
    -- Notification --
    local msg = 'You are working as: '..message;
    if not message or message == 'Unemployed' then
        msg = 'You are unemployed!';
    end
    klibrary.interface.notifySV(src, msg, 'info', 5000, 'Job Center');
end);

---@param src number
---@param job string
---@param grade number?
local changeJob = function(src, job, grade)
    -- Bug Prevention --
    if not src then
        return;
    end if not job then
        job = 'unemployed';
    end
    -- Grade Handling --
    if Config.Jobs?[job].grades then
        if not grade then
            grade = 1;
        end
        if not Config.Jobs[job].grades[grade] then
            grade = 1;
        end
    else
        grade = nil;
    end
    -- Job Changing --
    local player = Ox.GetPlayer(src); --[[@as OxPlayer]]
    if Config.Jobs[job] then
        ---@diagnostic disable-next-line: param-type-mismatch
        player.set('job', {
            name = job,
            grade = grade
        }, true);
        -- Notification --
        local msg = 'You are now working as: '..Config.Jobs[job].label;
        if grade then
            msg = msg..' '..Config.Jobs[job].grades[grade].label;
        end
        klibrary.interface.notifySV(src, msg, 'info', 5000, 'Job Center');
    else
        klibrary.interface.notifySV(src, 'This job does not exist!', 'error', 5000, 'Job Center');
    end
end
RegisterNetEvent('king-jobsystem:server:changeJob', changeJob);

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
    if not src or not args then
        return;
    end
    changeJob(args.playerId, args.jobName, args.jobGrade)
end);