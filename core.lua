local _, config = ...

local frame = CreateFrame( "Frame" )
local AceGUI = LibStub("AceGUI-3.0")

ThatsMyBis = LibStub("AceAddon-3.0"):NewAddon("ThatsMyBis", "AceConsole-3.0", "AceEvent-3.0")


local showAltStatus = 1


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

local function ModifyItemTooltip( tt ) -- Function for modifying the tooltip
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



	if IsAltKeyDown() then 
		local itemReceived = itemNotes.received
		local receivedString = ""
		tt:AddLine("Received item:")
		if itemReceived ~= nil then
			-- Construct the string to be displayed
			for k,v in pairs(itemReceived) do
				local altStatus = ""
				if showAltStatus == 1 and v.character_is_alt == 1 then altStatus = "*" end
				receivedString = receivedString .. altStatus .. classColorsTable[ v.character_class ] .. v.character_name .. " "
			end
			tt:AddLine( receivedString )
		end
	else

		-- %%%%%%%%%%%%%%%%% PRIO NOTES

		local itemPrioNotes = itemNotes.prioNote
		if itemPrioNotes ~= nil and itemPrioNotes ~= "" then
			if itemNotes.rank == nil then itemNotes.rank = "N" end
			tt:AddLine("Prio Notes:")
			tt:AddLine("\124cFFFFFFFF" .. itemPrioNotes .. " | \124cFFD97025Rank: " .. rankColorsTable[itemNotes.rank]..itemNotes.rank )
		end

		-- %%%%%%%%%%%%%%%%% GUILD NOTES

		local itemGuildNotes = itemNotes.guildNote
		if itemGuildNotes ~= nil and itemGuildNotes ~= "" then
			tt:AddLine("Guild Notes:")
			tt:AddLine("\124cFFFFFFFF" .. itemGuildNotes )
		end

		-- %%%%%%%%%%%%%%%%% WISHLIST

		local itemWishes = itemNotes.wishlist
		local wishlistString = ""
		if itemWishes ~= nil then
			-- Construct the string to be displayed
			for k,v in pairs(itemWishes) do
				local altStatus = ""
				if showAltStatus == 1 and v.character_is_alt == 1 then altStatus = "*" end
				wishlistString = altStatus .. classColorsTable[ v.character_class ] .. v.character_name .. "[" .. v.sort_order .. "]" .. " " .. wishlistString
			end
			tt:AddLine("\124cFFFF8000" .. "Wishes:")
			tt:AddLine( wishlistString )
		end

		-- %%%%%%%%%%%%%%%%% PRIOS

		local itemPrios = itemNotes.priolist
		local prioListString = ""
		if itemPrios ~= nil then
			-- Construct the string to be displayed
			for k,v in pairs(itemPrios) do
				local altStatus = ""
				if showAltStatus == 1 and v.character_is_alt == 1 then altStatus = "*" end
				prioListString = altStatus .. classColorsTable[ v.character_class ] .. v.character_name .. "[" .. v.sort_order .. "]" .. " " .. prioListString 
			end
			tt:AddLine("\124cFFFF8000" .. "Prio:")
			tt:AddLine( prioListString )
		end

	end

	


end

local origChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow
ChatFrame_OnHyperlinkShow = function(...)
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

function ThatsMyBis:OnEnable() --Fires when the addon loads, makes sure there is a db to look at.
	if ItemListsDB == nil then ItemListsDB = {} end
	if ItemListsDB.itemNotes == nil then ItemListsDB.itemNotes = {} end
end

local function InitFrame() --Starts the listener for tooltips
	GameTooltip:HookScript( "OnTooltipSetItem", ModifyItemTooltip )
end

InitFrame()
