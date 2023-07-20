FBW.yaw.controllers = {
    yaw_damper_PD = {
        output = 0,
        control = function ()
            --Yaw damper control
            FBW.yaw.controllers.yaw_damper_PD.output = FBW_PID_BP(
                FBW_PID_arrays.FBW_YAW_DAMPER_PID,
                FBW.yaw.inputs.damper_input(adirs_get_avg_roll(), adirs_get_avg_tas()),
                get(Flightmodel_yaw_rate)
            )
            --law reconfiguration
            if get(FBW_yaw_law) == FBW_ALT_NO_PROT_LAW then
                --limit travel ability to 5 degrees of rudder
                FBW.yaw.controllers.yaw_damper_PD.output = Math_clamp(FBW.yaw.controllers.yaw_damper_PD.output, -5/30, 5/30)
            end
            if get(FBW_yaw_law) == FBW_MECHANICAL_BACKUP_LAW or get(FBW_yaw_law) == FBW_ABNORMAL_LAW or not FBW.fctl.surfaces.rud.rud.controlled then
                FBW.yaw.controllers.yaw_damper_PD.output = 0
            end
        end,
        bp = function ()
            --FBW_PID_arrays.FBW_YAW_DAMPER_PID.Actual_output = get(Rudder_total) / 30
        end,
    },

    SI_demand_PID = {
        output = 0,
        bumpless_transfer = function ()
            if get(FBW_lateral_flight_mode_ratio) == 0 or get(FBW_yaw_law) ~= FBW_NORMAL_LAW then
                FBW_PID_arrays.FBW_NRM_YAW_PID.Integral = 0
            end
        end,
        control = function ()
            FBW_PID_arrays.FBW_NRM_YAW_PID.min_integral = -get(Rudder_travel_lim) / 30
            FBW_PID_arrays.FBW_NRM_YAW_PID.max_integral =  get(Rudder_travel_lim) / 30

            FBW.yaw.controllers.SI_demand_PID.output = FBW_PID_BP(
                FBW_PID_arrays.FBW_NRM_YAW_PID,
                FBW.yaw.inputs.x_to_beta(get(Total_input_yaw)),
                get(Beta)
            )
        end,
        bp = function ()
            FBW_PID_arrays.FBW_NRM_YAW_PID.Desired_output = FBW_PID_arrays.FBW_NRM_YAW_PID.Desired_output + FBW.yaw.controllers.yaw_damper_PD.output
            FBW_PID_arrays.FBW_NRM_YAW_PID.Actual_output = get(Rudder_total) / 30
        end
    },

    output_blending = function ()
        set(
            FBW_yaw_output,
            Math_clamp(
                (get(Total_input_yaw) + FBW.yaw.controllers.yaw_damper_PD.output)                     * get(FBW_lateral_ground_mode_ratio) +
                (FBW.yaw.controllers.SI_demand_PID.output + FBW.yaw.controllers.yaw_damper_PD.output) * get(FBW_lateral_flight_mode_ratio),
                -1,
                1
            )
        )
    end
}