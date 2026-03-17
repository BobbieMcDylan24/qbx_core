return {
    statusIntervalSeconds = 5, -- how often to check hunger/thirst status to remove health if 0.
    loadingModelsTimeout = 30000, -- Waiting time for ox_lib to load the models before throws an error, for low specs pc

    pauseMapText = 'Powered by Qbox', -- Text shown above the map when ESC is pressed. If left empty 'FiveM' will appear

    characters = {
        useExternalCharacters = false, -- Whether you have an external character management resource. (If true, disables the character management inside the core)
        enableDeleteButton = true, -- Whether players should be able to delete characters themselves.
        startingApartment = true, -- If set to false, skips apartment choice in the beginning (requires qbx_spawn if true)

        dateFormat = 'YYYY-MM-DD',
        dateMin = '1900-01-01', -- Has to be in the same format as the dateFormat config
        dateMax = '2006-12-31', -- Has to be in the same format as the dateFormat config

        limitNationalities = true, -- Setting this to false will allow people to enter whatever they want in the nationality field (To edit the list of nationalities, head to data/nationalities.lua)

        profanityWords = {
            ['bad word'] = true
        },

        cityTour = { -- Cinematic city tour shown to new characters after creation
            enabled = true,
            locations = {
                {
                    camCoords = vec3(300.0, -1430.0, 37.0),
                    pointAt = vec3(297.0, -1449.0, 30.0),
                    title = 'Pillbox Hill Medical Center',
                    description = 'Your local hospital. Come here for medical care, surgery, and emergency treatment.',
                    duration = 5000,
                },
                {
                    camCoords = vec3(437.0, -1006.0, 40.0),
                    pointAt = vec3(440.0, -981.0, 30.0),
                    title = 'Mission Row Police Department',
                    description = 'Home of the Los Santos Police Department. Uphold the law and stay out of trouble.',
                    duration = 5000,
                },
                {
                    camCoords = vec3(130.0, -1050.0, 33.0),
                    pointAt = vec3(149.0, -1042.0, 29.0),
                    title = 'Fleeca Bank - Legion Square',
                    description = 'Your local bank in Legion Square. Deposit your money and manage your finances here.',
                    duration = 5000,
                },
            },
        },

        locations = { -- Spawn locations for multichar, these are chosen randomly
            {
                pedCoords = vec4(969.25, 72.61, 116.18, 276.55),
                camCoords = vec4(972.2, 72.9, 116.68, 97.27),
            },
            {
                pedCoords = vec4(1104.49, 195.9, -49.44, 44.22),
                camCoords = vec4(1102.29, 198.14, -48.86, 225.07),
            },
            {
                pedCoords = vec4(-2163.87, 1134.51, -24.37, 310.05),
                camCoords = vec4(-2161.7, 1136.4, -23.77, 131.52),
            },
            {
                pedCoords = vec4(-996.71, -68.07, -99.0, 57.61),
                camCoords = vec4(-999.90, -66.30, -98.45, 241.68),
            },
            {
                pedCoords = vec4(-1023.45, -418.42, 67.66, 205.69),
                camCoords = vec4(-1021.8, -421.7, 68.14, 27.11),
            },
            {
                pedCoords = vec4(2265.27, 2925.02, -84.8, 267.77),
                camCoords = vec4(2268.24, 2925.02, -84.36, 90.88),
            },
            {
                pedCoords = vec4(-1004.5, -478.51, 50.03, 28.19),
                camCoords = vec4(-1006.36, -476.19, 50.50, 210.38),
            }
        },
    },

    discord = {
        enabled = true, -- This will enable or disable the built in discord rich presence.

        appId = '1024981890798731345', -- This is the Application ID (Replace this with you own)

        largeIcon = { -- To set this up, visit https://forum.cfx.re/t/how-to-updated-discord-rich-presence-custom-image/157686
            icon = 'duck', -- Here you will have to put the image name for the 'large' icon.
            text = 'Qbox Ducky', -- Here you can add hover text for the 'large' icon.
        },

        smallIcon = {
            icon = 'logo_name', -- Here you will have to put the image name for the 'small' icon.
            text = 'This is a small icon with text', -- Here you can add hover text for the 'small' icon.
        },

        firstButton = {
            text = 'Qbox Discord',
            link = 'https://discord.gg/Z6Whda5hHA',
        },

        secondButton = {
            text = 'Main Website',
            link = 'https://www.qbox.re/',
        }
    },

    --- Only used by QB bridge
    hasKeys = function(plate, vehicle)
        return GetResourceState('qbx_vehiclekeys') ~= 'started' or exports.qbx_vehiclekeys:HasKeys(vehicle)
    end,
}
