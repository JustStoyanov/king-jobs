# king-jobs
 A job system for FiveM (ox_core) which allows the user the have a job, job grade, gang and gang grade at the same time.

# Config

- Job Creation

        ['jobName'] = {
            label = 'Job Label',
            metadata = {
                government = true,
                canBeInGang = true
            },
            grades = false,
            salary = 30
        }

- Salary Peds
    
    - This is an example for a single zone and multiple peds

            [1] = {
                zone = {
                    location = vec3(242.41, 225.60, 107.61),
                    heading = 340.00, size = vec3(8, 4, 3)
                },

                peds =  {
                    [1] = {
                        model = 'a_m_m_hasjew_01',
                        location = vec4(241.88, 226.87, 106.29, 170.00)
                    },

                    [2] = {
                        model = 'a_m_m_hasjew_01',
                        location = vec4(243.58, 226.26, 106.29, 170.00)
                    }
                }
            }
    - This is an example for single ped and multiple zones

            [2] = {
                ped = {
                    model = 'a_m_m_hasjew_01',
                    location = vec4(247.86, 224.69, 106.28, 161.39)
                },
                
                zones = {
                    [1] = {
                        location = vec3(248.80, 223.98, 107.30),
                        heading = 340.00, size = vec3(4, 4, 3)
                    }, [2] = {
                        location = vec3(246.85, 224.83, 107.28),
                        heading = 340.00, size = vec3(4, 4, 3)
                    }
                }
            }

    - This is an example for single ped and single zone

            [3] = {
                ped = {
                    model = 'a_m_m_hasjew_01',
                    location = vec4(247.44, 210.08, 106.28, 340.00)
                },
                pedZone = true
            }