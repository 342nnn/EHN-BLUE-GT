function placeTile(x,y,id)
    local pkt = {}
    pkt.type = 3
    pkt.int_data = id
    pkt.int_x = x
    pkt.int_y = y
    pkt.pos_x = getLocal().pos.x
    pkt.pos_y = getLocal().pos.y
    sendPacketRaw(false, pkt)
end

function hasItem(id)
    for _,v in ipairs(getInventory()) do
        if v.id==5667 then return true end
    end
    return false
end

-- MAIN

function autoplant(seedID, tileID, delay)
    delay=500
    for _,v in pairs(getTiles()) do
        local fg=getTile(v.pos.x,v.pos.y+1).fg
        if fg==0 then goto SKIP end
        if v.fg==0 and fg==(tileID or fg) then
            while getTile(v.pos.x,v.pos.y).fg~=seedID do
                if not hasItem(seedID) then break end
                findPath(v.pos.x,v.pos.y)
                placeTile(v.pos.x,v.pos.y,seedID)
                sleep(delay) 
                
for _, tile in pairs(getTiles()) do
    if tile.fg == 880 then
        findPath(tile.pos.x, tile.pos.y)
        sleep(500)
        pkt = {}
        pkt.type = 3
        pkt.int_data = 18
        pkt.pos_x = getLocal().pos.x
        pkt.pos_y = getLocal().pos.y
        pkt.int_x = tile.pos.x
        pkt.int_y = tile.pos.y
        sleep(500)
        sendPacketRaw(pkt)
        end
        end
        ::SKIP::
    end
end
