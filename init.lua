
--[[
				Underworld mod
				--------------
A merging of PilzAdam's Nether mod and Paramat's Subterrian mod, with
additions inspired by Calinou's Bedrock mod and Wuzzy's Bedrock2 mod.
by:blert2112

]]

-- Parameters
-------------------------------------------------------------------------------
local uw_ymin = -30500			-- Underworld realm lower limit
local uw_ymax = -20500			-- Underworld realm upper limit
local uw_mitigate_lava = 40		-- Chance to remove lava_source 0-100
local uw_cave_threshold = 0.6	-- Cave threshold: 1 = small rare caves, 0.5 = 1/3rd ground volume, 0 = 1/2 ground volume
local uw_cave_blend = 128		-- Cave blend distance near YMIN, YMAX

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--[[ Nodes ]]
-------------------------------------------------------------------------------
core.register_node("uw:stone", {
	description = "Underworld Stone",
	tiles = {"default_stone.png^[colorize:#8A070799"},
	groups = {underworld=1, stone=1, cracky=3, level=3},
	is_ground_content = true,
	sounds = default.node_sound_stone_defaults(),
	drop = {max_items = 1, items = {{rarity = 3, items = {"uw:stone"}}}}
})

core.register_node("uw:stone_brick", {
	description = "Underworld Stone Brick",
	tiles = {"default_stone_brick.png^[colorize:#8A070799"},
	groups = {underworld=1, stone=1, cracky=2, level=3},
	is_ground_content = true,
	sounds = default.node_sound_stone_defaults()
})

core.register_node("uw:sand", {
	description = "Underworld Sand",
	tiles = {"default_sand.png^[colorize:#8A070799"},
	groups = {underworld=1, sand=1, crumbly=3, level=3, falling_node=1},
	is_ground_content = true,
	sounds = default.node_sound_sand_defaults()
})

core.register_node("uw:glowstone", {
	description = "Underworld Glowstone",
	tiles = {"uw_glowstone.png"},
	groups = {underworld=1, stone=1, cracky=3, oddly_breakable_by_hand=3},
	is_ground_content = true,
	light_source = 13,
	sounds = default.node_sound_glass_defaults(),
	on_blast = function() end
})

core.register_node("uw:bedrock", {
	description = "Underworld Bedrock",
	tiles = {"bedrock_bedrock.png^[colorize:#8A070799"},
	groups = {underworld=1, stone=1, immortal=1, not_in_creative_inventory=0},
	sounds = {footstep = {name = "uw_bedrock_step", gain = 1}},
	is_ground_content = false,
	on_blast = function() end,
	on_destruct = function() end,
	can_dig = function() return false end,
	diggable = false,
	drop = ""
})

core.register_node("uw:deepstone", {
	description = "Underworld Deepstone",
	tiles = {"bedrock_deepstone.png^[colorize:#8A070799"},
	groups = {underworld=1, stone=1, cracky=3, level=4},
	sounds = {footstep = {name = "uw_bedrock_step", gain = 1}},
	is_ground_content = false,
	on_blast = function() end
})

stairs.register_stair_and_slab("uw_stone_brick", "uw:stone_brick",
		{underworld=1, stone=1, cracky=2, level=3},
		{"default_stone_brick.png^[colorize:#8A070799"},
		"Underworld Stone Brick Stair",
		"Underworld Stone Brick Slab",
		default.node_sound_stone_defaults()
)

if core.get_modpath("lib_xconnected") then
	lib_xconnected.register("uw:fence_uw_stone", "fence", {
		description = "Underworld Stone",
		texture = "default_stone.png^[colorize:#8A070799",
		groups = {underworld=1, stone=1, cracky=3, level=3, oddly_breakable_by_hand=2, flammable=3},
		material = "uw:stone"
	})
	lib_xconnected.register("uw:wall_uw_stone", "wall", {
		description = "Underworld Stone",
		texture = "default_stone.png^[colorize:#8A070799",
		groups = {underworld=1, stone=1, cracky=3, level=3, flammable=3},
		material = "uw:stone"
	})
