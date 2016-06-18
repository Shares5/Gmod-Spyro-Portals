AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

 
function ENT:Initialize()
	--self:SetModel( "models/morganicism/spyro/portal.mdl" )

	--self:PhysicsInit( SOLID_VPHYSICS )      
	--self:SetMoveType( MOVETYPE_VPHYSICS )   
	--self:SetSolid( SOLID_VPHYSICS )         
	
    --local phys = self:GetPhysicsObject()
	--if (phys:IsValid()) then
	--	phys:Wake()
	--end
	
	
	local vec1 = self:GetPos()
	self.entryportal = ents.Create("exitportal")
	self.entryportal:SetPos(vec1)
	self.entryportal:SetModel("models/morganicism/spyro/portal.mdl")
	self.entryportal:Spawn()
	local vec2 = Vector(0,500,-10)
	vec2:Add(vec1)
	--print(self:GetClass())
	self.exitportal = ents.Create( "exitportal" )
	self.exitportal:SetModel( "models/morganicism/spyro/portal.mdl" )
	self.exitportal:SetPos(vec2)
	self.exitportal:Spawn()
	self.entryportal:SetCreator(self:GetCreator())
	if CPPI then
		self.entryportal:CPPISetOwner(self:GetCreator())
	end
	self.exitportal:SetCreator(self:GetCreator())
	if CPPI then
		self.exitportal:CPPISetOwner(self:GetCreator())
	end

	self.exitportal:SetUseType(SIMPLE_USE)
	self.exitportal.UseParent = self
	self.entryportal.UseParent = self
	self.entryportal:SetModelScale(2, 0)
	self.exitportal:SetModelScale(2, 0)
	self.entryportal:Activate()
	self.entryportal:PhysWake()
	self.exitportal:Activate()
		--print(IsValid(self.entryportal:GetPhysicsObject()))
	self.entryportal:GetPhysicsObject():SetMass(8000)

	self.exitportal:GetPhysicsObject():SetMass(8000)
	
	
	self.portals={}
	self.portals[1]=ents.Create("linked_portal_door")
	self.portals[2]=ents.Create("linked_portal_door")
	
	self.portals[1]:SetWidth(200)
	self.portals[1]:SetHeight(240)
	local portal1vec = self.entryportal:GetPos()
	portal1vec:Add(Vector(0,0,119))
	self.portals[1]:SetPos(portal1vec)
	self.portals[1]:SetAngles(self.entryportal:GetAngles())
	self.portals[1]:SetExit(self.portals[2])
	self.portals[1]:SetParent(self.entryportal)
	self.portals[1]:Spawn()
	self.portals[1]:Activate()
	
	self.portals[2]:SetWidth(200)
	self.portals[2]:SetHeight(240)
	local portal2vec = self.exitportal:GetPos()
	portal2vec:Add(Vector(0,0,119))
	self.portals[2]:SetPos(portal2vec)
	self.portals[2]:SetAngles(self.exitportal:GetAngles())
	self.portals[2]:SetExit(self.portals[1])
	self.portals[2]:SetParent(self.exitportal)
	self.portals[2]:Spawn()
	self.portals[2]:Activate()
	
	self.entryportal:SetUseType(SIMPLE_USE)
	
end
 
function ENT:Use( activator, caller )

	if(self.portals[1]:IsValid())then
		self.portals[1]:Remove()
		self.portals[2]:Remove()
		
	else
			
		local phys = self.entryportal:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Sleep()
		end
		local phys2 = self.exitportal:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Sleep()
		end
		
		self.portals[1]=ents.Create("linked_portal_door")
		self.portals[2]=ents.Create("linked_portal_door")
		
		self.portals[1]:SetWidth(200)
		self.portals[1]:SetHeight(240)
		local portal1vec = self.entryportal:GetPos()
		portal1vec:Add(Vector(0,0,119))
		local selfangle=self.entryportal:GetAngles()
		selfangle[1]=0
		selfangle[3]=0
		self.entryportal:SetAngles(selfangle)
		self.portals[1]:SetAngles(selfangle)
		self.portals[1]:SetPos(portal1vec)
		self.portals[1]:SetExit(self.portals[2])
		self.portals[1]:SetParent(self.entryportal)
		self.portals[1]:Spawn()
		self.portals[1]:Activate()
		
		self.portals[2]:SetWidth(200)
		self.portals[2]:SetHeight(240)
		local portal2vec = self.exitportal:GetPos()
		portal2vec:Add(Vector(0,0,119))
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
		
		self.entryportal:PhysWake()
		self.exitportal:PhysWake()

		
	end
end 



function ENT:Think()
    -- We don't need to think, we are just a prop after all!
end 

function ENT:OnRemove()
	self.entryportal:Remove()
	self.exitportal:Remove()
	self.portals[1]:Remove()
	self.portals[2]:Remove()
end