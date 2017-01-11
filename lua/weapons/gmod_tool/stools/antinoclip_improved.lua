--[[--------------------------------------------------------------------------
	Improved Anti-Noclip
	
	File name:
		antinoclip_improved.lua
		
	Author:
		- Original  :: RabidToaster (STEAM_0:1:9334395)
		- Rewritten :: Mista Tea    (STEAM_0:0:27507323)
		
	Changelog:
		
----------------------------------------------------------------------------]]

local mode = TOOL.Mode -- defined by the name of this file (default should be antinoclip_improved)

--[[--------------------------------------------------------------------------
-- Modules & Dependencies
--------------------------------------------------------------------------]]--

-- needed for localization support (depends on GMod locale: "gmod_language")
include( "improvedanc/localify.lua" )
localify.LoadSharedFile( "improvedanc/localization.lua" ) -- loads the file containing localized phrases
local L = localify.Localize                               -- used for translating string tokens into localized phrases
local prefix = "#tool."..mode.."."                        -- prefix used for this tool's localization tokens

-- needed for noclip handler functions
include( "improvedanc/improvedanc.lua" )
improvedanc.SetDefaultEffect( "bounce" )
improvedanc.SetDefaultAffect( "ignore_self" )

--[[--------------------------------------------------------------------------
-- Localized Functions & Variables
--------------------------------------------------------------------------]]--

-- localizing global functions/tables is an encouraged practice that improves code efficiency,
-- since accessing a local value is considerably faster than a global value
local net = net
local hook = hook
local util = util
local cvars = cvars
local pairs = pairs
local tobool = tobool
local IsValid = IsValid
local surface = surface
local language = language
local GetConVarNumber = GetConVarNumber

-- enums for sending notifications
-- certain gamemodes like DarkRP don't have these enums, so there are hardcoded fallback values in place to fix this
local NOTIFY_GENERIC = NOTIFY_GENERIC or 0
local NOTIFY_ERROR   = NOTIFY_ERROR   or 1
local NOTIFY_CLEANUP = NOTIFY_CLEANUP or 4

local MIN_NOTIFY_BITS = 3 -- the minimum number of bits needed to send a NOTIFY enum
local NOTIFY_DURATION = 5 -- the number of seconds to display notifications

--[[--------------------------------------------------------------------------
-- Tool Settings
--------------------------------------------------------------------------]]--

TOOL.Name     = L(prefix.."name")
TOOL.Category = "Construction"

TOOL.Information = {
	"left",
	"right",
	"reload",
}

