--[[--------------------------------------------------------------------------
	Improved Anti-Noclip
	
	File name:
		noclip_handler.lua
		
	Author:
		- Original  :: RabidToaster (STEAM_0:1:9334395)
		- Rewritten :: Mista Tea    (STEAM_0:0:27507323)
		
	Changelog:
		
----------------------------------------------------------------------------]]

local pcall = pcall
local ipairs = ipairs
local IsValid = IsValid
local SOLID_VPHYSICS = SOLID_VPHYSICS
local MOVETYPE_NOCLIP = MOVETYPE_NOCLIP
local RENDERMODE_TRANSALPHA = RENDERMODE_TRANSALPHA

local TRANSPARENT = Color(255,255,255,0)

AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

--[[--------------------------------------------------------------------------
-- Entity Settings
--------------------------------------------------------------------------]]--

ENT.PrintName      = "Noclip Handler"
ENT.Author         = "Mista-Tea"
ENT.Spawnable      = false
ENT.AdminSpawnable = false

--[[--------------------------------------------------------------------------
-- Entity Functions
--------------------------------------------------------------------------]]--

if ( SERVER ) then

	--[[--------------------------------------------------------------------------
	--
	-- 	ENT:Initialize()
	--
	--]]--
	function ENT:Initialize()
		if ( not IsValid( self:GetHandledEntity() ) ) then
			self:Remove()
			return
		end

		self.m_NoClipEffects = self.m_NoClipEffects or {}
		self.m_NoClipAffects = self.m_NoClipAffects or function() end
		
		-- mirror the handled entity in every way so that the collision bounds match up
		local handledEnt = self:GetHandledEntity()
		self:SetModel( handledEnt:GetModel() )
		self:SetPos( handledEnt:GetPos() )
		self:SetAngles( handledEnt:GetAngles() )
		-- we set the rendermode so we can make it invisible, otherwise it'll end up
		-- covering the handled entity (e.g., Sprops and Hunter props)
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
		self:SetColor( TRANSPARENT )
		
		self:SetSolid( SOLID_VPHYSICS )
		self:SetTrigger( true )
		self:SetNotSolid( true )
		
		-- finally, parent it so it acts as a single entity with the same position and angle
		self:SetParent( handledEnt )
	end

	--[[--------------------------------------------------------------------------
	--
	-- 	ENT:StartTouch( entity )
	--
	--]]--
	function ENT:StartTouch( ent )
		if ( not ( IsValid( ent ) and ent:IsPlayer() and ent:GetMoveType() == MOVETYPE_NOCLIP ) ) then return end
		if ( not IsValid( self:GetOwner() ) ) then return end
		
		local affects = improvedanc.GetAffect( self.m_NoClipAffects )
		if ( not ( affects and affects( self:GetOwner(), ent, self ) ) ) then return end
		
		for name, _ in pairs( self.m_NoClipEffects ) do
			local func = improvedanc.GetEffect( name )
			if ( not func ) then continue end
			
			pcall( func, ent )
		end
	end
	
	--[[--------------------------------------------------------------------------
	--
	-- 	ENT:SetNoClipEffects( table )
	--
	--]]--
	function ENT:SetNoClipEffects( tbl )
		self.m_NoClipEffects = tbl
	end

	--[[--------------------------------------------------------------------------
	--
	-- 	ENT:GetNoClipEffects()
	--
	--]]--
	function ENT:GetNoClipEffects()
		return self.m_NoClipEffects
	end

	--[[--------------------------------------------------------------------------
	--
	-- 	ENT:SetNoClipAffects( function )
	--
	--]]--
	function ENT:SetNoClipAffects( func )
		self.m_NoClipAffects = func
		self.m_HandledEnt:SetNWString( "AntiNoClipAffect", func )
	end

	--[[--------------------------------------------------------------------------
	--
	-- 	ENT:GetNoClipAffects()
	--
	--]]--
	function ENT:GetNoClipAffects()
		return self.m_NoClipAffects
	end

	--[[--------------------------------------------------------------------------
	--
	-- 	ENT:SetHandledEntity( entity )
	--
	--]]--
	function ENT:SetHandledEntity( ent )
		self.m_HandledEnt = ent
	end

	--[[--------------------------------------------------------------------------
	--
	-- 	ENT:GetHandledEntity()
	--
	--]]--
	function ENT:GetHandledEntity()
		return self.m_HandledEnt
	end

end