else
	local fence_texture = "default_fence_overlay.png^(default_stone.png^[colorize:#8A070799)^default_fence_overlay.png^[makealpha:255,126,126"
	core.register_node("uw:fence_uw", {
		description = "Underworld Stone Fence",
		drawtype = "fencelike",
		tiles = {"default_stone.png^[colorize:#8A070799"},
		inventory_image = fence_texture,
		wield_image = fence_texture,
		paramtype = "light",
		sunlight_propagates = true,
		is_ground_content = false,
		selection_box = {
			type = "fixed",
			fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
		},
		groups = {underworld=1, stone=1, cracky=3, level=2, oddly_breakable_by_hand = 3},
		sounds = default.node_sound_stone_defaults()
	})
end

core.register_node("uw:portal", {
	description = "Underworld Portal",
	tiles = {
		"uw_transparent.png",
		"uw_transparent.png",
		"uw_transparent.png",
		"uw_transparent.png",
		{
			name = "uw_portal.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.5
			}
		},
		{
			name = "uw_portal.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.5
			}
		}
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = false,
	digable = false,
	pointable = false,
	buildable_to = false,
	drop = "",
	light_source = 5,
	post_effect_color = {a=180, r=128, g=0, b=128},
	alpha = 192,
	node_box = {
		type = "fixed",
		fixed = {{-0.5, -0.5, -0.1,  0.5, 0.5, 0.1}}
	},
	groups = {underworld=1, not_in_creative_inventory=1}
})

core.register_node(":default:obsidian", {
	description = "Obsidian",
	tiles = {"default_obsidian.png"},
	is_ground_content = true,
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky=1,level=2},
	on_destruct = function(pos)
		local meta = core.get_meta(pos)
		local p1 = core.string_to_pos(meta:get_string("p1"))
		local p2 = core.string_to_pos(meta:get_string("p2"))
		local target = core.string_to_pos(meta:get_string("target"))
		if not p1 or not p2 then
			return
		end
		for x=p1.x,p2.x do
			for y=p1.y,p2.y do
				for z=p1.z,p2.z do
					local nn = core.get_node({x=x,y=y,z=z}).name
					if nn == "default:obsidian" or nn == "uw:portal" then
						if nn == "uw:portal" then
							core.remove_node({x=x,y=y,z=z})
						end
						local m = core.get_meta({x=x,y=y,z=z})
						m:set_string("p1", "")
						m:set_string("p2", "")
						m:set_string("target", "")
					end
				end
			end
		end
		meta = core.get_meta(target)
		if not meta then
			return
		end
		p1 = core.string_to_pos(meta:get_string("p1"))
		p2 = core.string_to_pos(meta:get_string("p2"))
		if not p1 or not p2 then
			return
		end
		for x=p1.x,p2.x do
			for y=p1.y,p2.y do
				for z=p1.z,p2.z do
					local nn = core.get_node({x=x,y=y,z=z}).name
					if nn == "default:obsidian" or nn == "uw:portal" then
						if nn == "uw:portal" then
							core.remove_node({x=x,y=y,z=z})
						end
						local m = core.get_meta({x=x,y=y,z=z})
						m:set_string("p1", "")
						m:set_string("p2", "")
						m:set_string("target", "")
					end
				end
			end
		end
	end
})

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--[[ Portal ]]
-------------------------------------------------------------------------------

