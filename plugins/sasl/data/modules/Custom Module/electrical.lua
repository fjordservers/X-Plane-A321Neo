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
-- File: electrical.lua
-- Short description: Main code of electrical system
-------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------
-- Electrical Logic file
----------------------------------------------------------------------------------------------------

include('ELEC_subcomponents/electrical_batteries.lua')
include('ELEC_subcomponents/electrical_buses.lua')
include('ELEC_subcomponents/electrical_consumptions.lua')
include('ELEC_subcomponents/electrical_generators.lua')
include('ELEC_subcomponents/electrical_tr_and_inv.lua')
include('ELEC_subcomponents/electrical_misc.lua')

local avionics = globalProperty("sim/cockpit2/switches/avionics_power_on")

ELEC_sys.add_power_consumption = function (bus, current_min, current_max)
    ELEC_sys.buses.pwr_consumption[bus] = ELEC_sys.buses.pwr_consumption[bus] + math.random()*(current_max-current_min) + current_min
end

function update_last_power_consumption()

    -- Perform a hard copy
    for i, x in ipairs(ELEC_sys.buses.pwr_consumption) do
        ELEC_sys.buses.pwr_consumption_last[i] = x
    end
end

reset_pwr_consumption()

local function set_overheadl_pwrd()

    -- Any DC source can power the overhead elec panel
    local condition = get(XP_Battery_1) == 1 or get(XP_Battery_2) == 1 
                      or get(DC_bus_1_pwrd) == 1 or get(DC_bus_2_pwrd) == 1
                      or get(DC_ess_bus_pwrd) == 1

    set(OVHR_elec_panel_pwrd, condition and 1 or 0)    

end

function update()
    perf_measure_start("electrical:update()")

    update_generators()
    update_buses()
    update_batteries()
    update_trs_and_inv()
    update_misc()

    update_misc_loads()
    update_trs_loads()
    update_generators_loads()
    update_stinv_loads()
    update_battery_loads()

    -- Let's update the power consumption vector used in drawings
    update_last_power_consumption() 

    reset_pwr_consumption()

    update_consumptions()   -- Check electical_consumptions.lua

    if get(XP_Battery_1) == 1 or get(XP_Battery_2) == 1 then
        set(avionics, 1)
    else
        set(avionics, 0)
    end
    set_overheadl_pwrd()

    perf_measure_stop("electrical:update()")

end

function onAirportLoaded()
    if get(Startup_running) == 1 or get(Capt_ra_alt_ft) > 20 then
        prep_misc_on_flight()
    end
end
