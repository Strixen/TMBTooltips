for k,e in pairs(parsedEntries) do
    local tempTable = {}
    local tempCharTable = {}
    local checkToken = {}
    local currentItemID = nil
    if e.character_inactive_at == "" then
        currentItemID = tonumber(e.item_id)
        checkToken = tokens[currentItemID]  
        if checkToken ~= nil then currentItemID = checkToken end
        tempTable = noteTable[ currentItemID ] --Try and load the item element
        if tempTable == nil then noteTable[ currentItemID ] = {} end -- Make an array because this is the first time the item is seen

        if e.type == "wishlist" or e.type = "prio" or e.type = "received" then
            tempCharTable.character_class = e.character_class
            tempCharTable.character_name = e.character_name
            tempCharTable.sort_order = tonumber(e.sort_order)
            tempCharTable.member_name = e.member_name
            tempCharTable.character_is_alt = tonumber(e.character_is_alt)
            tempCharTable.is_offspec = tonumber(e.is_offspec)
            if ItemListsDB.showMemberNotes then
                tempCharTable.character_note = e.character_note
            end
            if tempTable ~= nil and e.type == "wishlist" then tempTable = tempTable.wishlist end -- Look at the wishlist element if it exist then load it
            if tempTable ~= nil and e.type == "prio" then tempTable = tempTable.priolist end -- Look at the priolist element if it exist then load it
            if tempTable ~= nil and e.type == "received"  then tempTable = tempTable.received end -- Look at the recieved element if it exist then load it
            if tempTable == nil then --If the loaded item is nil then its the first wish for this item so just save it directly
                tempTable = {}
                table.insert(tempTable,tempCharTable)
            else -- Else insert it into the old one before saving.
                table.insert(tempTable,tempCharTable)
            end

            if e.type = "prio" then 
                noteTable[currentItemID].priolist = tempTable
            elseif e.type = "wishlist" then
                noteTable[currentItemID].wishlist = tempTable
            elseif e.type = "received" then
                noteTable[currentItemID].received = tempTable
            end
        elseif e.type == "item_note" then 
            noteTable[currentItemID].prioNote = e.item_prio_note
            noteTable[currentItemID].guildNote = e.item_note
            noteTable[currentItemID].rank = e.item_tier_label
        end

    end
     -- 
end
noteTable["ID"] = GetTime()
ItemListsDB["itemNotes"] = noteTable -- Add it to peristent storage

return "Success, data saved"
end