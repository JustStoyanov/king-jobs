---@param ped number
local playGetMoneyAnimation = function(ped)
    -- Bug Prevention --
    if not ped then
        return;
    end
    -- Animation --
    local dict, anim = 'mp_common', 'givetake1_a';
    lib.requestAnimDict(dict);
    TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 0, 0, false, false, false);
    Wait(500);
    -- Prop --
    local hash = GetHashKey('prop_anim_cash_pile_01');
    local x, y, z = table.unpack(GetEntityCoords(ped));
    ---@diagnostic disable-next-line: param-type-mismatch
    local prop = CreateObject(hash, x, y, z, false, true, true);
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true);
    Wait(1000);
    ClearPedTasks(ped);
    DeleteObject(prop);
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

---@param data table
local createPed = function(data)
    local model, c = joaat(data.model), data.coords;
    local x, y, z, r = c.x, c.y, c.z, data.rotation;
    -- Ped Creation --
    lib.requestModel(model);
    local ped = CreatePed(4, model, x, y, z, r, data.net or false, true);
    SetBlockingOfNonTemporaryEvents(ped, true);
    SetPedDiesWhenInjured(ped, false);
    SetPedCanPlayAmbientAnims(ped, true);
    SetPedCanRagdollFromPlayerImpact(ped, false);
    SetEntityInvincible(ped, true);
    if data.freeze or data.freeze == nil then
        FreezeEntityPosition(ped, true);
    end
    SetModelAsNoLongerNeeded(model);
    -- Metatable --
    local pedTable = setmetatable({}, {__call = ped});
    pedTable.ped = ped;
    pedTable.remove = function(self)
        DeletePed(self.ped);
    end
    return pedTable;
end

CreateThread(function()
    -- Ped/Zone Handling --
    for i = 1, #Config.SalaryPeds do
        local pedData = Config.SalaryPeds[i];
        -- Ped Handling --
        if pedData.ped then
            createPed({
                coords = pedData.ped.location,
                rotation = pedData.ped.heading,
                model = pedData.ped.model
            });
        end if pedData.peds then
            for j = 1, #pedData.peds do
                createPed({
                    coords = pedData.peds[j].location,
                    rotation = pedData.peds[j].heading,
                    model = pedData.peds[j].model
                });
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
                    playGetMoneyAnimation(cache.ped);
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
                        playGetMoneyAnimation(cache.ped);
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