-------------------------------------------------------------------------------
-- A32NX Freeware Project
-- Copyright (C) 2020
-------------------------------------------------------------------------------
-- LICENSE: GNU General Public License v3.0
--
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    Please check the LICENSE file in the root of the repository for further
--    details or check <https://www.gnu.org/licenses/>
-------------------------------------------------------------------------------
-- File: source_switching.lua
-- Short description: Display switch logic
-------------------------------------------------------------------------------

--init display positions
for i = 1, 4 do
    set(Capt_pfd_position,        DMC_PFD_CAPT_POS[i], i)
    set(Capt_nd_position,         DMC_ND_CAPT_POS[i],  i)
    set(EWD_displaying_position,  DMC_EWD_POS[i],      i)
    set(ECAM_displaying_position, DMC_ECAM_POS[i],     i)
    set(Fo_pfd_position,          DMC_PFD_FO_POS[i],   i)
    set(Fo_nd_position,           DMC_ND_FO_POS[i],    i)
end

local display_positions = {
    DMC_PFD_CAPT_POS,
    DMC_ND_CAPT_POS,
    DMC_EWD_POS,
    DMC_ECAM_POS,
    DMC_PFD_FO_POS,
    DMC_ND_FO_POS,
}

-- status
local pfd_nd_xfr_capt = false
local pfd_nd_xfr_fo   = false
local ecam_nd_xfr     = 0 -- -1, 0, 1
local eis_selector    = 0 -- -1, 0, 1

local test_start_time = 0

----------------------------------------------------------------------------------------------------
-- Commands
----------------------------------------------------------------------------------------------------

sasl.registerCommandHandler (DMC_PFD_ND_xfr_capt, 0, function(phase) if phase == SASL_COMMAND_BEGIN then pfd_nd_xfr_capt = not pfd_nd_xfr_capt end end)
sasl.registerCommandHandler (DMC_PFD_ND_xfr_fo,   0, function(phase) if phase == SASL_COMMAND_BEGIN then pfd_nd_xfr_fo = not pfd_nd_xfr_fo end end)

sasl.registerCommandHandler (DMC_ECAM_ND_xfr_up, 0, function(phase) if phase == SASL_COMMAND_BEGIN then ecam_nd_xfr = math.min(1,  ecam_nd_xfr + 1) end end)
sasl.registerCommandHandler (DMC_ECAM_ND_xfr_dn, 0, function(phase) if phase == SASL_COMMAND_BEGIN then ecam_nd_xfr = math.max(-1, ecam_nd_xfr - 1) end end)

sasl.registerCommandHandler (DMC_EIS_selector_up, 0, function(phase) if phase == SASL_COMMAND_BEGIN then eis_selector = math.min(1, eis_selector + 1) end end)
sasl.registerCommandHandler (DMC_EIS_selector_dn, 0, function(phase) if phase == SASL_COMMAND_BEGIN then eis_selector = math.max(-1,  eis_selector - 1) end end)

sasl.registerCommandHandler (MCDU_DMC_cmd_test_1, 0, function(phase) if phase == SASL_COMMAND_BEGIN then test_start_time = get(TIME); set(DMC_which_test_in_progress, 1) end end)
sasl.registerCommandHandler (MCDU_DMC_cmd_test_2, 0, function(phase) if phase == SASL_COMMAND_BEGIN then test_start_time = get(TIME); set(DMC_which_test_in_progress, 2) end end)
sasl.registerCommandHandler (MCDU_DMC_cmd_test_3, 0, function(phase) if phase == SASL_COMMAND_BEGIN then test_start_time = get(TIME); set(DMC_which_test_in_progress, 3) end end)

