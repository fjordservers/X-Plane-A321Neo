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
-- File: pushbuttons.lua
-- Short description: Miscellanea related to graphics
-------------------------------------------------------------------------------

-- WARNING: This is a global file, pay attention when you declare new non-local variables or
-- functions, they will be defined in EVERY file!

----------------------------------------------------------------------------------------------------
-- Constants and variables
----------------------------------------------------------------------------------------------------

local DR_PATH_PREFIX = "a321neo/cockpit"
local DR_PATH_PREFIX_OVH = "overhead"
local DR_PATH_PREFIX_PEDESTAL = "pedestal"
local DR_PATH_PREFIX_MIP = "mip"
local DR_PATH_PREFIX_GLARESHIELD = "glareshield"
local DR_PATH_PREFIX_FCU = "fcu"
local DR_PATH_SUFFIX_TOP = "_top"
local DR_PATH_SUFFIX_BTM = "_bottom"

local BRIGHTNESS_HALF = 0.5
local BRIGHTNESS_FULL = 1

local ELEC_ALWAYS_ON = 0 -- The button has always power or it has special behaviour (like ext pwr)
local LIGHT_BUS_DC   = 1 -- Button is powered when any DC bus is available
local LIGHT_BUS_AC   = 2 -- Button is powered when any AC bus is available

