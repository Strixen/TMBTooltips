ThatsMyBis = LibStub("AceAddon-3.0"):NewAddon("ThatsMyBis", "AceConsole-3.0", "AceEvent-3.0")

local frame = CreateFrame( "Frame" )
local AceGUI = LibStub("AceGUI-3.0")
local TMBIcon = LibStub("LibDBIcon-1.0")

-- Fantastic

local classColorsTable = {
	Warrior = "\124cFFC79C6E",
	Paladin = "\124cFFF58CBA",
	Shaman = "\124cFF0070DE",
	Hunter = "\124cFFABD473",
	Druid = "\124cFFFF7D0A",
	Rogue = "\124cFFFFF569",
	Priest = "\124cFFFFFFFF",
	Warlock = "\124cFF9482C9",
	Mage = "\124cFF69CCF0"
	}
local rankColorsTable = {
	S = "\124cFF02F3FF",
	A = "\124cFF20FF00",
	B = "\124cFFF7FF00",
	C = "\124cFFFF8800", 
	D = "\124cFFFF0078",
	F = "\124cFFFF0000",
	N = "\124cFFFF0000"
	}

local origChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow

local statusEnableText = "TMB Tooltips is currently: Disabled"

local TMBLDB = LibStub("LibDataBroker-1.1"):NewDataObject("TMBTooltips", {
type = "data source",
text = "TMB Tooltips",
icon = "Interface\\Icons\\inv_misc_note_01",
OnClick = function(self,button,down)
	if button == "LeftButton" then
		if ItemListsDB.enabled then 
			statusEnableText = "TMB Tooltips is currently: Disabled"
			ItemListsDB.enabled = false
		else
			statusEnableText = "TMB Tooltips is currently: Enabled"
			ItemListsDB.enabled = true
		end
	ThatsMyBis:Print(statusEnableText)
	elseif button == "RightButton" then
		popupConfig()
	end
end,
OnTooltipShow = function(tooltip) -- Icon tooltip
	tooltip:AddLine("That's My BIS Tooltips")
	tooltip:AddLine("Leftclick Enable/Disable display")
	tooltip:AddLine("Rightclick open config")
end,
})



