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
-- File: MCDU_popup.lua 
-- Short description: MCDU popup code
-------------------------------------------------------------------------------
size = { 826, 1289 }


local texture_mcdu_background = sasl.gl.loadImage("textures/MCDU/popup.png", 0, 0, 826, 1289)
local WHITELIST = "1234567890qwertyuiopasdfghjklzxcvbnm./ "

local CLICK_RECT_SIDE_L = {start_vec = {x = 10, y = 1082, w = 90, h = 50}, offset_vec = {x = 0, y = -75, w = 0, h = 0}, rpt = {x = 1, y = 6}}
CLICK_RECT_SIDE_L.cmd = {}
CLICK_RECT_SIDE_L.cmd[1] = {}
CLICK_RECT_SIDE_L.cmd[1][1] = sasl.findCommand("a321neo/cockpit/mcdu/side/L1")
CLICK_RECT_SIDE_L.cmd[2] = {}
CLICK_RECT_SIDE_L.cmd[2][1] = sasl.findCommand("a321neo/cockpit/mcdu/side/L2")
CLICK_RECT_SIDE_L.cmd[3] = {}
CLICK_RECT_SIDE_L.cmd[3][1] = sasl.findCommand("a321neo/cockpit/mcdu/side/L3")
CLICK_RECT_SIDE_L.cmd[4] = {}
CLICK_RECT_SIDE_L.cmd[4][1] = sasl.findCommand("a321neo/cockpit/mcdu/side/L4")
CLICK_RECT_SIDE_L.cmd[5] = {}
CLICK_RECT_SIDE_L.cmd[5][1] = sasl.findCommand("a321neo/cockpit/mcdu/side/L5")
CLICK_RECT_SIDE_L.cmd[6] = {}
CLICK_RECT_SIDE_L.cmd[6][1] = sasl.findCommand("a321neo/cockpit/mcdu/side/L6")

local CLICK_RECT_SIDE_R = {start_vec = {x = 780, y = 1082, w = 90, h = 50}, offset_vec = {x = 0, y = -75, w = 0, h = 0}, rpt = {x = 1, y = 6}}
CLICK_RECT_SIDE_R.cmd = {}
CLICK_RECT_SIDE_R.cmd[1] = {}
CLICK_RECT_SIDE_R.cmd[1][1] = sasl.findCommand("a321neo/cockpit/mcdu/side/R1")
CLICK_RECT_SIDE_R.cmd[2] = {}
CLICK_RECT_SIDE_R.cmd[2][1] = sasl.findCommand("a321neo/cockpit/mcdu/side/R2")
CLICK_RECT_SIDE_R.cmd[3] = {}
CLICK_RECT_SIDE_R.cmd[3][1] = sasl.findCommand("a321neo/cockpit/mcdu/side/R3")
CLICK_RECT_SIDE_R.cmd[4] = {}
CLICK_RECT_SIDE_R.cmd[4][1] = sasl.findCommand("a321neo/cockpit/mcdu/side/R4")
CLICK_RECT_SIDE_R.cmd[5] = {}
CLICK_RECT_SIDE_R.cmd[5][1] = sasl.findCommand("a321neo/cockpit/mcdu/side/R5")
CLICK_RECT_SIDE_R.cmd[6] = {}
CLICK_RECT_SIDE_R.cmd[6][1] = sasl.findCommand("a321neo/cockpit/mcdu/side/R6")

local CLICK_RECT_PAGES = {start_vec = {x = 80, y = 580, w = 100, h = 60}, offset_vec = {x = 100, y = -70, w = 0, h = 0}, rpt = {x = 6, y = 5}}
CLICK_RECT_PAGES.cmd = {}
CLICK_RECT_PAGES.cmd[1] = {}
CLICK_RECT_PAGES.cmd[1][1] = sasl.findCommand("a321neo/cockpit/mcdu/page/dir")
CLICK_RECT_PAGES.cmd[1][2] = sasl.findCommand("a321neo/cockpit/mcdu/page/prog")
CLICK_RECT_PAGES.cmd[1][3] = sasl.findCommand("a321neo/cockpit/mcdu/page/perf")
CLICK_RECT_PAGES.cmd[1][4] = sasl.findCommand("a321neo/cockpit/mcdu/page/init")
CLICK_RECT_PAGES.cmd[1][5] = sasl.findCommand("a321neo/cockpit/mcdu/page/data")