if ( CLIENT ) then

	--[[--------------------------------------------------------------------------
	-- Language Settings
	--------------------------------------------------------------------------]]--

	language.Add( "tool."..mode..".name",   L(prefix.."name") )
	language.Add( "tool."..mode..".desc",   L(prefix.."desc") )
	language.Add( "tool."..mode..".left",   L(prefix.."left") )
	language.Add( "tool."..mode..".right",  L(prefix.."right") )
	language.Add( "tool."..mode..".reload", L(prefix.."reload") )
	
	--[[--------------------------------------------------------------------------
	-- Net Messages
	--------------------------------------------------------------------------]]--
	
	--[[--------------------------------------------------------------------------
	-- 	Net :: <toolmode>_notif( string )
	--]]--
	net.Receive( mode.."_notif", function( bytes )
		notification.AddLegacy( net.ReadString(), net.ReadUInt(MIN_NOTIFY_BITS), NOTIFY_DURATION )
		local sound = net.ReadString()
		if ( sound ~= "" and GetConVarNumber( mode.."_notifs_sound" ) == 1 ) then surface.PlaySound( sound ) end
	end )
	
	--[[--------------------------------------------------------------------------
	-- 	Net :: <toolmode>_error( string )
	--]]--
	net.Receive( mode.."_error", function( bytes )
		surface.PlaySound( "buttons/button10.wav" )
		notification.AddLegacy( net.ReadString(), net.ReadUInt(MIN_NOTIFY_BITS), NOTIFY_DURATION )
	end )
	
	--[[--------------------------------------------------------------------------
	-- CVars
	--------------------------------------------------------------------------]]--
	
	TOOL.ClientConVar[ "mode" ]          = improvedanc.GetDefaultAffect() or ""
	TOOL.ClientConVar[ "notifs"]         = "1"
	TOOL.ClientConVar[ "notifs_sound" ]  = "1"
	TOOL.ClientConVar[ "tooltip_show" ]  = "0"
	TOOL.ClientConVar[ "tooltip_scale" ] = "24"
	TOOL.ClientConVar[ "halo" ]          = "1"
	TOOL.ClientConVar[ "halo_r" ]        = "255"
	TOOL.ClientConVar[ "halo_g" ]        = "0"
	TOOL.ClientConVar[ "halo_b" ]        = "0"
	TOOL.ClientConVar[ "halo_a" ]        = "255"
	for name, func in pairs( improvedanc.GetEffects() ) do
		TOOL.ClientConVar[ name ] = "0"
	end
	
	--[[--------------------------------------------------------------------------
	-- Client Functions
	--------------------------------------------------------------------------]]--
	
	local cvarAddHalo = GetConVar( mode.."_halo" )
	local cvarHaloR   = GetConVar( mode.."_halo_r" )
	local cvarHaloG   = GetConVar( mode.."_halo_g" )
	local cvarHaloB   = GetConVar( mode.."_halo_b" )
	local cvarHaloA   = GetConVar( mode.."_halo_a" )
	
	function TOOL:Init()
		-- setup the fonts we'll be using when drawing the HUD
		surface.CreateFont( mode.."_tooltip", { font = "coolvetica", size = GetConVarNumber( mode.."_tooltip_scale", 24 ), weight = 500 } )
		
		cvarAddHalo = GetConVar( mode.."_halo" )
		cvarHaloR   = GetConVar( mode.."_halo_r" )
		cvarHaloG   = GetConVar( mode.."_halo_g" )
		cvarHaloB   = GetConVar( mode.."_halo_b" )
		cvarHaloA   = GetConVar( mode.."_halo_a" )
	end	
	
	--[[--------------------------------------------------------------------------
	-- 	ShouldAddHalo(), GetHaloColor()
	--	Returns true if the anti-noclip protected props should have halos drawn on them for added visibility.
	--	Gets the RGBA values of the halo color.
	--]]--
	local function ShouldAddHalo() return cvarAddHalo:GetBool() end
	local function GetHaloColor()  return Color( cvarHaloR:GetInt(), cvarHaloG:GetInt(), cvarHaloB:GetInt(), cvarHaloA:GetInt() ) end
	
	--[[--------------------------------------------------------------------------
	-- 	CVar :: <toolmode>_tooltip_scale( string, string, string )
	--
	--	Callback function to automatically create a new font with the given scale size.
	--	This method is a bit excessive if the player changes the scale thousands of times,
	--	but otherwise shouldn't be an issue.
	--]]--
	cvars.AddChangeCallback( mode.."_tooltip_scale", function( name, old, new )
		new = tonumber( new )
		if ( not new ) then return false end
		
		surface.CreateFont( mode.."_tooltip", {
			font = "coolvetica",
			size = (new > 0 and new or 1),
			weight = 500,
		})
	end, mode )
	
	--[[--------------------------------------------------------------------------
	-- 	ComplexText( string, table, table, number, number, number, number, function, color )
	--
	--	Draws a complex line of text on the screen, allowing multiple colors and a callback 
	--	function to paint things behind it or change the x,y coordinates.
	--]]--
	local function ComplexText( font, textTbl, colorTbl, x, y, alignX, alignY, callback, defaultColor )
		surface.SetFont( font )
		local w, h = 0, 0
		local str = ""
		
		for i, text in pairs( textTbl ) do
			str = str .. text
			w, h = surface.GetTextSize( str )
		end
		
		x, y = callback( x, y, w, h ) or x, y
		w, h = 0, 0
		str = ""
		
		for i, text in pairs( textTbl ) do
			draw.SimpleText( text, font, x + w, y, colorTbl[i] or defaultColor or color_white, alignX, alignY )		
			str = str .. text
			w, h = surface.GetTextSize( str )
		end
		
		return w, h
	end
	
	local COLOR_BLUE        = Color( 100, 150, 255 )
	local COLOR_TRANSPARENT = Color( 0, 0, 0, 200 )
	local font = mode .. "_tooltip"
	
	--[[--------------------------------------------------------------------------
	-- 	DrawHUD (Hook :: HUDPaint)
	--
	--	Draws the tooltip onto the client's screen whenever they have the improved anti-noclip tool selected.
	--]]--
	local function DrawHUD()
		local ply = LocalPlayer()
		if ( not IsValid( ply ) ) then return end
		
		-- if they aren't forcing the tooltip to always show, check if they have the toolgun out and have anti-noclip selected
		local wep = ply:GetActiveWeapon()
		if ( not tobool( ply:GetInfo( mode.."_tooltip_show" ) ) and (not IsValid( wep ) or wep:GetClass() ~= "gmod_tool" or ply:GetInfo( "gmod_toolmode" ) ~= mode) ) then return end
		
		local tr  = ply:GetEyeTrace()
		local ent = tr.Entity
		
		-- ignore invalid entities and players
		if ( not IsValid( ent ) ) then return end
		if ( ent:IsPlayer() )     then return end
		
		-- check if the entity has anti-noclip protection applied to it
		if ( ent:GetNWString( "AntiNoClipAffect" ) ~= "" ) then
			local pos = (ent:GetPos() + ent:OBBCenter()):ToScreen()
			
			-- draws the multicolored tooltip on the client's screen
			ComplexText( font,
				{ "Affect: ", ent:GetNWString( "AntiNoClipAffect" ) }, 
				{ color_white, COLOR_BLUE }, pos.x, pos.y, 0, 0,
				function( x, y, w, h )
					x = x - w/2
					draw.RoundedBox( 0, x-10, y-5, w+20, h+10, COLOR_TRANSPARENT )
					draw.RoundedBox( 0, x-8,  y-3, w+16, h+6,  COLOR_TRANSPARENT )
					return x, y
				end
			)
			
			if ( not ShouldAddHalo() ) then return end
			halo.Add( {ent}, GetHaloColor() )
		end
	end
	hook.Add( "HUDPaint", mode.."_hud", DrawHUD )
	
