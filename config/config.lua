Config = {};

-- Configuration --

Config.SalaryReceiveTime = 30; -- In minutes
Config.SalaryPeds = {
    [1] = {
        ped = {
            model = 'a_m_m_hasjew_01',
            location = vec4(247.44, 210.08, 106.28, 340.00)
        }, pedZone = true
    }
};

--[[
    [1] = {
        peds =  { -- Multiple peds - Single Zone
            [1] = {
                model = 'a_m_m_hasjew_01',
                location = vec4(241.88, 226.87, 106.29, 170.00)
            }, [2] = {
                model = 'a_m_m_hasjew_01',
                location = vec4(243.58, 226.26, 106.29, 170.00)
            }
        }, zone = {
            location = vec3(242.41, 225.60, 107.61),
            heading = 340.00, size = vec3(8, 4, 3)
        }
    },
    
    [2] = { -- Single ped - Multiple Zones
        ped = {
            model = 'a_m_m_hasjew_01',
            location = vec4(247.86, 224.69, 106.28, 161.39)
        }, zones = {
            [1] = {
                location = vec3(248.80, 223.98, 107.30),
                heading = 340.00, size = vec3(4, 4, 3)
            }, [2] = {
                location = vec3(246.85, 224.83, 107.28),
                heading = 340.00, size = vec3(4, 4, 3)
            }
        }
    },
    
    [3] = { -- Single ped - Single Zone
        ped = {
            model = 'a_m_m_hasjew_01',
            location = vec4(247.44, 210.08, 106.28, 340.00)
        }, pedZone = true
    }
]]--