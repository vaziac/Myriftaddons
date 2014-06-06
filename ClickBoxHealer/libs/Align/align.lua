--[[
* Align is an addon for RIFT that produces a grid overlay, enabling better alignment of UI objects.
* Copyright © 2011 Jordan White
*
* This program is free software: you can redistribute it and/or modify it
* under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or (at your option)
* any later version.
* 
* This program is distributed in the hope that it will be useful, but WITHOUT ANY
* WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
* PURPOSE. See the GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License along with this program.
* If not, see <http://www.gnu.org/licenses/>. ]]--

-- Inspired by the Align addon for World of Warcraft by Akeru at <http://www.wowinterface.com/downloads/info6153-Align.html>.


--[[
	NOTES:
		TODO : Delete the damn frames instead of consuming memory in the frame queue.
		TODO : Find a more efficient way of displying the grid, perhaps via texture.
]]--

local context
local frame

local linesActive = { }
local linesQueued = { }

local function Reallocate( )
	for _, v in pairs( linesActive ) do
		table.insert( linesQueued, v )
		v:SetVisible( false )
	end

	linesActive = { }
end

local lastSize = 0
local isDrawn = false
local function Draw( gridSize )
	if isDrawn then Reallocate( ) end

	local lineSize = 1 -- Feel free to change this.
	local blockSize = frame:GetWidth( ) / gridSize

	for i = 1, gridSize do
		local f = ( ( next( linesQueued ) == nil ) and UI.CreateFrame( "Frame", "", frame ) ) or table.remove( linesQueued )
		f:SetBackgroundColor( ( ( i == ( gridSize / 2 ) ) and 1 ) or 0, 0, 0, 0.5 )
		f:SetWidth( lineSize )
		f:SetHeight( frame:GetHeight( ) )

		f:SetPoint( "CENTER", frame, "CENTERLEFT", ( i * blockSize ) - ( lineSize / 2 ), 0 )
		f:SetVisible( true )

		table.insert( linesActive, f )
	end

	do -- Create the middle horizontal line first because we aren't going to perfectly divide our grid size into the height.
		local f = ( ( next( linesQueued ) == nil ) and UI.CreateFrame( "Frame", "", frame ) ) or table.remove( linesQueued )
		f:SetBackgroundColor( 1, 0, 0, 0.5 )
		f:SetWidth( frame:GetWidth( ) )
		f:SetHeight( lineSize )

		f:SetPoint( "CENTER", frame, "CENTER", 0, lineSize / 2 )
		f:SetVisible( true )

		table.insert( linesActive, f )
	end

	local halfHeight = frame:GetHeight( ) / 2 -- Because we are starting from the middle (↑) and working outwards.
	for i = 1, math.floor( ( frame:GetHeight( ) / 2 ) / blockSize ) do
		local f = ( ( next( linesQueued ) == nil ) and UI.CreateFrame( "Frame", "", frame ) ) or table.remove( linesQueued )
		f:SetBackgroundColor( 0, 0, 0, 0.5 )
		f:SetWidth( frame:GetWidth( ) )
		f:SetHeight( lineSize )

		f:SetPoint( "CENTER", frame, "CENTER", 0, -( i * blockSize ) + ( lineSize / 2 ) )
		f:SetVisible( true )

		table.insert( linesActive, f )
		----- ↑ Above the middle line. ↑ ------ ↓ Below the middle line. ↓ --------------------------------------------
		f = ( ( next( linesQueued ) == nil ) and UI.CreateFrame( "Frame", "", frame ) ) or table.remove ( linesQueued )
		f:SetBackgroundColor( 0, 0, 0, 0.5 )
		f:SetWidth( frame:GetWidth ( ) )
		f:SetHeight( lineSize )

		f:SetPoint( "CENTER", frame, "CENTER", 0, ( i * blockSize ) + ( lineSize / 2 ) )
		f:SetVisible( true )

		table.insert( linesActive, f )
	end

	lastSize = gridSize
	if not isDrawn then isDrawn = true end
end

local function Config( parameters )
	local gridSize = tonumber( parameters:match( "(%d+)" ) )

	if not context then -- Instantiate the grid since this is our first time.
		context = UI.CreateContext( "" )
		frame = UI.CreateFrame( "Frame", "", context )
		frame:SetAllPoints( UIParent )
	end

	if gridSize and ( gridSize > 0 ) then
		gridSize = ( math.ceil( ( gridSize or 32 ) / 32 ) * 32 )
		if gridSize > 384 then gridSize = 384 end

		if not ( isDrawn and ( gridSize == lastSize ) ) then Draw( gridSize ) end

		frame:SetVisible( true )
		return
	end

	if ( not gridSize ) or ( gridSize <= 0 ) then
		if isDrawn and lastSize and not frame:GetVisible( ) then frame:SetVisible( true )
		elseif frame:GetVisible( ) then frame:SetVisible( false )
		else print( "Example: /align 128" ) end
	end
end

table.insert( Command.Slash.Register( "align" ), { Config, "Align", "alignConfig" } )