---@param data table
---@return number?
local spawnPed = function(data)
    local model, loc = GetHashKey(data.model), data.location;
    local x, y, z, w in loc;
    lib.requestModel(model);
    local ped = CreatePed(4, model, x, y, z - 1, w, true, true);
    SetBlockingOfNonTemporaryEvents(ped, true);
    SetPedDiesWhenInjured(ped, false);
    SetPedCanPlayAmbientAnims(ped, true);
    SetPedCanRagdollFromPlayerImpact(ped, false);
    SetEntityInvincible(ped, true);
    FreezeEntityPosition(ped, true);
    return ped;
end

---@param data table
local createTarget = function(data)
    exports['ox_target']:addBoxZone({
        coords = data.location,
        rotation = data.heading,
        debug = data.debug or false,
        size = data.size,
        options = {
            {
                label = 'Talk with the Banker',
                icon = 'fas fa-hand',
                onSelect = function()
                    lib.showContext('king_jobs_salary_menu');
                end,
                distance = 1.5
            }
        }
    });
end

CreateThread(function()
    -- Ped/Zone Handling --
    for i = 1, #Config.SalaryPeds do
        local pedData = Config.SalaryPeds[i];
        -- Ped Handling --
        if pedData.ped then
            spawnPed(pedData.ped);
        end if pedData.peds then
            for j = 1, #pedData.peds do
                spawnPed(pedData.peds[j]);
            end
        end
        -- Zone Handling --
        if pedData.zone then
            createTarget(pedData.zone);
        end if pedData.zones then
            for j = 1, #pedData.zones do
                createTarget(pedData.zones[j]);
            end
        end if pedData.pedZone then
            pedData.ped.size = vec3(1, 1, 3);
            createTarget(pedData.ped);
        end
    end
    -- Context Menu --
    lib.registerContext({
        id = 'king_jobs_salary_menu',
        title = 'Banker',
        options = {
            {
                title = 'Check Balance',
                icon = 'fas fa-dollar-sign',
                onSelect = function()
                    ---@param salary number
                    lib.callback('king-jobs:server:getSalary', false, function(salary)
                        local msg = 'You have no salary!';
                        if salary then
                            if salary > 0 then
                                msg = ('Your salary is: $%s'):format(salary);
                            end
                        end lib.notify({
                            title = 'Bank',
                            description = msg,
                            type = 'info',
                            icon = 'fas fa-dollar-sign',
                            duration = 7500
                        });
                    end);
                end
            },
            {
                title = 'Get Salary (amount)',
                icon = 'fas fa-dollar-sign',
                onSelect = function()
                    -- Input --
                    local input = lib.inputDialog('Salary Getting', {'Amount'});
                    if not input or not input?[1] or input?[1] == '' then
                        return;
                    end
                    local amount = tonumber(input[1]);
                    if not amount or amount <= 0 then
                        lib.notify({
                            title = 'Bank',
                            description = 'Invalid amount!',
                            type = 'error',
                            icon = 'fas fa-dollar-sign',
                            duration = 7500
                        })
                        return;
                    end
                    -- DB Stuff --
                    local salary = lib.callback.await('king-jobs:server:getSalary', false);
                    if not salary then
                        lib.notify({
                            title = 'Bank',
                            description = 'You have no salary!',
                            type = 'error',
                            icon = 'fas fa-dollar-sign',
                            duration = 7500
                        })
                        return;
                    end if salary < amount then
                        lib.notify({
                            title = 'Bank',
                            description = 'You do not have enough money!',
                            type = 'error',
                            icon = 'fas fa-dollar-sign',
                            duration = 7500
                        })
                        return;
                    end
                    -- Give Money --
                    TriggerServerEvent('king-jobs:server:setSalary', salary - amount);
                    lib.notify({
                        title = 'Bank',
                        description = ('You have withdrawn $%s from your salary!'):format(amount),
                        type = 'success',
                        icon = 'fas fa-dollar-sign',
                        duration = 7500
                    });
                    TriggerServerEvent('king-jobs:server:addMoneyItem', amount);
                end
            },
            {
                title = 'Get Salary (all)',
                icon = 'fas fa-dollar-sign',
                onSelect = function()
                    lib.callback('king-jobs:server:getSalary', false, function(salary)
                        if not salary or tonumber(salary) < 1 then
                            lib.notify({
                                title = 'Bank',
                                description = 'You have no salary!',
                                type = 'error',
                                icon = 'fas fa-dollar-sign',
                                duration = 7500
                            })
                            return;
                        end
                        TriggerServerEvent('king-jobs:server:setSalary', 0);
                        lib.notify({
                            title = 'Bank',
                            description = ('You have withdrawn $%s from your salary!'):format(salary),
                            type = 'success',
                            icon = 'fas fa-dollar-sign',
                            duration = 7500
                        });
                        TriggerServerEvent('king-jobs:server:addMoneyItem', salary);
                    end);
                end
            }
        }
    });
end);