function popupConfig()

	if frameShown then
		return
	end
	
	frameShown = true



	popup = AceGUI:Create("Frame")
	popup:SetTitle("Thats My BIS Tooltips")
	popup:SetStatusText(statusEnableText)

	popup.sizer_se:Hide()
	popup.sizer_s:Hide()
	popup.sizer_e:Hide()
	popup:SetWidth(600)
	popup:SetHeight(300)
	local checkboxGroup = AceGUI:Create("SimpleGroup")
	checkboxGroup:SetRelativeWidth(0.4)
	local textboxGroup = AceGUI:Create("SimpleGroup")
	textboxGroup:SetRelativeWidth(0.6)

	local checkLabel = AceGUI:Create("Label")
    checkLabel:SetText("Display settings")
	checkboxGroup:AddChild(checkLabel)

	local check1 = AceGUI:Create("CheckBox")
	check1:SetLabel("Priority Note")
	check1:SetValue(ItemListsDB.displayPrioNote)
	checkboxGroup:AddChild(check1)

	local check6 = AceGUI:Create("CheckBox")
	check6:SetLabel("Guild Note")
	check6:SetValue(ItemListsDB.displayGuildNote)
	checkboxGroup:AddChild(check6)

	local check2 = AceGUI:Create("CheckBox")
	check2:SetLabel("Ranks")
	check2:SetValue(ItemListsDB.displayRank)
	checkboxGroup:AddChild(check2)

	local check3 = AceGUI:Create("CheckBox")
	check3:SetLabel("Wishlists")
	check3:SetValue(ItemListsDB.displayWishes)
	checkboxGroup:AddChild(check3)

	local check4 = AceGUI:Create("CheckBox")
	check4:SetLabel("Priolists")
	check4:SetValue(ItemListsDB.displayPrios)
	checkboxGroup:AddChild(check4)

	local check5 = AceGUI:Create("CheckBox")
	check5:SetLabel("Display Alt *")
	check5:SetValue(ItemListsDB.displayAlts)
	checkboxGroup:AddChild(check5)

	local slider1 = AceGUI:Create("Slider")
	slider1:SetValue(ItemListsDB.maxNames)
	slider1:SetSliderValues(1,10,1)
	slider1:SetLabel("How many names to display")
	slider1:SetRelativeWidth(1)
	checkboxGroup:AddChild(slider1)

	local inputfield = AceGUI:Create("MultiLineEditBox")
	inputfield:SetLabel("Paste CSV here")
	inputfield:SetNumLines(12)
	inputfield:SetWidth(320)

	local textBuffer, i, lastPaste = {}, 0, 0
	local pasted = ""
	inputfield.editBox:SetScript("OnShow", function(obj)
		obj:SetText("")
		pasted = ""
	end)
	local function clearBuffer(obj1)
		obj1:SetScript('OnUpdate', nil)
		pasted = strtrim(table.concat(textBuffer))
		inputfield.editBox:ClearFocus()
	end
	inputfield.editBox:SetScript('OnChar', function(obj2, c)
		if lastPaste ~= GetTime() then
			textBuffer, i, lastPaste = {}, 0, GetTime()
			obj2:SetScript('OnUpdate', clearBuffer)
		end
		i = i + 1
		textBuffer[i] = c
	end)
	inputfield.editBox:SetMaxBytes(2500)
	inputfield.editBox:SetScript("OnMouseUp", nil);

	inputfield:DisableButton(true)
	textboxGroup:AddChild(inputfield)

	local parseData = AceGUI:Create("Button")
	parseData:SetText("Parse")
	textboxGroup:AddChild(parseData)

	popup:SetLayout("Flow")

	popup:AddChild(checkboxGroup)
	popup:AddChild(textboxGroup)


	check1:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.displayPrioNote = check1:GetValue()
	end)
	check2:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.displayRank = check2:GetValue()
	end)
	check3:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.displayWishes = check3:GetValue()
	end)
	check4:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.displayPrios = check4:GetValue()
	end)
	check5:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.displayAlts = check5:GetValue()
	end)

	check6:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.displayGuildNote = check6:GetValue()
	end)

	slider1:SetCallback("OnMouseUp", function(slid)
		ItemListsDB.maxNames = slid:GetValue()
	end)

	parseData:SetCallback("OnClick", function (obj, button, down)
		--message(pasted)
		if pasted == "" then return end
		obj:SetText(ParseText(pasted))
		inputfield:SetText("")
	end)




	popup:SetCallback("OnClose", 
	function(widget)
	  AceGUI:Release(widget)
	  frameShown = false
	end
   )
end


function ThatsMyBis:OnInitialize() --Fires when the addon is being set up.
	self.db = LibStub("AceDB-3.0"):New("TMBDB", { profile = { minimap = { hide = false, }, }, })
	TMBIcon:Register("TMBTooltips", TMBLDB,  self.db.profile.minimap) 

end

function ThatsMyBis:OnEnable() --Fires when the addon loads, makes sure there is a db to look at.

	if ItemListsDB == nil then ItemListsDB = {} end
	if ItemListsDB.itemNotes == nil then ItemListsDB.itemNotes = {} end
	if ItemListsDB.enabled == nil then ItemListsDB.enabled = true end
	if ItemListsDB.displayPrioNote == nil then ItemListsDB.displayPrioNote = true end
	if ItemListsDB.displayGuildNote == nil then ItemListsDB.displayGuildNote = true end
	if ItemListsDB.displayRank == nil then ItemListsDB.displayRank = true end
	if ItemListsDB.displayWishes == nil then ItemListsDB.displayWishes = true end
	if ItemListsDB.displayPrios == nil then ItemListsDB.displayPrios = true end
	if ItemListsDB.displayAlts == nil then ItemListsDB.displayAlts = true end
	if ItemListsDB.maxNames == nil then ItemListsDB.maxNames = 3 end

	if ItemListsDB.enabled then 
		statusEnableText = "TMB Tooltips is currently: Enabled"
	end
	
end