CLICK_RECT_PAGES.cmd[2] = {}
CLICK_RECT_PAGES.cmd[2][1] = sasl.findCommand("a321neo/cockpit/mcdu/page/f-pln")
CLICK_RECT_PAGES.cmd[2][2] = sasl.findCommand("a321neo/cockpit/mcdu/page/rad_nav")
CLICK_RECT_PAGES.cmd[2][3] = sasl.findCommand("a321neo/cockpit/mcdu/page/fuel_pred")
CLICK_RECT_PAGES.cmd[2][4] = sasl.findCommand("a321neo/cockpit/mcdu/page/sec_f-pln")
CLICK_RECT_PAGES.cmd[2][5] = sasl.findCommand("a321neo/cockpit/mcdu/page/atc_comm")
CLICK_RECT_PAGES.cmd[2][6] = sasl.findCommand("a321neo/cockpit/mcdu/page/mcdu_menu")

CLICK_RECT_PAGES.cmd[3] = {}
CLICK_RECT_PAGES.cmd[3][1] = sasl.findCommand("a321neo/cockpit/mcdu/page/air_port")

CLICK_RECT_PAGES.cmd[4] = {}
CLICK_RECT_PAGES.cmd[4][1] = sasl.findCommand("a321neo/cockpit/mcdu/side/slew_left")
CLICK_RECT_PAGES.cmd[4][2] = sasl.findCommand("a321neo/cockpit/mcdu/side/slew_up")

CLICK_RECT_PAGES.cmd[5] = {}
CLICK_RECT_PAGES.cmd[5][1] = sasl.findCommand("a321neo/cockpit/mcdu/side/slew_right")
CLICK_RECT_PAGES.cmd[5][2] = sasl.findCommand("a321neo/cockpit/mcdu/side/slew_down")

local CLICK_RECT_ALPHABET = {start_vec = {x = 350, y = 426, w = 80, h = 70}, offset_vec = {x = 80, y = -79, w = 0, h = 0}, rpt = {x = 5, y = 6}}
CLICK_RECT_ALPHABET.cmd = {}

CLICK_RECT_ALPHABET.cmd[1] = {}
CLICK_RECT_ALPHABET.cmd[1][1] = sasl.findCommand("a321neo/cockpit/mcdu/key/A")
CLICK_RECT_ALPHABET.cmd[1][2] = sasl.findCommand("a321neo/cockpit/mcdu/key/B")
CLICK_RECT_ALPHABET.cmd[1][3] = sasl.findCommand("a321neo/cockpit/mcdu/key/C")
CLICK_RECT_ALPHABET.cmd[1][4] = sasl.findCommand("a321neo/cockpit/mcdu/key/D")
CLICK_RECT_ALPHABET.cmd[1][5] = sasl.findCommand("a321neo/cockpit/mcdu/key/E")

CLICK_RECT_ALPHABET.cmd[2] = {}
CLICK_RECT_ALPHABET.cmd[2][1] = sasl.findCommand("a321neo/cockpit/mcdu/key/F")
CLICK_RECT_ALPHABET.cmd[2][2] = sasl.findCommand("a321neo/cockpit/mcdu/key/G")
CLICK_RECT_ALPHABET.cmd[2][3] = sasl.findCommand("a321neo/cockpit/mcdu/key/H")
CLICK_RECT_ALPHABET.cmd[2][4] = sasl.findCommand("a321neo/cockpit/mcdu/key/I")
CLICK_RECT_ALPHABET.cmd[2][5] = sasl.findCommand("a321neo/cockpit/mcdu/key/J")

CLICK_RECT_ALPHABET.cmd[3] = {}
CLICK_RECT_ALPHABET.cmd[3][1] = sasl.findCommand("a321neo/cockpit/mcdu/key/K")
CLICK_RECT_ALPHABET.cmd[3][2] = sasl.findCommand("a321neo/cockpit/mcdu/key/L")
CLICK_RECT_ALPHABET.cmd[3][3] = sasl.findCommand("a321neo/cockpit/mcdu/key/M")
CLICK_RECT_ALPHABET.cmd[3][4] = sasl.findCommand("a321neo/cockpit/mcdu/key/N")
CLICK_RECT_ALPHABET.cmd[3][5] = sasl.findCommand("a321neo/cockpit/mcdu/key/O")

