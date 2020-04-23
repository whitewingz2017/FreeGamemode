cAPI.drawable_names = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"}
cAPI.head_overlays = {"1","2","3","4","5","6","7","8","9","10","11","12","13"}
cAPI.face_features = {"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"}

function cAPI.getDrawableNames()
    return cAPI.drawable_names
end

function cAPI.getHeadOverlays()
    return cAPI.head_overlays
end

function cAPI.getFaceFeatures()
    return cAPI.face_features
end

function cAPI.SetPedHeadBlend(data)
	local player = PlayerPedId()
    SetPedHeadBlendData(player,
        tonumber(data['shapeFirst']),
        tonumber(data['shapeSecond']),
        tonumber(data['shapeThird']),
        tonumber(data['skinFirst']),
        tonumber(data['skinSecond']),
        tonumber(data['skinThird']),
        tonumber(data['shapeMix']),
        tonumber(data['skinMix']),
        tonumber(data['thirdMix']),
        false)
end

function cAPI.SetHeadOverlayData(data)
	local player = PlayerPedId()
    if json.encode(data) ~= "[]" then
        for i = 1, #cAPI.head_overlays do
            SetPedHeadOverlay(player,  i-1, tonumber(data[i].overlayValue),  tonumber(data[i].overlayOpacity))
            -- SetPedHeadOverlayColor(player, i-1, data[i].colourType, data[i].firstColour, data[i].secondColour)
        end

        SetPedHeadOverlayColor(player, 0, 0, tonumber(data[1].firstColour), tonumber(data[1].secondColour))
        SetPedHeadOverlayColor(player, 1, 1, tonumber(data[2].firstColour), tonumber(data[2].secondColour))
        SetPedHeadOverlayColor(player, 2, 1, tonumber(data[3].firstColour), tonumber(data[3].secondColour))
        SetPedHeadOverlayColor(player, 3, 0, tonumber(data[4].firstColour), tonumber(data[4].secondColour))
        SetPedHeadOverlayColor(player, 4, 2, tonumber(data[5].firstColour), tonumber(data[5].secondColour))
        SetPedHeadOverlayColor(player, 5, 2, tonumber(data[6].firstColour), tonumber(data[6].secondColour))
        SetPedHeadOverlayColor(player, 6, 0, tonumber(data[7].firstColour), tonumber(data[7].secondColour))
        SetPedHeadOverlayColor(player, 7, 0, tonumber(data[8].firstColour), tonumber(data[8].secondColour))
        SetPedHeadOverlayColor(player, 8, 2, tonumber(data[9].firstColour), tonumber(data[9].secondColour))
        SetPedHeadOverlayColor(player, 9, 0, tonumber(data[10].firstColour), tonumber(data[10].secondColour))
        SetPedHeadOverlayColor(player, 10, 1, tonumber(data[11].firstColour), tonumber(data[11].secondColour))
        SetPedHeadOverlayColor(player, 11, 0, tonumber(data[12].firstColour), tonumber(data[12].secondColour))
    end
end

function cAPI.SetHeadStructure(data)
	local player = PlayerPedId()
    for i = 1, #cAPI.face_features do
        SetPedFaceFeature(player, i-1, data[i])
    end
end

function cAPI.SetClothing(drawables, drawTextures)
	local player = PlayerPedId()
    for i = 1, #cAPI.drawable_names do
        if drawables[0] == nil then
            if cAPI.drawable_names[i] == "undershirts" and drawables[tostring(i-1)][2] == -1 then
                SetPedComponentVariation(player, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(player, i-1, drawables[tostring(i-1)][2], drawTextures[i][2], 2)
            end
        else
            if cAPI.drawable_names[i] == "undershirts" and drawables[i-1][2] == -1 then
                SetPedComponentVariation(player, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(player, i-1, drawables[i-1][2], drawTextures[i][2], 2)
            end
        end
    end
end

function cAPI.SetHairColor(data)
	local player = PlayerPedId()
	SetPedHairColor(player, tonumber(data[0]), tonumber(data[1]))
end