----------------------------------------------------------------------------------------------------
-- Functions
----------------------------------------------------------------------------------------------------
local function auto_update()

    -- Default modes
    set(Capt_pfd_displaying_status, DMC_PFD_CAPT)
    set(Capt_nd_displaying_status,  DMC_ND_CAPT)
    set(Fo_pfd_displaying_status,   DMC_PFD_FO)
    set(Fo_nd_displaying_status,    DMC_ND_FO)
    set(EWD_displaying_status,      DMC_EWD)
    set(ECAM_displaying_status,     DMC_ECAM)


    -- CAPT PFD
    local pfd_auto_transfer_capt = get(Capt_PFD_brightness_act) < 0.01 or get(FAILURE_DISPLAY_CAPT_PFD) == 1
    
    if pfd_auto_transfer_capt ~= pfd_nd_xfr_capt then
        set(Capt_pfd_displaying_status, DMC_ND_CAPT)
    else
        set(Capt_pfd_displaying_status, DMC_PFD_CAPT)
    end
    
    -- CAPT ND
    if ecam_nd_xfr == -1 then 
        set(Capt_nd_displaying_status, DMC_ECAM) -- This is actually hidden
    else
        if pfd_auto_transfer_capt ~= pfd_nd_xfr_capt then
            set(Capt_nd_displaying_status, DMC_PFD_CAPT)
        else
            set(Capt_nd_displaying_status, DMC_ND_CAPT)
        end
    end

    -- FO PFD
    local pfd_auto_transfer_fo = get(Fo_PFD_brightness_act) < 0.01 or get(FAILURE_DISPLAY_FO_PFD) == 1
    
    if pfd_auto_transfer_fo ~= pfd_nd_xfr_fo then
        set(Fo_pfd_displaying_status, DMC_ND_FO)
    else
        set(Fo_pfd_displaying_status, DMC_PFD_FO)
    end
    
    -- FO ND
    if ecam_nd_xfr == 1 then 
        set(Fo_nd_displaying_status, DMC_ECAM) -- This is actually hidden
    else
        if pfd_auto_transfer_fo ~= pfd_nd_xfr_fo then
            set(Fo_nd_displaying_status, DMC_PFD_FO)
        else
            set(Fo_nd_displaying_status, DMC_ND_FO)
        end
    end

    set(DMC_ECAM_can_override_EWD, ((get(ECAM_brightness_act) < 0.01 or get(FAILURE_DISPLAY_ECAM) == 1) and ecam_nd_xfr == 0) and 1 or 0)

    -- EWD
    local is_EWD_replacing_ECAM = (get(DMC_requiring_ECAM_EWD_swap) == 0 and (get(EWD_brightness_act) < 0.01 or get(FAILURE_DISPLAY_EWD) == 1))
                               or (get(DMC_requiring_ECAM_EWD_swap) == 1 and get(DMC_ECAM_can_override_EWD) == 1)
    if is_EWD_replacing_ECAM then
        if ecam_nd_xfr == 0 then
            set(EWD_displaying_status,      DMC_ECAM)
        elseif ecam_nd_xfr == -1 then
            set(EWD_displaying_status,      pfd_auto_transfer_capt ~= pfd_nd_xfr_capt and DMC_PFD_CAPT or DMC_ND_CAPT)
        elseif ecam_nd_xfr == 1  then
            set(EWD_displaying_status,      pfd_auto_transfer_fo   ~= pfd_nd_xfr_fo   and DMC_PFD_FO or DMC_ND_FO)
        end
    end

    -- ECAM
    if is_EWD_replacing_ECAM then
        set(ECAM_displaying_status, DMC_EWD)
    else
        if ecam_nd_xfr == -1 then
            set(ECAM_displaying_status,      pfd_auto_transfer_capt ~= pfd_nd_xfr_capt and DMC_PFD_CAPT or DMC_ND_CAPT)
        elseif ecam_nd_xfr == 1  then
            set(ECAM_displaying_status,      pfd_auto_transfer_fo   ~= pfd_nd_xfr_fo   and DMC_PFD_FO or DMC_ND_FO)
        end
    end
    
end

local function update_display_position()
    for i = 1, 4 do
        set(Capt_pfd_position,        display_positions[get(Capt_pfd_displaying_status)][i], i)
        set(Capt_nd_position,         display_positions[get(Capt_nd_displaying_status )][i], i)
        set(EWD_displaying_position,  display_positions[get(EWD_displaying_status     )][i], i)
        set(ECAM_displaying_position, display_positions[get(ECAM_displaying_status    )][i], i)
        set(Fo_pfd_position,          display_positions[get(Fo_pfd_displaying_status  )][i], i)
        set(Fo_nd_position,           display_positions[get(Fo_nd_displaying_status   )][i], i)
    end
end

local function update_knobs()

    Set_dataref_linear_anim_nostop(DMC_position_ecam_nd, ecam_nd_xfr, -1, 1, 10)
    Set_dataref_linear_anim_nostop(DMC_position_dmc_eis, eis_selector, -1, 1, 10)

