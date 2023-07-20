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
-- File: weights.lua 
-- Short description: Weight and CG computation
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------
local DEFAULT_CG_PERC = 22.2
local DEFAULT_CG_M    = 20.4509
local EMPTY_WEIGHT    = 46300
local MAC_VALUE_M     = 4.1935

local CG_FWD_CARGO_M  =  9.759
local CG_AFT_CARGO_M  = 30.530
local CG_BULK_CARGO_M = 33.992
local CG_PASS_START   =  5.560
local CG_PASS_END     = 35.960

local CG_WING_TANKS_M = 20.903
local CG_CTR_TANK_M   = 18.595
local CG_ACT_TANK_M   = 13.715
local CG_RCT_TANK_M   = 26.640

-------------------------------------------------------------------------------
-- Datarefs
-------------------------------------------------------------------------------
local dr_payload_weight = globalProperty ("sim/flightmodel/weight/m_fixed")
local dr_CG_pos         = globalProperty ("sim/flightmodel/misc/cgz_ref_to_default")

-------------------------------------------------------------------------------
-- Variables
-------------------------------------------------------------------------------

local curr_weights = {
    fwd_cargo       = 0,
    aft_cargo       = 0,
    bulk_cargo      = 0,
    passengers      = 0,
    passengers_perc = 0.5,
};

local must_reinitialize = true

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------

local function compute_cg(zero_fuel_weight)
    local default_cg = DEFAULT_CG_M * EMPTY_WEIGHT / zero_fuel_weight
    local cargo_fwd_cg  = CG_FWD_CARGO_M  * curr_weights.fwd_cargo  / zero_fuel_weight
    local cargo_aft_cg  = CG_AFT_CARGO_M  * curr_weights.aft_cargo  / zero_fuel_weight
    local cargo_bulk_cg = CG_BULK_CARGO_M * curr_weights.bulk_cargo / zero_fuel_weight

    local passengers_cg = Math_lerp(CG_PASS_START, CG_PASS_END, curr_weights.passengers_perc) * curr_weights.passengers / zero_fuel_weight

    return default_cg + cargo_fwd_cg + cargo_aft_cg + cargo_bulk_cg + passengers_cg
end

local function compute_cg_with_fuel(zero_fuel_weight)
    local cg_without_fuel = compute_cg(zero_fuel_weight)

    local total_fuel = get(FOB)

    if total_fuel > 0 then 

        local wings_fuel_cg = (get(Fuel_quantity[tank_LEFT]) + get(Fuel_quantity[tank_RIGHT])) * CG_WING_TANKS_M / total_fuel
        local ctr_fuel_cg   = get(Fuel_quantity[tank_CENTER]) * CG_CTR_TANK_M / total_fuel
        local act_fuel_cg   = get(Fuel_quantity[tank_ACT]) * CG_ACT_TANK_M / total_fuel
        local rct_fuel_cg   = get(Fuel_quantity[tank_RCT]) * CG_RCT_TANK_M / total_fuel
        local fuel_cg = wings_fuel_cg + ctr_fuel_cg + act_fuel_cg + rct_fuel_cg
        return (cg_without_fuel * zero_fuel_weight + fuel_cg * total_fuel) / (zero_fuel_weight+total_fuel)
    else
        return cg_without_fuel
    end 

end

local function compute_zfw()
    local total_payload = curr_weights.fwd_cargo + curr_weights.aft_cargo + curr_weights.bulk_cargo + curr_weights.passengers
    return EMPTY_WEIGHT + total_payload
end

local function update_xplane_cg()

    -- First of all set the total payload
    local zfw = compute_zfw()
    set(dr_payload_weight, zfw - EMPTY_WEIGHT)


    -- Second, compute the CG and set it (as default with default CG)
    local cg = compute_cg(zfw)
    set(dr_CG_pos, cg - DEFAULT_CG_M)
end

WEIGHTS.set_fwd_cargo_weight = function(kgs)
    assert(kgs)
    assert(kgs >= 0)
    if kgs > WEIGHT_MAX_FWD_CARGO then logWarning("FWD cargo overloaded: " .. tostring(kgs)) end

    curr_weights.fwd_cargo = kgs
    update_xplane_cg()
end

WEIGHTS.get_fwd_cargo_weight = function()
    return curr_weights.fwd_cargo
end

WEIGHTS.set_aft_cargo_weight = function(kgs)
    assert(kgs)
    assert(kgs >= 0)
    if kgs > WEIGHT_MAX_AFT_CARGO then logWarning("AFT cargo overloaded: " .. tostring(kgs)) end

    curr_weights.aft_cargo = kgs
    update_xplane_cg()
end

WEIGHTS.get_aft_cargo_weight = function()
    return curr_weights.aft_cargo
end

WEIGHTS.set_bulk_cargo_weight = function(kgs)
    assert(kgs)
    assert(kgs >= 0)
    if kgs > WEIGHT_MAX_BULK_CARGO then logWarning("Bulk cargo overloaded: " .. tostring(kgs)) end

    curr_weights.bulk_cargo = kgs
    update_xplane_cg()
end

WEIGHTS.get_bulk_cargo_weight = function()
    return curr_weights.bulk_cargo
end

WEIGHTS.set_passengers_weight = function(kgs, pos)
    -- pos: 0 full-fwd (all the passengers one over the other in the first row),
    --      1 full-aft  (all the passengers one over the other in the last row)
    assert(kgs and pos)
    assert(kgs >= 0)
    if kgs > WEIGHT_MAX_PASSENGERS then logWarning("Cabin overloaded") end

    assert(pos >= 0 and pos <= 1)

    curr_weights.passengers      = kgs
    curr_weights.passengers_perc = pos
    update_xplane_cg()
end

WEIGHTS.get_passengers_weight = function()
    return curr_weights.passengers, curr_weights.passengers_perc
end

WEIGHTS.get_current_cg_perc = function()
    -- Return the current CG in percentage with respect to the MAC

    local zfw = compute_zfw()
    local cg = compute_cg_with_fuel(zfw)

    local default_cg_offset = (DEFAULT_CG_PERC / 100 * MAC_VALUE_M)

    return (cg - (DEFAULT_CG_M - default_cg_offset)) / MAC_VALUE_M * 100;
end

local function initialize()
    local payload = get(dr_payload_weight)

    local total_weight = WEIGHT_MAX_PASSENGERS + WEIGHT_MAX_FWD_CARGO + WEIGHT_MAX_AFT_CARGO + WEIGHT_MAX_BULK_CARGO
    payload = math.min(payload, total_weight)
    
    WEIGHTS.set_passengers_weight(payload*WEIGHT_MAX_PASSENGERS/total_weight, 0.5)
    WEIGHTS.set_bulk_cargo_weight(payload*WEIGHT_MAX_BULK_CARGO/total_weight)
    WEIGHTS.set_fwd_cargo_weight(payload*WEIGHT_MAX_FWD_CARGO/total_weight)
    WEIGHTS.set_aft_cargo_weight(payload*WEIGHT_MAX_AFT_CARGO/total_weight)

    EFB.load_page_backpropagate_current_weights()
end

sasl.registerCommandHandler(sasl.findCommand("sim/operation/open_weight_and_balance_window"), 1, function(phase)
    if phase==SASL_COMMAND_END then
        must_reinitialize = true
    end
end)


function update()
    if must_reinitialize then
        initialize()
        must_reinitialize = false
    end
end
