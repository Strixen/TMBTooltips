local _, config = ...

local frame = CreateFrame( "Frame" )
tmb = LibStub("AceAddon-3.0"):NewAddon("TMBHelper", "AceConsole-3.0", "AceEvent-3.0")
local AceGUI = LibStub("AceGUI-3.0")

local lastID = -1

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

	-- Gotten the iten id, pull data from the DB, skip if its the same as last time. 

		local itemPrios = ItemListsDB.itemnotes[itemID]
		local itemWishlist = ItemListsDB.wishlist[itemID]
		local itemPriolist = ItemListsDB.priolist[itemID]
		
	-- Check if there is anything on that item and display it if thats the case

	if itemPrios ~= nil and itemPrios ~= "" then
		tt:AddLine("Prio Notes:")
		tt:AddLine( itemPrios )
	end

	if itemWishlist ~= nil and itemWishlist ~= "" then
		tt:AddLine("\124cFFFF8000" .. "Wishes:")
		tt:AddLine( "\124cFFFF8000" .. itemWishlist )
	end

	if itemPriolist ~= nil and itemPriolist ~= ""  then
		tt:AddLine("\124cFFFFFFFF" .. "Prios:")
		tt:AddLine( "\124cFFFFFFFF" .. itemPriolist )
	end


end

function tmb:OnEnable() --Fires when the addon loads, makes sure there is a db to look at.
	if ItemListsDB == nil then ItemListsDB = {} end
	if ItemListsDB.itemnotes == nil then ItemListsDB.itemnotes = {} end
	if ItemListsDB.wishlist == nil then ItemListsDB.wishlist = {} end
	if ItemListsDB.priolist == nil then ItemListsDB.priolist = {} end
end

local function InitFrame() --Starts the listener for tooltips
	GameTooltip:HookScript( "OnTooltipSetItem", ModifyItemTooltip )
end

InitFrame()