elseif ( SERVER ) then

	util.AddNetworkString( mode.."_notif" )
	util.AddNetworkString( mode.."_error" )
	
	--[[--------------------------------------------------------------------------
	-- 	TOOL:SendNotif( string )
	--
	--	Convenience function for sending a notification to the tool owner.
	--]]--
	function TOOL:SendNotif( str, notify, sound )
		if ( not self:ShouldSendNotification() ) then return end
		
		net.Start( mode.."_notif" )
			net.WriteString( str )
			net.WriteUInt( notify or NOTIFY_GENERIC, MIN_NOTIFY_BITS )
			net.WriteString( sound or "" )
		net.Send( self:GetOwner() )
	end
	
	--[[--------------------------------------------------------------------------
	--	TOOL:SendError( str )
	--
	--	Convenience function for sending an error to the tool owner.
	--]]--
	function TOOL:SendError( str )		
		net.Start( mode.."_error" )
			net.WriteString( str )
			net.WriteUInt( notify or NOTIFY_ERROR, MIN_NOTIFY_BITS )
		net.Send( self:GetOwner() )
	end
	
	--[[--------------------------------------------------------------------------
	--	TOOL:ShouldSendNotification()
	--]]--
	function TOOL:ShouldSendNotification() return
		self:GetClientNumber( "notifs" ) == 1
	end
	
	--[[--------------------------------------------------------------------------
	--	TOOL:GetAffects()
	--]]--
	function TOOL:GetAffects() return
		self:GetClientInfo( "mode" ) == "" and improvedanc.GetDefaultAffect() or self:GetClientInfo( "mode" )
	end
	
	--[[--------------------------------------------------------------------------
	--	TOOL:GetEffects()
	--]]--	
	function TOOL:GetEffects()
		local tbl = {}
		
		for name, func in pairs( improvedanc.GetEffects() ) do
			if ( tobool( self:GetClientNumber( name ) ) ) then
				tbl[ name ] = true
			end
		end
		
		return tbl
	end
	
