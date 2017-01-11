--[[--------------------------------------------------------------------------
	Improved Anti-NoClip Module
	
	Author:
		Mista-Tea ([IJWTB] Thomas)
	
	License:
		The MIT License (MIT)
		Copyright (c) 2015-2017 Mista-Tea
		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:
		The above copyright notice and this permission notice shall be included in all
		copies or substantial portions of the Software.
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
		SOFTWARE.
			
	Changelog:
----------------------------------------------------------------------------]]

--[[--------------------------------------------------------------------------
-- 	Namespace Tables
--------------------------------------------------------------------------]]--

module( "improvedanc", package.seeall )

--[[--------------------------------------------------------------------------
-- 	Localized Functions & Variables
--------------------------------------------------------------------------]]--

--[[--------------------------------------------------------------------------
--	Namespace Functions
--------------------------------------------------------------------------]]--

if ( SERVER ) then

	m_Handlers = m_Handlers or {}
	
	--[[--------------------------------------------------------------------------
	-- 	AddHandler( entity )
	--]]--
	function AddHandler( ply, ent, data )
		local handler = GetHandler( ent )
		
		if ( not IsValid( handler ) ) then
			undo.Create( "antinoclip_improved" )
				handler = CreateHandler( ent )
				handler:SetOwner( ply )
				undo.AddEntity( handler )
				undo.SetPlayer( ply )
			undo.Finish()
		end
		
		handler:SetNoClipAffects( data.affects )
		handler:SetNoClipEffects( data.effects )
		
		duplicator.StoreEntityModifier( ent, "antinoclip_improved", data )
		
		m_Handlers[ ent ] = handler
	end
	duplicator.RegisterEntityModifier( "antinoclip_improved", AddHandler )
	
	--[[--------------------------------------------------------------------------
	-- 	CreateHandler( entity )
	--]]--
	function CreateHandler( ent )
		local handler = ents.Create( "noclip_handler" )
		handler:SetHandledEntity( ent )
		handler:Spawn()
		
		ent:CallOnRemove( "AntiNoClipImproved", function( ent )
			RemoveHandler( ent )
		end )
		
		handler:CallOnRemove( "AntiNoClipImproved", function( handler, ent )
			if ( not IsValid( ent ) ) then return end
			ent:SetNWString( "AntiNoClipAffect", "" )
		end, ent )
		
		return handler
	end
	
	--[[--------------------------------------------------------------------------
	-- 	RemoveHandler( entity )
	--
	--]]--
	function RemoveHandler( ent )
		local handler = m_Handlers[ ent ]
		m_Handlers[ ent ] = nil
		
		if ( IsValid( handler ) ) then
			handler:Remove()
		end
		
		ent:SetNWString( "AntiNoClipAffect", "" )
	end
	
	--[[--------------------------------------------------------------------------
	-- 	GetHandlers()
	--]]--
	function GetHandlers()
		return m_Handlers
	end
	
	--[[--------------------------------------------------------------------------
	-- 	GetHandler( entity )
	--]]--
	function GetHandler( ent )
		return m_Handlers[ ent ]
	end
	
elseif ( CLIENT ) then end


if ( CLIENT or SERVER ) then

	m_Effects = m_Effects or {}
	m_Affects = m_Affects or {}
	
	m_DEFAULT_EFFECT = m_DEFAULT_EFFECT or nil
	m_DEFAULT_AFFECT = m_DEFAULT_AFFECT or nil
	
	--[[--------------------------------------------------------------------------
	-- 	RegisterEffect( string, function )
	--]]--
	function RegisterEffect( name, func )
		m_Effects[ name:lower() ] = func
	end
	
	--[[--------------------------------------------------------------------------
	-- 	SetDefaultEffect( string )
	--]]--
	function SetDefaultEffect( name )
		m_DEFAULT_EFFECT = name
	end
	
	--[[--------------------------------------------------------------------------
	-- 	GetDefaultEffect()
	--]]--
	function GetDefaultEffect()
		return m_DEFAULT_EFFECT
	end
	
	--[[--------------------------------------------------------------------------
	-- 	GetEffects()
	--]]--
	function GetEffects()
		return m_Effects
	end
	
	--[[--------------------------------------------------------------------------
	-- 	GetEffect( string )
	--]]--
	function GetEffect( name )
		return m_Effects[ name:lower() ]
	end
	
	RegisterEffect( "bounce", function( ply )
		ply:SetMoveType( MOVETYPE_WALK )
		ply:SetPos( ply:GetPos() + ( ply:GetVelocity():GetNormal() * -50 ) )
		ply:SetVelocity( ply:GetVelocity():GetNormal() * -2000 ) --[[TODO: Variable stength]] end )
	RegisterEffect( "ignite",       function( ply ) ply:Ignite( 60 ) --[[TODO: Variable duration]] end )
	RegisterEffect( "kill",         function( ply ) ply:Kill() end )
	RegisterEffect( "respawn",      function( ply ) ply:Spawn() end )
	RegisterEffect( "stripweapons", function( ply ) ply:StripWeapons() end )
	RegisterEffect( "teleport",     function( ply )
		local spawnpoint = gamemode.Call( "PlayerSelectSpawn", ply )
		if ( IsValid( spawnpoint ) ) then
			ply:SetPos( spawnpoint:GetPos() )
		end
	end )
	RegisterEffect( "walk",         function( ply )
		ply:SetMoveType( MOVETYPE_WALK )
		ply:SetPos( ply:GetPos() + ( ply:GetVelocity():GetNormal() * -50 ) )
	end )
	
	--[[--------------------------------------------------------------------------
	-- 	RegisterAffect( string, function )
	--]]--
	function RegisterAffect( name, func )
		m_Affects[ name:lower() ] = func
	end

	--[[--------------------------------------------------------------------------
	-- 	SetDefaultEffect( string )
	--]]--
	function SetDefaultAffect( name )
		m_DEFAULT_AFFECT = name
	end
	
	--[[--------------------------------------------------------------------------
	-- 	GetDefaultEffect()
	--]]--
	function GetDefaultAffect()
		return m_DEFAULT_AFFECT
	end
	
	--[[--------------------------------------------------------------------------
	-- 	GetAffects()
	--]]--
	function GetAffects()
		return m_Affects
	end
	
	--[[--------------------------------------------------------------------------
	-- 	GetAffect( string )
	--]]--
	function GetAffect( name )
		return m_Affects[ name:lower() ]
	end
	
	RegisterAffect( "ignore_self",     function( owner, ply, ent ) return ply ~= owner end )
	RegisterAffect( "ignore_admins",   function( owner, ply, ent ) return not ply:IsAdmin() end )
	RegisterAffect( "ignore_team",     function( owner, ply, ent ) return ply:Team() ~= owner:Team() end )
	RegisterAffect( "ignore_buddies",  function( owner, ply, ent ) return gamemode.Call( "PlayerUse", ply, ent ) == false end )
	RegisterAffect( "affect_self",     function( owner, ply, ent ) return ply == owner end )
	RegisterAffect( "affect_team",     function( owner, ply, ent ) return ply:Team() == owner():Team() end )
	RegisterAffect( "affect_buddies",  function( owner, ply, ent ) return gamemode.Call( "PlayerUse", ply, ent ) ~= false end )
	RegisterAffect( "affect_everyone", function( owner, ply, ent ) return true end )
	
end