end

local function update_dmc_status_maintain()

    local mode = 2

    if get(DMC_which_test_in_progress) > 0 then
        if get(TIME) - test_start_time > 20 then
            test_start_time = 0
            set(DMC_which_test_in_progress, 0)
        elseif get(TIME) - test_start_time < 3 then
            mode = 4
        end
    end
    if get(mcdu_page) == 1302 or get(mcdu_page) == 1303 then
        set(Capt_pfd_valid, 3)
        set(Capt_nd_valid,  3)
        set(Fo_pfd_valid,   3)
        set(Fo_nd_valid,    3)
        set(EWD_valid,      3)
        set(ECAM_valid,     3)
    end

    if get(DMC_which_test_in_progress) == 1 and eis_selector >= 0 then
        set(Capt_pfd_valid, mode)
        set(Capt_nd_valid,  mode)
        set(EWD_valid,      mode)
        set(ECAM_valid,     mode)
    end
    if get(DMC_which_test_in_progress) == 2 and eis_selector <= 0 then
        set(Fo_pfd_valid, mode)
        set(Fo_nd_valid,  mode)
        set(EWD_valid,    mode)
        set(ECAM_valid,   mode)
    end
    if get(DMC_which_test_in_progress) == 3 and eis_selector > 0 then
        set(Fo_pfd_valid, mode)
        set(Fo_nd_valid,  mode)
    end
    if get(DMC_which_test_in_progress) == 3 and eis_selector < 0 then
        set(Capt_pfd_valid, mode)
        set(Capt_nd_valid,  mode)
    end

end

local function update_dmc_status()
    set(Capt_pfd_valid, 1)
    set(Capt_nd_valid,  1)
    set(Fo_pfd_valid,   1)
    set(Fo_nd_valid,    1)
    set(EWD_valid,      1)
    set(ECAM_valid,     1)

    -- Show ECAM ON ND if XFR knob is not normal
    if ecam_nd_xfr ~= 0 then
        set(ECAM_valid,     6)
    end

    -- Maintenance mode & test
    update_dmc_status_maintain()

    local dmc_1_fail = get(FAILURE_DISPLAY_DMC_1) == 1 or get(AC_ess_bus_pwrd) == 0
    local dmc_2_fail = get(FAILURE_DISPLAY_DMC_2) == 1 or get(AC_bus_2_pwrd) == 0
    local dmc_3_fail = get(FAILURE_DISPLAY_DMC_3) == 1 or not (get(AC_bus_1_pwrd) == 1 or (eis_selector == -1 and get(AC_ess_bus_pwrd) == 1))

    if eis_selector >= 0 and dmc_1_fail then
        set(Capt_pfd_valid, 0)
        set(Capt_nd_valid,  0)
    end

    if eis_selector <= 0 and dmc_2_fail then
        set(Fo_pfd_valid, 0)
        set(Fo_nd_valid,  0)
    end

    if eis_selector == -1 and dmc_3_fail then
        set(Capt_pfd_valid, 0)
        set(Capt_nd_valid,  0)
    end

    if eis_selector == 1 and dmc_3_fail then
        set(Fo_pfd_valid, 0)
        set(Fo_nd_valid,  0)
    end

    if (eis_selector == 0 and dmc_1_fail and dmc_2_fail) or (eis_selector == 1 and dmc_3_fail and dmc_1_fail) or (eis_selector == -1 and dmc_2_fail and dmc_3_fail) then
        set(EWD_valid,  0)
        set(ECAM_valid,  0)
    end

    if get(FAILURE_DISPLAY_CAPT_PFD) == 1 then
        set(Capt_pfd_valid, 7)
    end
    if get(FAILURE_DISPLAY_CAPT_ND) == 1 then
        set(Capt_nd_valid, 7)
    end
    if get(FAILURE_DISPLAY_FO_PFD) == 1 then
        set(Fo_pfd_valid, 7)
    end
    if get(FAILURE_DISPLAY_FO_ND) == 1 then
        set(Fo_nd_valid, 7)
    end
    if get(FAILURE_DISPLAY_EWD) == 1 then
        set(EWD_valid, 7)
    end
    if get(FAILURE_DISPLAY_ECAM) == 1 then
        set(ECAM_valid, 7)
    end

end

function update()

    auto_update()

    update_knobs()
    update_dmc_status()

    update_display_position()
end
