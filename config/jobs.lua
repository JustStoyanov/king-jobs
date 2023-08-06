--[[
    ['jobName'] = { -- This is what you type when you use /changejob
        label = 'Job Label', -- This is what you see when you use /myjob
        metadata = {
            gouverment = true, -- true - the gouverment can control the job (it's not owned business)
            canBeInGang = true, -- true - the player can be in a gang at the same time
        },
        grades = false, -- false - no grades | table - the grades
        salary = 30 -- if there is no grades you add the salary here
    }
]]--

--TODO
-- Config.Unemployed = {
--     name = 'unemployed',
--     label = 'Unemployed',
--     metadata = {
--         gouverment = true,
--         canBeInGang = true,
--     },
--     grades = false,
--     salary = 30
-- };

Config.Jobs = {
    ['unemployed'] = {
        label = 'Unemployed',
        metadata = {
            gouverment = true,
            canBeInGang = true,
        },
        grades = false,
        salary = 30
    },

    ['kcpd'] = {
        label = 'KCPD',
        metadata = {
            gouverment = true,
            canBeInGang = false,
        },
        grades = {
            [1] = {
                label = 'Cadet',
                salary = 100,
                outfits = {
                    male = {},
                    female = {}
                }
            },

            [2] = {
                label = 'Officer',
                salary = 150,
                outfits = {
                    male = {},
                    female = {}
                }
            },

            [3] = {
                label = 'Sergeant',
                salary = 200,
                outfits = {
                    male = {},
                    female = {}
                },
                boss = true
            }
        }
    }
};