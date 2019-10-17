if settings.startup["billbo99-darkstar"].value and mods["darkstar"] then
    log("option enabled and mod installed")
else
    return
end

-- Power requirements were totally off the board by 1000 fold for a mk2 upgrade 1MW (mk1) per port to 4GW (mk2) per port
-- Now its back to kW and each tier is multiplied by 4x the previous tier
if data.raw["roboport"] and data.raw["roboport"]["roboport-mk2"] then data.raw["roboport"]["roboport-mk2"].charging_energy = "4000kW" end
if data.raw["roboport"] and data.raw["roboport"]["roboport-mk3"] then data.raw["roboport"]["roboport-mk3"].charging_energy = "16000kW" end
if data.raw["roboport"] and data.raw["roboport"]["roboport-charger"] then data.raw["roboport"]["roboport-charger"].charging_energy = "64000kW" end


-- My OCD screams when it sees a little strip of ore left behind between miners
local resource_searching_radius = 5
if data.raw["mining-drill"] and data.raw["mining-drill"]["laser-miner"] then 
    data.raw["mining-drill"]["laser-miner"].resource_searching_radius = resource_searching_radius
end
if data.raw["mining-drill"] and data.raw["mining-drill"]["laser-miner2"] then
    data.raw["mining-drill"]["laser-miner2"].resource_searching_radius = resource_searching_radius
end
if data.raw["mining-drill"] and data.raw["mining-drill"]["laser-miner3"] then
    data.raw["mining-drill"]["laser-miner3"].resource_searching_radius = resource_searching_radius
end
if data.raw["mining-drill"] and data.raw["mining-drill"]["laser-miner4"] then
    data.raw["mining-drill"]["laser-miner4"].resource_searching_radius = resource_searching_radius
end
