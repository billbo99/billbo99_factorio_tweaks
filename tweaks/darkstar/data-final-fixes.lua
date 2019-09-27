if not settings.startup["darkstar"].value then
    return
end

if data.raw["roboport"] and data.raw["roboport"]["roboport-mk2"] then data.raw["roboport"]["roboport-mk2"].charging_energy = "4000kW" end
if data.raw["roboport"] and data.raw["roboport"]["roboport-mk3"] then data.raw["roboport"]["roboport-mk3"].charging_energy = "16000kW" end
if data.raw["roboport"] and data.raw["roboport"]["roboport-charger"] then data.raw["roboport"]["roboport-charger"].charging_energy = "64000kW" end
