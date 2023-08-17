ExtendedStrawTypes = {}
local modDir = g_currentModDirectory

--- Load data on map load.
function ExtendedStrawTypes:loadMap()
    local modDescXML = loadXMLFile("modDesc", modDir .. "modDesc.xml")
    local filename = getXMLString(modDescXML, "modDesc.fruitTypes#filename")
    local xmlFile = loadXMLFile("modFruitTypes", modDir .. filename)

    ExtendedStrawTypes:loadFruitTypeWindrow(xmlFile)
    delete(xmlFile)
    delete(modDescXML)
end

--- Loads fruitType windrow data from mod.
-- @param table xmlFile
function ExtendedStrawTypes:loadFruitTypeWindrow(xmlFile)
    if type(xmlFile) ~= "table" then
        xmlFile = XMLFile.wrap(xmlFile, FruitTypeManager.xmlSchema)
    end

    xmlFile:iterate("map.fruitTypes.fruitType", function (_, key)
        local fruitTypeName = xmlFile:getValue(key .. "#name")
        local windrowName = xmlFile:getValue(key .. ".windrow#name")
        local litersPerSqm = xmlFile:getValue(key .. ".windrow#litersPerSqm")

        local fruitType = g_fruitTypeManager:getFruitTypeByName(fruitTypeName)
        local windrowType = g_fillTypeManager:getFillTypeByName(windrowName)

        g_fruitTypeManager.fruitTypes[fruitType.index].hasWindrow = true
        g_fruitTypeManager.fruitTypes[fruitType.index].windrowName = windrowType.name
        g_fruitTypeManager.fruitTypes[fruitType.index].windrowLiterPerSqm = litersPerSqm
        g_fruitTypeManager.fruitTypeIndexToWindrowFillTypeIndex[fruitType.index] = windrowType.index
        g_fruitTypeManager.fillTypeIndexToFruitTypeIndex[windrowType.index] = fruitType.index
    end)
end

addModEventListener(ExtendedStrawTypes)