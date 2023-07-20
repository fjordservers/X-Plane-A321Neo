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
-- File: aircond_cabinmodel.lua 
-- Short description: The code for the model of the cabin environment
-------------------------------------------------------------------------------

CKPT = 1
CABIN_FWD = 2
CABIN_AFT = 3
CARGO_AFT = 4

local EXCHANGE_AFT_FWD_RATIO = 0.01  -- How much natural air mix we have from aft to fwd cabin

local FUSELAGE_THERMAL_RESISTANCE = 0.75
local WATT_PER_PEOPLE=100

local SOLAR_GAIN = 0.1

local DRY_AIR_CONSTANT=287.058

local AIRCRAFT_SURFACE = {    -- Veeery approximate
    [CKPT] =  100,
    [CABIN_FWD] = 213.6283,
    [CABIN_AFT] = 213.6283,
    [CARGO_AFT] = 40
}

local AIRCRAFT_VOLUME = {    -- Veeery approximate
    [CKPT] =  50,
    [CABIN_FWD] = 200,
    [CABIN_AFT] = 200,
    [CARGO_AFT] = 25
}

local dr_sun_declination = globalProperty("sim/graphics/scenery/sun_pitch_degrees")
local local_time_sec = globalProperty("sim/time/local_time_sec")
local light_level_r = globalProperty("sim/graphics/misc/outside_light_level_r")
local light_level_g = globalProperty("sim/graphics/misc/outside_light_level_g")
local light_level_b = globalProperty("sim/graphics/misc/outside_light_level_b")

local sun_heat = {0,0,0,0}
local ext_heat = {0,0,0,0}
local people_heat = {0,0,0,0}
local inject_heat= {0,0,0,0}

local internal_air_temp = { get(OTA), get(OTA), get(OTA), get(OTA) }

local function get_solar_irradiance(curr_hour, declination, latitude)
  local declination_rad = math.rad(declination)
  local latitude_rad    = math.rad(latitude)

  local incidence = - math.sin(latitude_rad) * math.sin(declination_rad)
           / math.max(1e-4, math.cos(latitude_rad) * math.cos(declination_rad))

  incidence = math.min(1, math.max(-1, incidence))

  f = math.acos(incidence)
  sunrise_hour = 12 - math.deg(f / 15)
  sunset_hour  = 12 + math.deg(f / 15)

  if curr_hour < sunrise_hour or curr_hour > sunset_hour then
    return 0
  end

  cosw = math.rad(15 * (curr_hour-12))
  sun_elevation = math.asin(math.sin(declination_rad) * math.sin(latitude_rad) + math.cos(declination_rad)* math.sin(latitude_rad)*math.cos(cosw))
  x = math.pow(0.7, 1 / math.max(1e-4, math.cos(math.rad(90) - sun_elevation)))
  s_tot = 1353 * math.pow(x, 0.678)

  return s_tot
end

local function update_sun_heat()
    local sun_declination = get(dr_sun_declination)
    local curr_hour = get(local_time_sec)/60/60
    local latitude = get(Aircraft_lat)
    local perc = (get(light_level_r) + get(light_level_g) + get(light_level_b)) / 3
    
    local sun_heat_per_m2 = perc*get_solar_irradiance(curr_hour, sun_declination, latitude) * SOLAR_GAIN
    sun_heat[CKPT] = AIRCRAFT_SURFACE[CKPT]/4 * sun_heat_per_m2 
    sun_heat[CABIN_FWD] = AIRCRAFT_SURFACE[CABIN_FWD]/4 * sun_heat_per_m2 
    sun_heat[CABIN_AFT] = AIRCRAFT_SURFACE[CABIN_AFT]/4 * sun_heat_per_m2 
    sun_heat[CARGO_AFT] = 0 -- Unless you're flying flipped ;-)
end