local function build_portal(pos, target)
	local p = {x=pos.x-1, y=pos.y-1, z=pos.z}
	local p1 = {x=pos.x-1, y=pos.y-1, z=pos.z}
	local p2 = {x=p1.x+3, y=p1.y+4, z=p1.z}
	for i=1,4 do
		core.set_node(p, {name="default:obsidian"})
		p.y = p.y+1
	end
	for i=1,3 do
		core.set_node(p, {name="default:obsidian"})
		p.x = p.x+1
	end
	for i=1,4 do
		core.set_node(p, {name="default:obsidian"})
		p.y = p.y-1
	end
	for i=1,3 do
		core.set_node(p, {name="default:obsidian"})
		p.x = p.x-1
	end
	for x=p1.x,p2.x do
		for y=p1.y,p2.y do
			p = {x=x, y=y, z=p1.z}
			if not (x == p1.x or x == p2.x or y==p1.y or y==p2.y) then
				core.set_node(p, {name="uw:portal", param2=0})
			end
			local meta = core.get_meta(p)
			meta:set_string("p1", core.pos_to_string(p1))
			meta:set_string("p2", core.pos_to_string(p2))
			meta:set_string("target", core.pos_to_string(target))
			if y ~= p1.y then
				for z=-4,4 do
					if z ~= 0 then
						p.z = p.z+z
						if core.registered_nodes[core.get_node(p).name].is_ground_content then
							core.remove_node(p)
						end
						p.z = p.z-z
					end
				end
			end
		end
	end
end

core.register_abm({
	nodenames = {"uw:portal"},
	interval = 1,
	chance = 2,
	action = function(pos, node)
		core.add_particlespawner(
			32, --amount
			4, --time
			{x=pos.x-0.25, y=pos.y-0.25, z=pos.z-0.25}, --minpos
			{x=pos.x+0.25, y=pos.y+0.25, z=pos.z+0.25}, --maxpos
			{x=-0.8, y=-0.8, z=-0.8}, --minvel
			{x=0.8, y=0.8, z=0.8}, --maxvel
			{x=0,y=0,z=0}, --minacc
			{x=0,y=0,z=0}, --maxacc
			0.5, --minexptime
			1, --maxexptime
			1, --minsize
			2, --maxsize
			false, --collisiondetection
			"uw_particle.png" --texture
		)
		for _,obj in ipairs(core.get_objects_inside_radius(pos, 1)) do
			if obj:is_player() then
				local meta = core.get_meta(pos)
				local target = core.string_to_pos(meta:get_string("target"))
				if target then
					core.after(3, function(obj, pos, target)
						local objpos = obj:getpos()
						objpos.y = objpos.y+0.1 -- Fix some glitches at -8000
						if core.get_node(objpos).name ~= "uw:portal" then
							return
						end
						obj:setpos(target)
						local function check_and_build_portal(pos, target)
							local n = core.get_node_or_nil(target)
							if n and n.name ~= "uw:portal" then
								build_portal(target, pos)
							elseif not n then
								core.after(1, check_and_build_portal, pos, target)
							end
						end
						core.after(1, check_and_build_portal, pos, target)
					end, obj, pos, target)
				end
			end
		end
	end
})

local function move_check(p1, max, dir)
	local p = {x=p1.x, y=p1.y, z=p1.z}
	local d = math.abs(max-p1[dir]) / (max-p1[dir])
	while p[dir] ~= max do
		p[dir] = p[dir] + d
		if core.get_node(p).name ~= "default:obsidian" then
			return false
		end
	end
	return true
end

local function check_portal(p1, p2)
	if p1.x ~= p2.x then
		if not move_check(p1, p2.x, "x") then
			return false
		end
		if not move_check(p2, p1.x, "x") then
			return false
		end
	elseif p1.z ~= p2.z then
		if not move_check(p1, p2.z, "z") then
			return false
		end
		if not move_check(p2, p1.z, "z") then
			return false
		end
	else
		return false
	end
	if not move_check(p1, p2.y, "y") then
		return false
	end
	if not move_check(p2, p1.y, "y") then
		return false
	end
	return true
end

local function is_portal(pos)
	for d=-3,3 do
		for y=-4,4 do
			local px = {x=pos.x+d, y=pos.y+y, z=pos.z}
			local pz = {x=pos.x, y=pos.y+y, z=pos.z+d}
			if check_portal(px, {x=px.x+3, y=px.y+4, z=px.z}) then
				return px, {x=px.x+3, y=px.y+4, z=px.z}
			end
			if check_portal(pz, {x=pz.x, y=pz.y+4, z=pz.z+3}) then
				return pz, {x=pz.x, y=pz.y+4, z=pz.z+3}
			end
		end
	end
