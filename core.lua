local _, config = ...

local frame = CreateFrame( "Frame" )

tmb = LibStub("AceAddon-3.0"):NewAddon("TMBHelper", "AceConsole-3.0", "AceEvent-3.0")
local AceGUI = LibStub("AceGUI-3.0")

local previousItemID = -1

REALM = GetRealmName()


local function ModifyItemTooltip( tt ) 
	
	local itemName, itemLink = tt:GetItem() 
	if not itemName then return end
	local itemID = select( 1, GetItemInfoInstant( itemName ) )
	
	if itemID == nil then
		itemID = tonumber( string.match( itemLink, "item:?(%d+):" ) )
		if itemID == nil then
			return
		end
	end

		local itemPrios = ItemListsDB.itemnotes[itemID]
		local itemWishlist = ItemListsDB.wishlist[itemID]
		local itemPriolist = ItemListsDB.priolist[itemID]

	if itemPrios ~= nil then
		tt:AddLine("Prio Notes:")
		tt:AddLine( itemPrios )
	end

	if itemWishlist ~= nil then
		tt:AddLine("\124cFFFF8000" .. "Wishes:")
		tt:AddLine( "\124cFFFF8000" .. itemWishlist )
	end

	if itemPriolist ~= nil then
		tt:AddLine("\124cFFFFFFFF" .. "Prios:")
		tt:AddLine( "\124cFFFFFFFF" .. itemPriolist )
	end

end

--[[ function tmb:OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == "TMBHelper" then
		message("test")
		if ItemListDB["prioNotes"] == nil then 
			ItemListDB["prioNotes"] = {}
			ItemListDB["wishlist"] = {}
			ItemListDB["priolist"] = {}
		end
	 end
end ]]

function tmb:OnEnable()
	if ItemListsDB == nil then ItemListsDB = {} end
	if ItemListsDB.itemnotes == nil then ItemListsDB.itemnotes = {} end
	if ItemListsDB.wishlist == nil then ItemListsDB.wishlist = {} end
	if ItemListsDB.priolist == nil then ItemListsDB.priolist = {} end
end

local function InitFrame()

	GameTooltip:HookScript( "OnTooltipSetItem", ModifyItemTooltip )
	--ItemRefTooltip:HookScript( "OnTooltipSetItem", ModifyItemTooltip )
end


InitFrame()
