Config.Unemployed = 'unemployed';
Config.Jobs = {
    ['unemployed'] = {
        label = 'Unemployed',
        metadata = {
            government = true,
            canBeInGang = true
        },
        grades = false,
        salary = 30
    },

    ['kcmd'] = {
        label = 'KCMD',
        metadata = {
            government = true,
            canBeInGang = true
        },

        grades = {
            [1] = {
                label = 'Nurse',
                salary = 100,
                outfits = {
                    male = {},
                    female = {}
                }
            },

            [2] = {
                label = 'Doctor',
                salary = 150,
                outfits = {
                    male = {},
                    female = {}
                }
            }
        }
    },

    ['kcpd'] = {
        label = 'KCPD',
        metadata = {
            government = true,
            canBeInGang = false
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