end

--[[--------------------------------------------------------------------------
-- Tool Functions
--------------------------------------------------------------------------]]--

--[[--------------------------------------------------------------------------
--
-- 	TOOL:LeftClick( table )
--	
--]]--
function TOOL:LeftClick( tr, isRemoving )
	local ent = tr.Entity
	
	if ( not IsValid( ent ) ) then return false end -- ignore invalid entities
	if ( ent:IsPlayer() )     then return false end -- ignore players
	if ( CLIENT )             then return true  end -- leave the rest up to the server
	if ( hook.Run( "AntiNoClip", self:GetOwner(), ent ) == false ) then return false end

	local handler = improvedanc.GetHandler( ent )

	if ( isRemoving ) then
		if ( not IsValid( handler ) ) then
			self:SendError( L(prefix.."notif_no_handler", localify.GetLocale( self:GetOwner() )) )
			return false
		end
		
		improvedanc.RemoveHandler( ent )
		self:SendNotif( L(prefix.."notif_removed", localify.GetLocale( self:GetOwner() )), NOTIFY_ERROR )		
	else
		improvedanc.AddHandler( self:GetOwner(), ent, { affects = self:GetAffects(), effects = self:GetEffects() } )
		self:SendNotif( L(prefix.."notif_applied", localify.GetLocale( self:GetOwner() )), NOTIFY_GENERIC, "buttons/button14.wav" )	
	end
	
	return true

end

--[[--------------------------------------------------------------------------
--
-- 	TOOL:RightClick( table )
--	
--]]--
function TOOL:RightClick( tr )

	local ent = tr.Entity
	
	if ( not IsValid( ent ) ) then return false end -- ignore invalid entities
	if ( ent:IsPlayer() )     then return false end -- ignore players
	if ( CLIENT )             then return true  end -- leave the rest up to the server
	
	local handler = improvedanc.GetHandler( ent )
	
	if ( not IsValid( handler ) ) then
		self:SendError( L(prefix.."notif_no_handler", localify.GetLocale( self:GetOwner() )) )
		return false
	end
	
	self:GetOwner():ConCommand( mode.."_mode "..tostring( ( handler:GetNoClipAffects() ) ) )
	
	local effects = handler:GetNoClipEffects()
	for name, func in pairs( improvedanc.GetEffects() ) do
		self:GetOwner():ConCommand( mode.."_"..name.." "..(effects[name] and "1" or "0") )
	end
	
	self:SendNotif( L(prefix.."notif_copied", localify.GetLocale( self:GetOwner() )), NOTIFY_CLEANUP )
	
	return true
	
end

--[[--------------------------------------------------------------------------
--
-- 	TOOL:Reload( table )
--	
--]]--
function TOOL:Reload( tr )
	
	return self:LeftClick( tr, true )
	
end

local TOOL = TOOL