CLICK_RECT_ALPHABET.cmd[4] = {}
CLICK_RECT_ALPHABET.cmd[4][1] = sasl.findCommand("a321neo/cockpit/mcdu/key/P")
CLICK_RECT_ALPHABET.cmd[4][2] = sasl.findCommand("a321neo/cockpit/mcdu/key/Q")
CLICK_RECT_ALPHABET.cmd[4][3] = sasl.findCommand("a321neo/cockpit/mcdu/key/R")
CLICK_RECT_ALPHABET.cmd[4][4] = sasl.findCommand("a321neo/cockpit/mcdu/key/S")
CLICK_RECT_ALPHABET.cmd[4][5] = sasl.findCommand("a321neo/cockpit/mcdu/key/T")

CLICK_RECT_ALPHABET.cmd[5] = {}
CLICK_RECT_ALPHABET.cmd[5][1] = sasl.findCommand("a321neo/cockpit/mcdu/key/U")
CLICK_RECT_ALPHABET.cmd[5][2] = sasl.findCommand("a321neo/cockpit/mcdu/key/V")
CLICK_RECT_ALPHABET.cmd[5][3] = sasl.findCommand("a321neo/cockpit/mcdu/key/W")
CLICK_RECT_ALPHABET.cmd[5][4] = sasl.findCommand("a321neo/cockpit/mcdu/key/X")
CLICK_RECT_ALPHABET.cmd[5][5] = sasl.findCommand("a321neo/cockpit/mcdu/key/Y")

CLICK_RECT_ALPHABET.cmd[6] = {}
CLICK_RECT_ALPHABET.cmd[6][1] = sasl.findCommand("a321neo/cockpit/mcdu/key/Z")
CLICK_RECT_ALPHABET.cmd[6][2] = sasl.findCommand("a321neo/cockpit/mcdu/key/slash")
CLICK_RECT_ALPHABET.cmd[6][3] = sasl.findCommand("a321neo/cockpit/mcdu/key/space")
CLICK_RECT_ALPHABET.cmd[6][4] = sasl.findCommand("a321neo/cockpit/mcdu/key/overfly")
CLICK_RECT_ALPHABET.cmd[6][5] = sasl.findCommand("a321neo/cockpit/mcdu/misc/clr")

local CLICK_RECT_NUMERIC = {start_vec = {x = 100, y = 240, w = 70, h = 65}, offset_vec = {x = 79, y = -69, w = 0, h = 0}, rpt = {x = 3, y = 4}}
CLICK_RECT_NUMERIC.cmd = {}

CLICK_RECT_NUMERIC.cmd[1] = {}
CLICK_RECT_NUMERIC.cmd[1][1] = sasl.findCommand("a321neo/cockpit/mcdu/key/1")
CLICK_RECT_NUMERIC.cmd[1][2] = sasl.findCommand("a321neo/cockpit/mcdu/key/2")
CLICK_RECT_NUMERIC.cmd[1][3] = sasl.findCommand("a321neo/cockpit/mcdu/key/3")

CLICK_RECT_NUMERIC.cmd[2] = {}
CLICK_RECT_NUMERIC.cmd[2][1] = sasl.findCommand("a321neo/cockpit/mcdu/key/4")
CLICK_RECT_NUMERIC.cmd[2][2] = sasl.findCommand("a321neo/cockpit/mcdu/key/5")
CLICK_RECT_NUMERIC.cmd[2][3] = sasl.findCommand("a321neo/cockpit/mcdu/key/6")

CLICK_RECT_NUMERIC.cmd[3] = {}
CLICK_RECT_NUMERIC.cmd[3][1] = sasl.findCommand("a321neo/cockpit/mcdu/key/7")
CLICK_RECT_NUMERIC.cmd[3][2] = sasl.findCommand("a321neo/cockpit/mcdu/key/8")
CLICK_RECT_NUMERIC.cmd[3][3] = sasl.findCommand("a321neo/cockpit/mcdu/key/9")

CLICK_RECT_NUMERIC.cmd[4] = {}
CLICK_RECT_NUMERIC.cmd[4][1] = sasl.findCommand("a321neo/cockpit/mcdu/key/.")
CLICK_RECT_NUMERIC.cmd[4][2] = sasl.findCommand("a321neo/cockpit/mcdu/key/0")
CLICK_RECT_NUMERIC.cmd[4][3] = sasl.findCommand("a321neo/cockpit/mcdu/misc/positive_negative")