end

local function make_portal(pos)
	local p1, p2 = is_portal(pos)
	if not p1 or not p2 then
		return false
	end
	for d=1,2 do
		for y=p1.y+1,p2.y-1 do
			local p
			if p1.z == p2.z then
				p = {x=p1.x+d, y=y, z=p1.z}
			else
				p = {x=p1.x, y=y, z=p1.z+d}
			end
			if core.get_node(p).name ~= "air" then
				return false
			end
		end
	end
	local param2
	if p1.z == p2.z then param2 = 0 else param2 = 1 end
	local target = {x=p1.x, y=p1.y, z=p1.z}
	target.x = target.x + 1
	if target.y > uw_ymax-50 or target.y < uw_ymin+50 then
		target.y = math.random(uw_ymin - 50, uw_ymax + 50)
	end
	for d=0,3 do
		for y=p1.y,p2.y do
			local p = {}
			if param2 == 0 then p = {x=p1.x+d, y=y, z=p1.z} else p = {x=p1.x, y=y, z=p1.z+d} end
			if core.get_node(p).name == "air" then
				core.set_node(p, {name="uw:portal", param2=param2})
			end
			local meta = core.get_meta(p)
			meta:set_string("p1", core.pos_to_string(p1))
			meta:set_string("p2", core.pos_to_string(p2))
			meta:set_string("target", core.pos_to_string(target))
		end
	end
	return true
end

core.register_craftitem(":default:mese_crystal_fragment", {
	description = "Mese Crystal Fragment",
	inventory_image = "default_mese_crystal_fragment.png",
	on_place = function(stack,_, pt)
		if pt.under and core.get_node(pt.under).name == "default:obsidian" then
			local done = make_portal(pt.under)
			if done and not core.setting_getbool("creative_mode") then
				stack:take_item()
			end
		end
		return stack
	end
})

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--[[ MapGen ]]
-------------------------------------------------------------------------------
-- Content IDs
local c_air = core.get_content_id("air")
local c_stone_with_gold = core.get_content_id("default:stone_with_gold")
local c_stone_with_mese = core.get_content_id("default:stone_with_mese")
local c_gravel = core.get_content_id("default:gravel")
local c_dirt = core.get_content_id("default:dirt")
local c_sand = core.get_content_id("default:sand")
local c_cobble = core.get_content_id("default:cobble")
local c_mossycobble = core.get_content_id("default:mossycobble")
local c_stair_cobble = core.get_content_id("stairs:stair_cobble")
local c_slab_cobble = core.get_content_id("stairs:slab_cobble")
local c_lava_source = core.get_content_id("default:lava_source")
local c_lava_flowing = core.get_content_id("default:lava_flowing")
local c_glowstone = core.get_content_id("uw:glowstone")
local c_uw_sand = core.get_content_id("uw:sand")
local c_uw_stone = core.get_content_id("uw:stone")
local c_uw_stone_brick = core.get_content_id("uw:stone_brick")
local c_stair_uw_stone_brick = core.get_content_id("stairs:stair_uw_stone_brick")
local c_slab_uw_stone_brick = core.get_content_id("stairs:slab_uw_stone_brick")
local c_uw_bedrock = core.get_content_id("uw:bedrock")
local c_uw_deepstone = core.get_content_id("uw:deepstone")

-- 3D noise for caves
local np_cave = {
	offset = 0,
	scale = 1,
	spread = {x = 768, y = 256, z = 768}, -- squashed 3:1
	seed = 59033,
	octaves = 6,
	persist = 0.63
}

-- Stuff
local yblmin = (uw_ymin+10) + uw_cave_blend * 1.5
local yblmax = (uw_ymax-10) - uw_cave_blend * 1.5
if uw_mitigate_lava < 0 then uw_mitigate_lava = 0
	elseif uw_mitigate_lava > 100 then uw_mitigate_lava = 100 end

-- Initialize noise objects to nil
local nobj_cave = nil