local function ModifyItemTooltip( tt ) -- Function for modifying the tooltip
	if not ItemListsDB.enabled then return end
	local itemName, itemLink = tt:GetItem() 
	if not itemName then return end
	local itemID = select( 1, GetItemInfoInstant( itemName ) )
	
	if itemID == nil then
		itemID = tonumber( string.match( itemLink, "item:?(%d+):" ) )
		if itemID == nil then
			return
		end
	end

	local itemNotes = ItemListsDB.itemNotes[itemID]
	if itemNotes == nil then return end -- Item not in DB, escape out of function.

	if IsAltKeyDown() then --Display something different if alt is held down.
		local itemReceived = itemNotes.received
		local receivedString = ""
		tt:AddLine("Received item:")
		if itemReceived ~= nil then
			-- Construct the string to be displayed
			for k,v in pairs(itemReceived) do
				if k > ItemListsDB.maxNames then break end
				local altStatus = ""
				if displayAlts and v.character_is_alt == 1 then altStatus = "*" end
				receivedString = receivedString .. altStatus .. classColorsTable[ v.character_class ] .. v.character_name .. " "
			end
			tt:AddLine( receivedString )
		end
	else

		-- %%%%%%%%%%%%%%%%% PRIO NOTES
		if ItemListsDB.displayPrioNote then
			local rankData = ""
			local itemPrioNotes = itemNotes.prioNote
			if itemPrioNotes ~= nil and itemPrioNotes ~= "" then
				if ItemListsDB.displayRank and (itemNotes.rank ~= "") then rankData = " | \124cFFD97025Rank: " .. rankColorsTable[itemNotes.rank]..itemNotes.rank end
				tt:AddLine("Prio Notes:")
				tt:AddLine("\124cFFFFFFFF" .. itemPrioNotes .. rankData)
			end
		end

		-- %%%%%%%%%%%%%%%%% GUILD NOTES

		if ItemListsDB.displayGuildNote then
			local itemGuildNotes = itemNotes.guildNote
			if itemGuildNotes ~= nil and itemGuildNotes ~= "" then
				tt:AddLine("Guild Notes:")
				tt:AddLine("\124cFFFFFFFF" .. itemGuildNotes )
			end
		end
		-- %%%%%%%%%%%%%%%%% WISHLIST

		if ItemListsDB.displayWishes then
			local itemWishes = itemNotes.wishlist
			local wishlistString = ""
			if itemWishes ~= nil then
				-- Construct the string to be displayed
				for k,v in pairs(itemWishes) do
					if k > ItemListsDB.maxNames then break end
					local altStatus = ""
					if displayAlts and v.character_is_alt == 1 then altStatus = "*" end
					wishlistString = altStatus .. classColorsTable[ v.character_class ] .. v.character_name .. "[" .. v.sort_order .. "]" .. " " .. wishlistString
				end
				tt:AddLine("\124cFFFF8000" .. "Wishes:")
				tt:AddLine( wishlistString )
			end
		end

		-- %%%%%%%%%%%%%%%%% PRIOS

		if ItemListsDB.displayPrios then
			local itemPrios = itemNotes.priolist
			local prioListString = ""
			if itemPrios ~= nil then
				-- Construct the string to be displayed
				for k,v in pairs(itemPrios) do
					if k > ItemListsDB.maxNames then break end
					local altStatus = ""
					if displayAlts and v.character_is_alt == 1 then altStatus = "*" end
					prioListString = altStatus .. classColorsTable[ v.character_class ] .. v.character_name .. "[" .. v.sort_order .. "]" .. " " .. prioListString 
				end
				tt:AddLine("\124cFFFF8000" .. "Prio:")
				tt:AddLine( prioListString )
			end
		end

	end

end


ChatFrame_OnHyperlinkShow = function(...) -- Hook into the static item info window, not the tooltip.
    local chatFrame, link, text, button = ...
    local result = origChatFrame_OnHyperlinkShow(...)
    
        ShowUIPanel(ItemRefTooltip)
        if (not ItemRefTooltip:IsVisible()) then
            ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE")
        end
        
       	ModifyItemTooltip(ItemRefTooltip)

        ItemRefTooltip:Show(); ItemRefTooltip:Show()

    return result
end



local function InitFrame() --Starts the listener for tooltips
	GameTooltip:HookScript( "OnTooltipSetItem", ModifyItemTooltip )
end

