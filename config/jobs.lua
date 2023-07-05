Config.Jobs = {
    ['unemployed'] = {
        label = 'Unemployed',
        gouverment = true,
        whitelist = true,
        canBeInGang = true,
        grades = false,
        salary = 30
    },

    ['kcpd'] = {
        label = 'KCPD',
        gouverment = true,
        whitelist = true,
        canBeInGang = false,
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