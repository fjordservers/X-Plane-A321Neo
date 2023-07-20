
local function is_ap_working(i) -- 1 or 2

    if get(FAILURE_AP, i) == 1 then
        return false -- AP Failed
    end

    if (i == 1 and get(DC_shed_ess_pwrd) == 0) or (i == 2 and get(DC_bus_2_pwrd) == 0) then
        return false -- No elec power
    end

    local how_many_hyd_failed = (get(Hydraulic_G_press) <= 1450 and 1 or 0) +
                                (get(Hydraulic_B_press) <= 1450 and 1 or 0) +
                                (get(Hydraulic_Y_press) <= 1450 and 1 or 0)
    if how_many_hyd_failed >= 2 then
        -- Double or triple HYD failure
        return false
    end

    if get(FAILURE_GEAR_LGIU1) + get(FAILURE_GEAR_LGIU1) == 2 then
        -- TODO: Jon adds "if in LAND mode, it works"
        return false
    end

    if adirs_how_many_adrs_work() < 2 or adirs_how_many_adr_params_disagree() > 1 then
        return false -- ADR failures
    end

    if adirs_how_many_irs_fully_work() < 2 or adirs_how_many_ir_params_disagree() > 1 then
        return false -- IR failures
    end

    -- TODO: ricorico
    -- ALL ENGINES FAILURE

    -- TODO: Jon
    -- FAC 1 + 2
    -- FCU 1 + 2
    -- RUD TRIM SYS
    -- YAW DAMPER SYS
    -- ELAC 1 + 2
    -- SLATS AND FLAPS FAULT IN CONF 0 (only if BOTH *SLAT* CHANNELS failed)
    -- FLAPS FAULT/LOCKED (only if  BOTH CHANNELS failed)
    -- L or R ELEV FAULT
    -- STABILIZER JAM

    return true
end

local function is_at_working()
    --TODO: one or more FMGC avail

    if get(FAC_1_status) + get(FAC_2_status) < 1 then
        return false --less than one FAC
    end

    if adirs_how_many_adrs_work() < 2 then
        return false --less than one FAC
    end

    if not get(FAILURE_ENG_FADEC_CH1) == 0 and get(FAILURE_ENG_FADEC_CH2) == 0 and get(Eng_1_FADEC_powered) == 1 and get(Eng_2_FADEC_powered) == 1 then
        return false -- FADEC failure
    end

    --TODO: at least one channel of FCU

    if get(Wheel_status_LGCIU_1) + get(Wheel_status_LGCIU_2) < 1 then
        return false
    end

    --TODO: not manually disabled
end