PB = {

    -- OVERHEAD PANEL
    ovhd = {

        -- ELECTRICAL
        elec_battery_1 = {
            -- Example - two datarefs will be created:
            -- - a321neo/cockpit/overhead/elec_battery_1_top
            -- - a321neo/cockpit/overhead/elec_battery_1_bottom
            bus = LIGHT_BUS_DC        
        },
        elec_battery_2 = {bus = LIGHT_BUS_DC},
        elec_galley    = {bus = LIGHT_BUS_DC},
        elec_ac_ess    = {bus = LIGHT_BUS_DC},
        elec_bus_tie   = {bus = LIGHT_BUS_DC},
        elec_gen1_line = {bus = LIGHT_BUS_DC},
        elec_idg1      = {bus = LIGHT_BUS_DC},
        elec_idg2      = {bus = LIGHT_BUS_DC},
        elec_gen1      = {bus = LIGHT_BUS_DC},
        elec_gen2      = {bus = LIGHT_BUS_DC},
        elec_apu_gen   = {bus = LIGHT_BUS_DC},
        elec_ext_pwr   = {bus = ELEC_ALWAYS_ON},
        elec_rat_fault = {bus = LIGHT_BUS_DC},

        -- ANTI-ICE
        antiice_wings = {bus = LIGHT_BUS_DC},
        antiice_eng_1 = {bus = LIGHT_BUS_DC},
        antiice_eng_2 = {bus = LIGHT_BUS_DC},
        antiice_probes= {bus = LIGHT_BUS_DC},

        -- HYD
        hyd_eng1      = {bus = LIGHT_BUS_DC},
        hyd_eng2      = {bus = LIGHT_BUS_DC},
        hyd_elec_Y    = {bus = LIGHT_BUS_AC},
        hyd_elec_B    = {bus = LIGHT_BUS_AC},
        hyd_PTU       = {bus = LIGHT_BUS_DC},

        -- ADIRS
        adr_1   = {bus = LIGHT_BUS_DC},
        adr_2   = {bus = LIGHT_BUS_DC},
        adr_3   = {bus = LIGHT_BUS_DC},
        ir_1    = {bus = LIGHT_BUS_DC},
        ir_2    = {bus = LIGHT_BUS_DC},
        ir_3    = {bus = LIGHT_BUS_DC},

        -- FUEL
        fuel_L_1   = {bus = LIGHT_BUS_AC},
        fuel_L_2   = {bus = LIGHT_BUS_AC},
        fuel_R_1   = {bus = LIGHT_BUS_AC},
        fuel_R_2   = {bus = LIGHT_BUS_AC},
        fuel_C_L   = {bus = LIGHT_BUS_AC},
        fuel_C_R   = {bus = LIGHT_BUS_AC},
        fuel_ACT   = {bus = LIGHT_BUS_AC},
        fuel_RCT   = {bus = LIGHT_BUS_AC},
        fuel_XFEED    = {bus = LIGHT_BUS_DC},
        fuel_MODE_SEL = {bus = LIGHT_BUS_DC},

        -- Aircond
        ac_econ_flow = {bus = LIGHT_BUS_DC},
        ac_pack_1    = {bus = LIGHT_BUS_DC},
        ac_pack_2    = {bus = LIGHT_BUS_DC},
        ac_bleed_1   = {bus = LIGHT_BUS_DC},
        ac_bleed_2   = {bus = LIGHT_BUS_DC},
        ac_bleed_apu = {bus = LIGHT_BUS_DC},
        ac_ram_air   = {bus = LIGHT_BUS_DC},
        ac_hot_air   = {bus = LIGHT_BUS_DC},

        -- Pressurization
        press_mode_sel = {bus = LIGHT_BUS_DC},
        press_ditching = {bus = LIGHT_BUS_DC},

        -- APU
        apu_master = {bus = LIGHT_BUS_DC}, 
        apu_start  = {bus = LIGHT_BUS_DC}, 

        -- SIGNS
        signs_emer_exit_lt = {bus = LIGHT_BUS_DC},

        -- FIRE
        fire_eng_1_ag_1 = {bus = LIGHT_BUS_DC},
        fire_eng_1_ag_2 = {bus = LIGHT_BUS_DC},
        fire_eng_2_ag_1 = {bus = LIGHT_BUS_DC},
        fire_eng_2_ag_2 = {bus = LIGHT_BUS_DC},
        fire_apu_ag     = {bus = LIGHT_BUS_DC},
        fire_apu_block  = {bus = LIGHT_BUS_DC},
        fire_eng1_block = {bus = LIGHT_BUS_DC},
        fire_eng2_block = {bus = LIGHT_BUS_DC},
        
        -- FLT CTL
        flt_ctl_elac_1 = {bus = LIGHT_BUS_DC},
        flt_ctl_sec_1  = {bus = LIGHT_BUS_DC},
        flt_ctl_fac_1  = {bus = LIGHT_BUS_DC},
        flt_ctl_elac_2 = {bus = LIGHT_BUS_AC},-- This is actually on DC but powered when we have AC
        flt_ctl_sec_2  = {bus = LIGHT_BUS_AC},-- This is actually on DC but powered when we have AC
        flt_ctl_fac_2  = {bus = LIGHT_BUS_AC},-- This is actually on DC but powered when we have AC
        flt_ctl_sec_3  = {bus = LIGHT_BUS_AC},-- This is actually on DC but powered when we have AC

        -- EVAC
        evac_cmd       = {bus = LIGHT_BUS_DC},

        -- GPWS
        gpws_terr       = {bus = LIGHT_BUS_AC},
        gpws_sys        = {bus = LIGHT_BUS_AC},
        gpws_gs_mode    = {bus = LIGHT_BUS_AC},
        gpws_flap_mode  = {bus = LIGHT_BUS_AC},
        gpws_ldg_flap_3 = {bus = LIGHT_BUS_AC},

        -- RCDR
        rcdr_gnd_ctl    = {bus = LIGHT_BUS_AC},

        -- OXY
        oxy_high_alt_land= {bus = LIGHT_BUS_AC},
        oxy_passengers   = {bus = LIGHT_BUS_AC},
        oxy_crew_supply  = {bus = LIGHT_BUS_DC},

        -- CALLS
        calls_emer  = {bus = LIGHT_BUS_DC},

        -- CARGO HEAT & SMOKE
        cargo_hot_air  = {bus = LIGHT_BUS_DC},
        cargo_aft_isol = {bus = LIGHT_BUS_DC},
        cargo_smoke_fwd= {bus = LIGHT_BUS_DC},
        cargo_smoke_aft= {bus = LIGHT_BUS_DC},

        -- VENTILATION
        vent_blower  = {bus = LIGHT_BUS_DC},
        vent_extract = {bus = LIGHT_BUS_AC},
        vent_cab_fans= {bus = LIGHT_BUS_AC},

        -- ENG
        eng_man_start_1 = {bus = LIGHT_BUS_DC},
        eng_man_start_2 = {bus = LIGHT_BUS_DC},
        eng_dual_cooling = {bus = LIGHT_BUS_DC},

        -- Upper level
        misc_cockpit_video = {bus = LIGHT_BUS_DC},
        misc_fuel_control  = {bus = LIGHT_BUS_DC},
        misc_fuel_power    = {bus = LIGHT_BUS_DC},
        misc_toilet        = {bus = LIGHT_BUS_DC}, -- TODO CHECK BUS

        -- Maintainence
        mntn_apu_test      = {bus = LIGHT_BUS_DC},
        mntn_fadec_1_pwr   = {bus = LIGHT_BUS_DC},
        mntn_fadec_2_pwr   = {bus = LIGHT_BUS_DC},
        mntn_hyd_blue_on   = {bus = LIGHT_BUS_AC},
        mntn_hyd_v_G       = {bus = LIGHT_BUS_DC},
        mntn_hyd_v_B       = {bus = LIGHT_BUS_DC},
        mntn_hyd_v_Y       = {bus = LIGHT_BUS_DC},
        mntn_oxy_tmr_reset = {bus = LIGHT_BUS_DC},
        mntn_svce_int      = {bus = LIGHT_BUS_DC},
        mntn_avio_light    = {bus = LIGHT_BUS_AC},

    },

    -- Pedestal
    ped = {
        -- a321neo/cockpit/pedestal/...
        ckpt_door_light = {bus = LIGHT_BUS_DC},
        eng_1_fire_fault= {bus = LIGHT_BUS_DC},
        eng_2_fire_fault= {bus = LIGHT_BUS_DC},
    },

    -- MIP
    mip = {
        -- a321neo/cockpit/mip/...
        gpws_capt = {bus = LIGHT_BUS_AC},
        gpws_fo   = {bus = LIGHT_BUS_AC},
        terr_nd_capt = {bus = LIGHT_BUS_AC},
        terr_nd_fo   = {bus = LIGHT_BUS_AC},
        capt_buss    = {bus = LIGHT_BUS_AC},
        fo_buss      = {bus = LIGHT_BUS_AC},

        brk_fan    = {bus = LIGHT_BUS_AC},
        ldg_gear_L = {bus = LIGHT_BUS_DC},
        ldg_gear_C = {bus = LIGHT_BUS_DC},
        ldg_gear_R = {bus = LIGHT_BUS_DC},

        autobrake_LO  = {bus = LIGHT_BUS_DC},
        autobrake_MED = {bus = LIGHT_BUS_DC},
        autobrake_MAX = {bus = LIGHT_BUS_DC},

        ldg_gear_red_light = {bus = LIGHT_BUS_DC}
    },

    -- Glareshield (no FCU)
    glare = {
        -- a321neo/cockpit/glareshield/...
        atc_msg  = {bus = LIGHT_BUS_AC},
        autoland = {bus = LIGHT_BUS_AC},
        master_warning_capt = {bus = LIGHT_BUS_AC},
        master_caution_capt = {bus = LIGHT_BUS_AC},
        master_warning_fo   = {bus = LIGHT_BUS_AC},
        master_caution_fo   = {bus = LIGHT_BUS_AC},
        priority_capt  = {bus = LIGHT_BUS_AC},
        priority_fo    = {bus = LIGHT_BUS_AC}
    },

    -- FCU
    FCU = {
        capt_fd = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        capt_ls = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        fo_fd   = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        fo_ls   = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS

        capt_range_zoom = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        capt_range_10   = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        capt_range_20   = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        capt_range_40   = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        capt_range_80   = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        capt_range_160  = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        capt_range_320  = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS

        capt_cstr = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        capt_wpt  = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        capt_vord = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        capt_ndb  = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        capt_arpt = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS

        fo_range_zoom = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        fo_range_10   = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        fo_range_20   = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        fo_range_40   = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        fo_range_80   = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        fo_range_160  = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        fo_range_320  = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS


        fo_cstr = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        fo_wpt  = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        fo_vord = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        fo_ndb  = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        fo_arpt = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS

        loc = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS

        ap_1 = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        ap_2 = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        athr = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS

        exped = {bus = LIGHT_BUS_AC}, -- TODO CHECK BUS
        appr = {bus = LIGHT_BUS_AC}  -- TODO CHECK BUS

    }

}