local function update_external_exchange(n)
    local external_fus_temp = get(TAT) + 273.15
    local internal_air_temp_K = internal_air_temp[n] + 273.15
    local internal_fus_temp = external_fus_temp/(1+10*FUSELAGE_THERMAL_RESISTANCE)+internal_air_temp_K/(1+1/(10*FUSELAGE_THERMAL_RESISTANCE))
    
    ext_heat[n] = (external_fus_temp-internal_fus_temp)/FUSELAGE_THERMAL_RESISTANCE * AIRCRAFT_SURFACE[n]
end

local function update_people_heat()
    local nr_people = get(Nr_people_onboard)

    people_heat[CKPT]      = 2 * WATT_PER_PEOPLE
    people_heat[CABIN_FWD] = nr_people/2 * WATT_PER_PEOPLE
    people_heat[CABIN_AFT] = nr_people/2 * WATT_PER_PEOPLE
    people_heat[CARGO_AFT] = 0
end

local function update_heat_from_packs(n)

--    local volume_injected = get(DELTA_TIME) * (get(L_pack_Flow_value) + get(R_pack_Flow_value)) / flow_air_density

    local mass_per_area = (get(L_pack_Flow_value) + get(R_pack_Flow_value)) / 3
    if n == CARGO_AFT then
        mass_per_area = (get(L_pack_Flow_value) + get(R_pack_Flow_value)) / 5
    end
    
    local delta_T = get(Aircond_injected_flow_temp, n) - internal_air_temp[n]
    
    inject_heat[n] = delta_T * 1005 * mass_per_area 
    	
end

local function compute_balance(n)
    local total_heat =  inject_heat[n] + people_heat[n] + sun_heat[n] + ext_heat[n]
   
    total_heat = total_heat * get(DELTA_TIME)

    local cabin_pressure   = 29.92*3386.39 - get(Cabin_alt_ft)*3.378431
    
    if cabin_pressure ~= cabin_pressure or cabin_pressure < 1 then
        -- Ok, no, the next formulas doesn't work if your are in the space or for some reason
        -- cabin_pressure is nan ...
        cabin_pressure = 29.92*3386.39
    end
    
    local temp = get(Aircond_injected_flow_temp, n)+273.15
    if temp ~= temp or temp < 100 then
        -- This is for sure an invalid data, sometimes spurious nan or 0 occurs
        temp = 273.15
    end
    
    local flow_air_density = cabin_pressure/(DRY_AIR_CONSTANT*temp)

    local mass_air = flow_air_density * AIRCRAFT_VOLUME[n]
    if mass_air == mass_air and total_heat == total_heat then -- not nan
        internal_air_temp[n] = internal_air_temp[n] + total_heat / (1005 * mass_air)
    end
end

function reset_cabin_model()
    internal_air_temp = { get(OTA), get(OTA), get(OTA), get(OTA) }
end

function update_cabin_model()

    update_sun_heat()
    update_external_exchange(CKPT)
    update_external_exchange(CABIN_FWD)
    update_external_exchange(CABIN_AFT)
    update_external_exchange(CARGO_AFT)
    update_heat_from_packs(CKPT)
    update_heat_from_packs(CABIN_FWD)
    update_heat_from_packs(CABIN_AFT)
    update_heat_from_packs(CARGO_AFT)
    update_people_heat()
    
    -- Air mix between CAB AFT and CAB FWD
    inject_heat[CABIN_FWD] = (1-EXCHANGE_AFT_FWD_RATIO) * inject_heat[CABIN_FWD] + EXCHANGE_AFT_FWD_RATIO * inject_heat[CABIN_AFT]
    inject_heat[CABIN_AFT] = (1-EXCHANGE_AFT_FWD_RATIO) * inject_heat[CABIN_AFT] + EXCHANGE_AFT_FWD_RATIO * inject_heat[CABIN_FWD]
    
    compute_balance(CKPT)
    compute_balance(CABIN_FWD)
    compute_balance(CABIN_AFT)
    compute_balance(CARGO_AFT)




    set(Cockpit_temp, internal_air_temp[CKPT])
    set(Front_cab_temp, internal_air_temp[CABIN_FWD])
    set(Aft_cab_temp, internal_air_temp[CABIN_AFT])
    set(Aft_cargo_temp, internal_air_temp[CARGO_AFT])

end