--[[--------------------------------------------------------------------------
--
-- 	TOOL.BuildCPanel( panel )
--
--]]--
local function buildCPanel( cpanel )
	-- quick presets for default settings
	local presetsDefault = {}
	local presetsCvars   = {}
	for name, value in pairs( TOOL.ClientConVar ) do
		presetsDefault[ mode.."_"..name ] = value
		presetsCvars[ #presetsCvars + 1 ] = mode.."_"..name
	end
	local presets = { 
		Label      = "Presets",
		MenuButton = 1,
		Folder     = mode,
		Options = {
			[L(prefix.."combobox_default")] = presetsDefault
		},
		CVars = presetsCvars
	}
	
	-- populate the table of 'affect' options
	local affects = {
		Label = L(prefix.."label_affects"),
		MenuButton = 0,
		Options = {}
	}
	for name, func in pairs( improvedanc.GetAffects() ) do
		affects.Options[L(prefix.."combobox_"..name)] = { [mode.."_mode"] = name }
	end
	
	-- populate the table 'effects' checkboxes
	local sortedEffects = table.GetKeys( improvedanc.GetEffects() )
	table.sort( sortedEffects )
	local effectsCheckboxes = {}
	for k, name in ipairs( sortedEffects ) do
		effectsCheckboxes[ k ] = { Label = L(prefix.."checkbox_"..name), Command = mode .. "_"..name }
	end
	
	-- populate the table of valid languages that clients can switch between
	local languageOptions = {}
	for code, tbl in pairs( localify.GetLocalizations() ) do
		if ( not L(prefix.."language_"..code, code) ) then continue end
		languageOptions[ L(prefix.."language_"..code, code) ] = { localify_language = code }
	end
	local languages = {
		Label      = L(prefix.."label_language"),
		MenuButton = 0,
		Options    = languageOptions,
	}
	
	-- listen for changes to the localify language and reload the menu to update the localizations
	cvars.AddChangeCallback( "localify_language", function( name, old, new )
		local cpanel = controlpanel.Get( mode )
		if ( not IsValid( cpanel ) ) then return end
		cpanel:ClearControls()
		buildCPanel( cpanel )
	end, "improvedantinoclip" )

	cpanel:AddControl( "ComboBox", languages )
	cpanel:ControlHelp( "\n" .. L(prefix.."label_credits") )
	cpanel:AddControl( "Label", { Text = L(prefix.."desc") } )
	cpanel:AddControl( "ComboBox", presets )
	cpanel:ControlHelp( "" )
	cpanel:AddControl( "ComboBox", affects )
	cpanel:ControlHelp( "" )
	for k,v in ipairs( effectsCheckboxes ) do
		cpanel:AddControl( "Checkbox", v )
	end
	cpanel:ControlHelp( "\n" )
	cpanel:AddControl( "Slider",   { Label = L(prefix.."label_tooltip_scale"),     Command = mode.."_tooltip_scale", Type = "Numeric", Min = "1", Max = "128" } )
	cpanel:ControlHelp( L(prefix.."help_tooltip_scale") .. "\n" )
	cpanel:AddControl( "Checkbox", { Label = L(prefix.."checkbox_tooltip_show"),   Command = mode.."_tooltip_show" } )
	cpanel:ControlHelp( L(prefix.."help_tooltip_show") )
	cpanel:AddControl( "Checkbox", { Label = L(prefix.."checkbox_notifs"),         Command = mode.."_notifs" } )
	cpanel:ControlHelp( L(prefix.."help_notifs") )
	cpanel:AddControl( "Checkbox", { Label = L(prefix.."checkbox_notifs_sound"),   Command = mode.."_notifs_sound" } )
	cpanel:ControlHelp( L(prefix.."help_notifs_sound") )
	cpanel:AddControl( "Checkbox", { Label = L(prefix.."checkbox_halo"),           Command = mode.."_halo" } )
	cpanel:AddControl( "Color",    { Label = L(prefix.."label_halo_color"), Red = mode.."_halo_r", Green = mode.."_halo_g", Blue = mode.."_halo_b", Alpha = mode.."_halo_a" } )
	
end

TOOL.BuildCPanel = buildCPanel