local CLICK_RECT_BRTDIM = {start_vec = {x = 740, y = 600, w = 60, h = 65}, offset_vec = {x = 79, y = -69, w = 0, h = 0}, rpt = {x = 1, y = 2}}
CLICK_RECT_BRTDIM.cmd = {}

local CLICK_RECTS = {CLICK_RECT_SIDE_L, CLICK_RECT_SIDE_R, CLICK_RECT_PAGES, CLICK_RECT_ALPHABET, CLICK_RECT_NUMERIC, CLICK_RECT_BRTDIM}
local click_rect_all = {}

for i,click_rect in ipairs(CLICK_RECTS) do
    for j = 1, click_rect.rpt.x do
        for k = 1, click_rect.rpt.y do
            local rpt_x = j - 1
            local rpt_y = k - 1
            local cmd = nil
            if click_rect.cmd[k] ~= nil then
                if click_rect.cmd[k][j] ~= nil then
                    cmd = click_rect.cmd[k][j]
                end
            end
            table.insert(click_rect_all, {
                x = click_rect.start_vec.x + (click_rect.offset_vec.x * rpt_x),
                y = click_rect.start_vec.y + (click_rect.offset_vec.y * rpt_y),
                w = click_rect.start_vec.w + (click_rect.offset_vec.w * rpt_x),
                h = click_rect.start_vec.h + (click_rect.offset_vec.h * rpt_y),
                cmd = cmd
            })
        end
    end
end

function draw()
    if MCDU_window:isVisible() then
        local window_x, window_y, window_width = MCDU_window:getPosition()
        MCDU_window:setPosition ( window_x , window_y , window_width, window_width * size[2]/size[1])
    end

    sasl.gl.drawTexture(texture_mcdu_background, 0, 0, 826, 1289)
    sasl.gl.drawTexture(MCDU_popup_texture, 134, 668, 560, 530, {1,1,1})    -- Screen texture
end

function onKeyDown ( component , charCode , key , shDown , ctrlDown , altOptDown )
    --is it a key down or key hold event?
        if charCode == SASL_KEY_RETURN or
           charCode == SASL_KEY_ESCAPE or
           charCode == SASL_KEY_TAB
           then
            --noop
        elseif charCode == SASL_KEY_DELETE then
            sasl.commandOnce(CLICK_RECT_ALPHABET.cmd[6][5]) -- CLR
        elseif string.char(charCode) == "-" then
            sasl.commandOnce(CLICK_RECT_NUMERIC.cmd[4][3])  -- +/-
        elseif string.char(charCode) == "+" then
            sasl.commandOnce(CLICK_RECT_NUMERIC.cmd[4][3])  -- +/-
            sasl.commandOnce(CLICK_RECT_NUMERIC.cmd[4][3])  -- +/-
        elseif string.char(charCode) == "/" then
            sasl.commandOnce(CLICK_RECT_ALPHABET.cmd[6][2])
        elseif charCode == SASL_KEY_UP then
            sasl.commandOnce(CLICK_RECT_PAGES.cmd[4][2])    -- Up
        elseif charCode == SASL_KEY_DOWN then
            sasl.commandOnce(CLICK_RECT_PAGES.cmd[5][2])    -- Down
        elseif charCode == SASL_KEY_LEFT then
            sasl.commandOnce(CLICK_RECT_PAGES.cmd[4][1])    -- Left
        elseif charCode == SASL_KEY_RIGHT then
            sasl.commandOnce(CLICK_RECT_PAGES.cmd[5][1])    -- Right
        else
            local pass = false
            -- is the input code a valid character?
            for i = 1, string.len(WHITELIST) do
                if string.char(charCode):lower() == WHITELIST:sub(i,i) then
                    pass = true
                    break
                end
            end
            if pass then
                key = string.char(charCode):upper()

                -- special case for if key is space
                if key == " " then
                    key = "space"
                end

                -- call that key
                sasl.commandOnce(sasl.findCommand("a321neo/cockpit/mcdu/key/" .. key))
            end
        end
    return true
end

function onMouseDown (component, x, y, button, parentX, parentY)

    for i,click_rect in ipairs(click_rect_all) do
        if x > click_rect.x and x < click_rect.x + click_rect.w then
            if y > click_rect.y and y < click_rect.y + click_rect.h then
                if button == MB_LEFT then
                    if click_rect.cmd then
                        sasl.commandOnce(click_rect.cmd)
                    end
                end
            end
        end
    end
    return true
end