core.register_on_generated(function(minp, maxp, seed)
	if minp.y > uw_ymax or maxp.y < uw_ymin then
		return
	end
	local t1 = os.clock()
	local vm, emin, emax = core.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge = emin, MaxEdge = emax}
	local data = vm:get_data()
	local sidelen = maxp.x - minp.x + 1
	local chulens = {x = sidelen, y = sidelen, z = sidelen}
	nobj_cave = nobj_cave or minetest.get_perlin_map(np_cave, chulens)
	local nvals_cave = nobj_cave:get3dMap_flat(minp)
	local nixyz = 1
	for z = minp.z, maxp.z do
		for y = minp.y, maxp.y do
			local vi = area:index(minp.x, y, z)
			if y >= uw_ymin + 7 and y <= uw_ymax - 7 then										-- modify between bedrock layers
				local tcave
				if y < yblmin then
					tcave = uw_cave_threshold + ((yblmin - y) / uw_cave_blend) ^ 2
				elseif y > yblmax then
					tcave = uw_cave_threshold + ((y - yblmax) / uw_cave_blend) ^ 2
				else
					tcave = uw_cave_threshold
				end
				for x = minp.x, maxp.x do
					-- Netherize
					if data[vi] == c_air or data[vi] == c_uw_bedrock or data[vi] == c_uw_deepstone then
						-- do nothing
					elseif data[vi] == c_lava_source then
						if math.random(100) < uw_mitigate_lava then data[vi] = c_air end
					elseif data[vi] == c_stone_with_gold or data[vi] == c_stone_with_mese then
						data[vi] = c_glowstone
					elseif data[vi] == c_gravel or data[vi] == c_dirt or data[vi] == c_sand then
						data[vi] = c_uw_sand
					elseif data[vi] == c_cobble or data[vi] == c_mossycobble then
						data[vi] = c_uw_stone_brick
					elseif data[vi] == c_stair_cobble then
						data[vi] = c_stair_uw_stone_brick
					elseif data[vi] == c_slab_cobble then
						data[vi] = c_slab_uw_stone_brick
					else
						data[vi] = c_uw_stone
					end
					-- Cavify
					if nvals_cave[nixyz] > tcave then
						data[vi] = c_air
					end
					nixyz = nixyz + 1
					
					vi = vi + 1
				end
			elseif y == uw_ymin or y == uw_ymax then											--scattered bedrock/natural 66/34
				for x = minp.x, maxp.x do
					if math.random(3) <= 2 then
						data[vi] = c_uw_bedrock
					end
					vi = vi + 1
				end
			elseif y == uw_ymin+1 or y == uw_ymax-1 or y == uw_ymin+2 or y == uw_ymax-2 then	--solid bedrock
				for x = minp.x, maxp.x do
					data[vi] = c_uw_bedrock
					vi = vi + 1
				end
			elseif y == uw_ymin+3 or y == uw_ymax-3 then										--blend bedrock/deepstone 50/50
				for x = minp.x, maxp.x do
					if math.random(2) == 1 then
						data[vi] = c_uw_bedrock
					else
						data[vi] = c_uw_deepstone
					end
					vi = vi + 1
				end
			elseif y == uw_ymin+4 or y == uw_ymax-4 or y == uw_ymin+5 or y == uw_ymax-5 then	--solid deepstone
				for x = minp.x, maxp.x do
					data[vi] = c_uw_deepstone
					vi = vi + 1
				end
			elseif y == uw_ymin+6 or y == uw_ymax-6 then										--scattered deepstone/uw 66/34
				for x = minp.x, maxp.x do
					if math.random(3) <= 2 then
						data[vi] = c_uw_deepstone
					else
						data[vi] = c_uw_stone
					end
					vi = vi + 1
				end
			end
		end
	end
	vm:set_data(data)
	vm:set_lighting({day = 0, night = 0})
	vm:calc_lighting()
	vm:update_liquids()
	vm:write_to_map(data)
	local chugent = math.ceil((os.clock() - t1) * 1000)
	print ("[underworld] " .. chugent .. " ms")
end)

-------------------------------------------------------------------------------
-- eof