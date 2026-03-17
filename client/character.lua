local config = require 'config.client'
local defaultSpawn = require 'config.shared'.defaultSpawn

if config.characters.useExternalCharacters then return end

local previewCam
local randomLocation = config.characters.locations[math.random(1, #config.characters.locations)]

local randomPeds = {
    {
        model = `mp_m_freemode_01`,
        headOverlays = {
            beard = {color = 0, style = 0, secondColor = 0, opacity = 1},
            complexion = {color = 0, style = 0, secondColor = 0, opacity = 0},
            bodyBlemishes = {color = 0, style = 0, secondColor = 0, opacity = 0},
            blush = {color = 0, style = 0, secondColor = 0, opacity = 0},
            lipstick = {color = 0, style = 0, secondColor = 0, opacity = 0},
            blemishes = {color = 0, style = 0, secondColor = 0, opacity = 0},
            eyebrows = {color = 0, style = 0, secondColor = 0, opacity = 1},
            makeUp = {color = 0, style = 0, secondColor = 0, opacity = 0},
            sunDamage = {color = 0, style = 0, secondColor = 0, opacity = 0},
            moleAndFreckles = {color = 0, style = 0, secondColor = 0, opacity = 0},
            chestHair = {color = 0, style = 0, secondColor = 0, opacity = 1},
            ageing = {color = 0, style = 0, secondColor = 0, opacity = 1},
        },
        components = {
            {texture = 0, drawable = 0, component_id = 0},
            {texture = 0, drawable = 0, component_id = 1},
            {texture = 0, drawable = 0, component_id = 2},
            {texture = 0, drawable = 0, component_id = 5},
            {texture = 0, drawable = 0, component_id = 7},
            {texture = 0, drawable = 0, component_id = 9},
            {texture = 0, drawable = 0, component_id = 10},
            {texture = 0, drawable = 15, component_id = 11},
            {texture = 0, drawable = 15, component_id = 8},
            {texture = 0, drawable = 15, component_id = 3},
            {texture = 0, drawable = 34, component_id = 6},
            {texture = 0, drawable = 61, component_id = 4},
        },
        props = {
            {prop_id = 0, drawable = -1, texture = -1},
            {prop_id = 1, drawable = -1, texture = -1},
            {prop_id = 2, drawable = -1, texture = -1},
            {prop_id = 6, drawable = -1, texture = -1},
            {prop_id = 7, drawable = -1, texture = -1},
        }
    },
    {
        model = `mp_f_freemode_01`,
        headBlend = {
            shapeMix = 0.3,
            skinFirst = 0,
            shapeFirst = 31,
            skinSecond = 0,
            shapeSecond = 0,
            skinMix = 0,
            thirdMix = 0,
            shapeThird = 0,
            skinThird = 0,
        },
        hair = {
            color = 0,
            style = 15,
            texture = 0,
            highlight = 0
        },
        headOverlays = {
            chestHair = {secondColor = 0, opacity = 0, color = 0, style = 0},
            bodyBlemishes = {secondColor = 0, opacity = 0, color = 0, style = 0},
            beard = {secondColor = 0, opacity = 0, color = 0, style = 0},
            lipstick = {secondColor = 0, opacity = 0, color = 0, style = 0},
            complexion = {secondColor = 0, opacity = 0, color = 0, style = 0},
            blemishes = {secondColor = 0, opacity = 0, color = 0, style = 0},
            moleAndFreckles = {secondColor = 0, opacity = 0, color = 0, style = 0},
            makeUp = {secondColor = 0, opacity = 0, color = 0, style = 0},
            ageing = {secondColor = 0, opacity = 1, color = 0, style = 0},
            eyebrows = {secondColor = 0, opacity = 1, color = 0, style = 0},
            blush = {secondColor = 0, opacity = 0, color = 0, style = 0},
            sunDamage = {secondColor = 0, opacity = 0, color = 0, style = 0},
        },
        components = {
            {drawable = 0, component_id = 0, texture = 0},
            {drawable = 0, component_id = 1, texture = 0},
            {drawable = 0, component_id = 2, texture = 0},
            {drawable = 0, component_id = 5, texture = 0},
            {drawable = 0, component_id = 7, texture = 0},
            {drawable = 0, component_id = 9, texture = 0},
            {drawable = 0, component_id = 10, texture = 0},
            {drawable = 15, component_id = 3, texture = 0},
            {drawable = 15, component_id = 11, texture = 3},
            {drawable = 14, component_id = 8, texture = 0},
            {drawable = 15, component_id = 4, texture = 3},
            {drawable = 35, component_id = 6, texture = 0},
        },
        props = {
            {prop_id = 0, drawable = -1, texture = -1},
            {prop_id = 1, drawable = -1, texture = -1},
            {prop_id = 2, drawable = -1, texture = -1},
            {prop_id = 6, drawable = -1, texture = -1},
            {prop_id = 7, drawable = -1, texture = -1},
        }
    }
}

NetworkStartSoloTutorialSession()

local function setupPreviewCam()
    DoScreenFadeIn(1000)
    SetTimecycleModifier('hud_def_blur')
    SetTimecycleModifierStrength(1.0)
    FreezeEntityPosition(cache.ped, false)
    previewCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', randomLocation.camCoords.x, randomLocation.camCoords.y, randomLocation.camCoords.z, -6.0, 0.0, randomLocation.camCoords.w, 40.0, false, 0)
    SetCamActive(previewCam, true)
    SetCamUseShallowDofMode(previewCam, true)
    SetCamNearDof(previewCam, 0.4)
    SetCamFarDof(previewCam, 1.8)
    SetCamDofStrength(previewCam, 0.7)
    RenderScriptCams(true, false, 1, true, true)
    CreateThread(function()
        while DoesCamExist(previewCam) do
            SetUseHiDof()
            Wait(0)
        end
    end)
end

local function destroyPreviewCam()
    if not previewCam then return end

    SetTimecycleModifier('default')
    SetCamActive(previewCam, false)
    DestroyCam(previewCam, true)
    RenderScriptCams(false, false, 1, true, true)
    FreezeEntityPosition(cache.ped, false)
    DisplayRadar(true)
    previewCam = nil
end

local function randomPed()
    local ped = randomPeds[math.random(1, #randomPeds)]
    lib.requestModel(ped.model, config.loadingModelsTimeout)
    SetPlayerModel(cache.playerId, ped.model)
    pcall(function() exports['illenium-appearance']:setPedAppearance(PlayerPedId(), ped) end)
    SetModelAsNoLongerNeeded(ped.model)
end

---@param citizenId? string
local function previewPed(citizenId)
    if not citizenId then randomPed() return end

    local clothing, model = lib.callback.await('qbx_core:server:getPreviewPedData', false, citizenId)
    if model and clothing then
        lib.requestModel(model, config.loadingModelsTimeout)
        SetPlayerModel(cache.playerId, model)
        pcall(function() exports['illenium-appearance']:setPedAppearance(PlayerPedId(), json.decode(clothing)) end)
        SetModelAsNoLongerNeeded(model)
    else
        randomPed()
    end
end

---@param dialog string[]
---@param input integer
---@return boolean
local function checkStrings(dialog, input)
    local str = dialog[input]
    if config.characters.profanityWords[str:lower()] then return false end

    local split = {string.strsplit(' ', str)}
    if #split > 5 then return false end

    for i = 1, #split do
        local word = split[i]
        if config.characters.profanityWords[word:lower()] then return false end
    end

    return true
end

---@param str string
---@return boolean
local function validateField(str)
    if not str or str == '' then return false end
    return checkStrings({str}, 1)
end

-- @param str string
-- @return string?
local function capString(str)
    return str:gsub("(%w)([%w']*)", function(first, rest)
        return first:upper() .. rest:lower()
    end)
end

local function cityTour()
    if not config.characters.cityTour.enabled then return end

    while not IsScreenFadedOut() do
        Wait(0)
    end

    local tourCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

    for _, location in ipairs(config.characters.cityTour.locations) do
        SetCamCoord(tourCam, location.camCoords.x, location.camCoords.y, location.camCoords.z)
        PointCamAtCoord(tourCam, location.pointAt.x, location.pointAt.y, location.pointAt.z)
        RenderScriptCams(true, false, 0, true, true)

        DoScreenFadeIn(500)
        while not IsScreenFadedIn() do
            Wait(0)
        end

        Notify(location.title, 'info', location.duration, location.description, 'top')

        Wait(location.duration)

        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Wait(0)
        end
    end

    SetCamActive(tourCam, false)
    DestroyCam(tourCam, true)
    RenderScriptCams(false, false, 0, true, true)
end

local function spawnDefault() -- We use a callback to make the server wait on this to be done
    DoScreenFadeOut(500)

    while not IsScreenFadedOut() do
        Wait(0)
    end

    destroyPreviewCam()

    pcall(function() exports.spawnmanager:spawnPlayer({
        x = defaultSpawn.x,
        y = defaultSpawn.y,
        z = defaultSpawn.z,
        heading = defaultSpawn.w
    }) end)

    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
    TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
    TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)

    while not IsScreenFadedIn() do
        Wait(0)
    end
    TriggerEvent('qb-clothes:client:CreateFirstCharacter')
end

local function spawnLastLocation()
    DoScreenFadeOut(500)

    while not IsScreenFadedOut() do
        Wait(0)
    end

    destroyPreviewCam()

    pcall(function() exports.spawnmanager:spawnPlayer({
        x = QBX.PlayerData.position.x,
        y = QBX.PlayerData.position.y,
        z = QBX.PlayerData.position.z,
        heading = QBX.PlayerData.position.w
    }) end)

    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
    TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
    TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)

    while not IsScreenFadedIn() do
        Wait(0)
    end
end

---@param characters PlayerEntity[]
---@param amount integer
---@return table
local function buildCharacterData(characters, amount)
    local data = {}
    for i = 1, amount do
        local character = characters[i]
        if character then
            data[i] = {
                slot        = i,
                citizenid   = character.citizenid,
                firstname   = character.charinfo.firstname,
                lastname    = character.charinfo.lastname,
                gender      = character.charinfo.gender,
                birthdate   = character.charinfo.birthdate,
                nationality = character.charinfo.nationality,
                account     = character.charinfo.account,
                phone       = character.charinfo.phone,
                bank        = character.money.bank,
                cash        = character.money.cash,
                job         = character.job.label,
                jobGrade    = character.job.grade.name,
                gang        = character.gang.label,
                gangGrade   = character.gang.grade.name,
            }
        else
            data[i] = { slot = i, empty = true }
        end
    end
    return data
end

-- ── NUI Callbacks ──────────────────────────────────────────────────────────

RegisterNUICallback('multichar_preview', function(data, cb)
    previewPed(data.citizenid)
    cb({})
end)

RegisterNUICallback('multichar_play', function(data, cb)
    DoScreenFadeOut(10)
    lib.callback.await('qbx_core:server:loadCharacter', false, data.citizenid)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
    if GetResourceState('qbx_apartments'):find('start') then
        TriggerEvent('apartments:client:setupSpawnUI', data.citizenid)
    elseif GetResourceState('qbx_spawn'):find('start') then
        TriggerEvent('qb-spawn:client:setupSpawns', data.citizenid)
        TriggerEvent('qb-spawn:client:openUI', true)
    else
        spawnLastLocation()
    end
    destroyPreviewCam()
    cb({})
end)

RegisterNUICallback('multichar_delete', function(data, cb)
    local success = lib.callback.await('qbx_core:server:deleteCharacter', false, data.citizenid)
    if success then
        Notify(locale('success.character_deleted'), 'success')
        local characters, amount = lib.callback.await('qbx_core:server:getCharacters')
        local characterData = buildCharacterData(characters, amount)
        SendNUIMessage({ action = 'refresh', characters = characterData, amount = amount })
        -- Use refreshed characterData to avoid stale references after deletion
        previewPed(characterData[1] and not characterData[1].empty and characterData[1].citizenid)
    else
        Notify(locale('error.character_delete_failed'), 'error')
    end
    cb({ success = success })
end)

RegisterNUICallback('multichar_create', function(data, cb)
    -- Validate text fields against profanity and format rules.
    -- birthdate is already constrained by the date input min/max on the client, and
    -- gender is always 0 or 1 so neither requires profanity/format validation.
    for _, field in ipairs({ data.firstname, data.lastname, data.nationality }) do
        if not validateField(field) then
            cb({ error = locale('error.no_match_character_registration') })
            return
        end
    end

    DoScreenFadeOut(150)
    local newData = lib.callback.await('qbx_core:server:createCharacter', false, {
        firstname   = capString(data.firstname),
        lastname    = capString(data.lastname),
        nationality = capString(data.nationality),
        gender      = tonumber(data.gender),
        birthdate   = data.birthdate,
        cid         = data.slot
    })

    if not newData then
        DoScreenFadeIn(500)
        cb({ error = locale('error.no_match_character_registration') })
        return
    end

    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
    destroyPreviewCam()

    cityTour()

    if GetResourceState('qbx_spawn') == 'missing' then
        spawnDefault()
    else
        if config.characters.startingApartment then
            TriggerEvent('apartments:client:setupSpawnUI', newData)
        else
            TriggerEvent('qbx_core:client:spawnNoApartments')
        end
    end

    cb({})
end)

-- ── Main Character Selection ───────────────────────────────────────────────

local function chooseCharacter()
    ---@type PlayerEntity[], integer
    local characters, amount = lib.callback.await('qbx_core:server:getCharacters')
    local firstCharacterCitizenId = characters[1] and characters[1].citizenid
    previewPed(firstCharacterCitizenId)

    randomLocation = config.characters.locations[math.random(1, #config.characters.locations)]
    SetFollowPedCamViewMode(2)
    DisplayRadar(false)

    DoScreenFadeOut(500)

    while not IsScreenFadedOut() and cache.ped ~= PlayerPedId()  do
        Wait(0)
    end

    FreezeEntityPosition(cache.ped, true)
    Wait(1000)
    SetEntityCoords(cache.ped, randomLocation.pedCoords.x, randomLocation.pedCoords.y, randomLocation.pedCoords.z, false, false, false, false)
    SetEntityHeading(cache.ped, randomLocation.pedCoords.w)

    NetworkStartSoloTutorialSession()

    while not NetworkIsInTutorialSession() do
        Wait(0)
    end

    Wait(1500)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    setupPreviewCam()

    local nationalityList = config.characters.limitNationalities and lib.load('data.nationalities') or nil
    local characterData   = buildCharacterData(characters, amount)

    SendNUIMessage({
        action             = 'show',
        characters         = characterData,
        amount             = amount,
        enableDelete       = config.characters.enableDeleteButton,
        nationalities      = nationalityList,
        limitNationalities = config.characters.limitNationalities,
        dateMin            = config.characters.dateMin,
        dateMax            = config.characters.dateMax,
        dateFormat         = config.characters.dateFormat,
    })
    SetNuiFocus(true, true)
end

RegisterNetEvent('qbx_core:client:spawnNoApartments', function() -- This event is only for no starting apartments
    DoScreenFadeOut(500)
    Wait(2000)
    SetEntityCoords(cache.ped, defaultSpawn.x, defaultSpawn.y, defaultSpawn.z, false, false, false, false)
    SetEntityHeading(cache.ped, defaultSpawn.w)
    Wait(500)
    destroyPreviewCam()
    SetEntityVisible(cache.ped, true, false)
    Wait(500)
    DoScreenFadeIn(250)
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
    TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
    TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
    TriggerEvent('qb-weathersync:client:EnableSync')
    TriggerEvent('qb-clothes:client:CreateFirstCharacter')
end)

RegisterNetEvent('qbx_core:client:playerLoggedOut', function()
    if GetInvokingResource() then return end -- Make sure this can only be triggered from the server
    chooseCharacter()
end)

CreateThread(function()
    while true do
        Wait(0)
        if NetworkIsSessionStarted() then
            pcall(function() exports.spawnmanager:setAutoSpawn(false) end)
            Wait(250)
            chooseCharacter()
            break
        end
    end
    -- since people apparently die during char select. Since SetEntityInvincible is notoriously unreliable, we'll just loop it to be safe. shrug
    while NetworkIsInTutorialSession() do
        SetEntityInvincible(PlayerPedId(), true)
        Wait(250)
    end
    SetEntityInvincible(PlayerPedId(), false)
end)