----------------------------------------------------------------------------------------------------
-- Initialization function
----------------------------------------------------------------------------------------------------
local function init_group(group_set, prefix)
    for dr_name,x in pairs(group_set) do
        x.status_top    = false
        x.status_bottom = false
        local base_string = DR_PATH_PREFIX .. "/" .. prefix .. "/" .. dr_name 
        x.dr_top    = createGlobalPropertyf(base_string .. DR_PATH_SUFFIX_TOP , 0, false, true, false)
        x.dr_bottom = createGlobalPropertyf(base_string .. DR_PATH_SUFFIX_BTM , 0, false, true, false)
    end

end

local function initialization()

    init_group(PB.ovhd, DR_PATH_PREFIX_OVH)
    init_group(PB.ped,  DR_PATH_PREFIX_PEDESTAL)
    init_group(PB.mip,  DR_PATH_PREFIX_MIP)
    init_group(PB.glare,  DR_PATH_PREFIX_GLARESHIELD)
    init_group(PB.FCU,  DR_PATH_PREFIX_FCU)

end

initialization()

----------------------------------------------------------------------------------------------------
-- Functions
----------------------------------------------------------------------------------------------------


local function has_elec_pwr(pb)
    if pb.bus == ELEC_ALWAYS_ON then
        return true
    elseif pb.bus == LIGHT_BUS_DC then
        return get(DC_bat_bus_pwrd) + get(DC_bus_1_pwrd) + get(DC_bus_2_pwrd) + get(DC_ess_bus_pwrd) > 0
    elseif pb.bus == LIGHT_BUS_AC then
        return get(AC_ess_bus_pwrd) + get(AC_bus_1_pwrd) + get(AC_bus_2_pwrd) > 0
    end
end

function pb_set(pb, cond_bottom, cond_top)
    if has_elec_pwr(pb) then
        pb.status_top = cond_top
        pb.status_bottom = cond_bottom
    else
        pb.status_top = false
        pb.status_bottom = false
    end


    local brightness = get(Cockpit_ann_ovhd_switch) < -0.5 and BRIGHTNESS_HALF or BRIGHTNESS_FULL
    local target_top = (pb.status_top and 1 or 0) * brightness
    local target_bottom = (pb.status_bottom and 1 or 0) * brightness
    if get(Cockpit_annnunciators_test) == 1 and has_elec_pwr(pb) then
        target_top = 1
        target_bottom = 1
    end

    set(pb.dr_top, target_top)
    set(pb.dr_bottom, target_bottom)

end


