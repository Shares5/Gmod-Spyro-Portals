AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

 
function ENT:Initialize()
	self:SetModel( "models/morganicism/spyro/portal.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	local vec1 = self:GetPos()
	local vec2 = Vector(0,200,-10)
	vec2:Add(vec1)
	--print(self:GetClass())
	self.exitportal = ents.Create( "exitportal" )
	self.exitportal:SetModel( "models/morganicism/spyro/portal.mdl" )
	self.exitportal:SetPos(vec2)
	self.exitportal:Spawn()
	self.exitportal:SetCreator(self:GetCreator())
	if CPPI then
		self.exitportal:CPPISetOwner(self:GetCreator())
	end
	self:GetPhysicsObject():SetMass(8000)
	self.exitportal:GetPhysicsObject():SetMass(8000)
	self.exitportal:SetUseType(SIMPLE_USE)
	self.exitportal.UseParent = self
	
	self.portals={}
	self.portals[1]=ents.Create("linked_portal_door")
	self.portals[2]=ents.Create("linked_portal_door")
	
	self.portals[1]:SetWidth(100)
	self.portals[1]:SetHeight(120)
	local portal1vec = self:GetPos()
	portal1vec:Add(Vector(0,0,59))
	self.portals[1]:SetPos(portal1vec)
	self.portals[1]:SetAngles(self:GetAngles())
	self.portals[1]:SetExit(self.portals[2])
	self.portals[1]:SetParent(self)
	self.portals[1]:Spawn()
	self.portals[1]:Activate()
	
	self.portals[2]:SetWidth(100)
	self.portals[2]:SetHeight(120)
	local portal2vec = self.exitportal:GetPos()
	portal2vec:Add(Vector(0,0,59))
	self.portals[2]:SetPos(portal2vec)
	self.portals[2]:SetAngles(self.exitportal:GetAngles())
	self.portals[2]:SetExit(self.portals[1])
	self.portals[2]:SetParent(self.exitportal)
	self.portals[2]:Spawn()
	self.portals[2]:Activate()
	
	self:SetUseType(SIMPLE_USE)
	
end
 
function ENT:Use( activator, caller )

	if(self.portals[1]:IsValid())then
		self.portals[1]:Remove()
		self.portals[2]:Remove()
		
	else
			
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Sleep()
		end
		local phys2 = self.exitportal:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Sleep()
		end
		
		self.portals[1]=ents.Create("linked_portal_door")
		self.portals[2]=ents.Create("linked_portal_door")
		
		self.portals[1]:SetWidth(100)
		self.portals[1]:SetHeight(120)
		local portal1vec = self:GetPos()
		portal1vec:Add(Vector(0,0,59))
		local selfangle=self:GetAngles()
		selfangle[1]=0
		selfangle[3]=0
		self:SetAngles(selfangle)
		self.portals[1]:SetAngles(selfangle)
		self.portals[1]:SetPos(portal1vec)
		self.portals[1]:SetExit(self.portals[2])
		self.portals[1]:SetParent(self)
		self.portals[1]:Spawn()
		self.portals[1]:Activate()
		
		self.portals[2]:SetWidth(100)
		self.portals[2]:SetHeight(120)
		local portal2vec = self.exitportal:GetPos()
		portal2vec:Add(Vector(0,0,59))
		local exitangle=self.exitportal:GetAngles()
		exitangle[1]=0
		exitangle[3]=0
		self.exitportal:SetAngles(exitangle)
		self.portals[2]:SetAngles(exitangle)
		self.portals[2]:SetPos(portal2vec)
		self.portals[2]:SetExit(self.portals[1])
		self.portals[2]:SetParent(self.exitportal)
		self.portals[2]:Spawn()
		self.portals[2]:Activate()
		
		self:PhysWake()
		self.exitportal:PhysWake()

		
	end
end 



function ENT:Think()
    -- We don't need to think, we are just a prop after all!
end 

function ENT:OnRemove()
	self.exitportal:Remove()
end