function ParseText(input)
	if input == nil then return "NoData" end
	local header = "type,raid_name,member_name,character_name,character_class,character_is_alt,character_inactive_at,sort_order,item_name,item_id,note,received_at,import_id,item_note,item_prio_note,item_tier,item_tier_label,created_at,updated_at,"

	local parsedLines = {}
	local parsedEntries = {}
	
	for line in input:gmatch("([^\n]*)\n?") do -- Extract the lines into seperate entries in an array.
		table.insert(parsedLines, line..",")
	end
	if (parsedLines[1] ~= header) then return "Wrong Header" end -- Validate the header
	
	local headerData = {}
	for lineKey,line in pairs(parsedLines) do
		entry = {}
		if lineKey == 1 then
			headerData = ParseCSVLine(parsedLines[lineKey])
		else
			for key,value in pairs(ParseCSVLine(line)) do
				entry[ headerData[key] ] = value
			end
			table.insert(parsedEntries, entry)
		end
	end
	table.remove(parsedEntries) -- Pop of the malformed last entry.
	local noteTable = {}

	for k,e in pairs(parsedEntries) do
		local tempTable = {}
		local tempCharTable = {}

		tempTable = noteTable[ tonumber(e.item_id) ] --Try and load the item element
		if tempTable == nil then noteTable[ tonumber(e.item_id) ] = {} end -- Make an array because this is the first time the item is seen

		if e.type == "wishlist" then
			tempCharTable.character_class = e.character_class
			tempCharTable.character_name = e.character_name
			tempCharTable.sort_order = tonumber(e.sort_order)
			tempCharTable.member_name = e.member_name
			tempCharTable.character_is_alt = tonumber(e.character_is_alt)

			if tempTable ~= nil then tempTable = tempTable.wishlist end -- Look at the wishlist element if it exist then load it
			if tempTable == nil then --If the loaded item is nil then its the first wish for this item so just save it directly
				tempTable = {}
				table.insert(tempTable,tempCharTable)
			else -- Else insert it into the old one before saving.
				table.insert(tempTable,tempCharTable)
			end
			noteTable[tonumber(e.item_id)].wishlist = tempTable
		elseif e.type == "prio" then
			tempCharTable.character_class = e.character_class
			tempCharTable.character_name = e.character_name
			tempCharTable.sort_order = tonumber(e.sort_order)
			tempCharTable.member_name = e.member_name
			tempCharTable.character_is_alt = tonumber(e.character_is_alt)

			if tempTable ~= nil then tempTable = tempTable.priolist end -- Look at the priolist element if it exist then load it
			if tempTable == nil then --If the loaded item is nil then its the first wish for this item so just save it directly
				tempTable = {}
				table.insert(tempTable,tempCharTable)
			else -- Else insert it into the old one before saving.
				table.insert(tempTable,tempCharTable)
			end
			noteTable[tonumber(e.item_id)].priolist = tempTable
		elseif e.type == "received" then 
			tempCharTable.character_class = e.character_class
			tempCharTable.character_name = e.character_name
			tempCharTable.member_name = e.member_name
			tempCharTable.character_is_alt = tonumber(e.character_is_alt)

			if tempTable ~= nil then tempTable = tempTable.received end -- Look at the recieved element if it exist then load it
			if tempTable == nil then --If the loaded item is nil then its the first wish for this item so just save it directly
				tempTable = {}
				table.insert(tempTable,tempCharTable)
			else -- Else insert it into the old one before saving.
				table.insert(tempTable,tempCharTable)
			end
			noteTable[tonumber(e.item_id)].received = tempTable
		elseif e.type == "item_note" then 
			noteTable[tonumber(e.item_id)].prioNote = e.item_prio_note
			noteTable[tonumber(e.item_id)].guildNote = e.item_note
			noteTable[tonumber(e.item_id)].rank = e.item_tier_label
 		end
	end
	ItemListsDB["itemNotes"] = noteTable -- Add it to peristent storage
	return "Done"
end

function ParseCSVLine (line,sep) 
	local res = {}
	local pos = 1
	sep = sep or ','
	while true do 
		local c = string.sub(line,pos,pos)
		if (c == "") then break end
		if (c == '"') then
			-- quoted value (ignore separator within)
			local txt = ""
			repeat
				local startp,endp = string.find(line,'^%b""',pos)
				txt = txt..string.sub(line,startp+1,endp-1)
				pos = endp + 1
				c = string.sub(line,pos,pos) 
				if (c == '"') then txt = txt..'"' end 
				-- check first char AFTER quoted string, if it is another
				-- quoted string without separator, then temp it
				-- this is the way to "escape" the quote char in a quote. example:
				--   value1,"blub""blip""boing",value3  will result in blub"blip"boing  for the middle
			until (c ~= '"')
			table.insert(res,txt)
			assert(c == sep or c == "")
			pos = pos + 1
		else	
			-- no quotes used, just look for the first separator
			local startp,endp = string.find(line,sep,pos)
			if (startp) then 
				table.insert(res,string.sub(line,pos,startp-1))
				pos = endp + 1
			else
				-- no separator found -> use rest of string and terminate
				table.insert(res,string.sub(line,pos))
				break
			end 
		end
	end
	return res
end

InitFrame()
