--[[
==========================================================
SCRIPT MODDED BY VOBING#9817

Default Is For Grass

Delay List:
-32000 For SSW
-157000 For Wheat (MAYBE)
-80000 For Grass
-184000 For Plat maybe
==========================================================
--]]
      platid = 102 --PlatId
      seedid = 17 --SeedId
      blockid = 16 --BlockId
      interval = 80000 --Delay

--EveryPlat Must Diff If You Want do With A lot Bot

function findItem(id)
    for _, itm in pairs(getInventory()) do
        if itm.id == id then
            return itm.count
        end
    end
    return 0
end

function hit_tile(x, y)
    pkt = {}
    pkt.type = 3
    pkt.int_data = 18
    pkt.int_x = x
    pkt.int_y = y
    pkt.pos_x = getLocal().pos.x
    pkt.pos_y = getLocal().pos.y
    sendPacketRaw(pkt)
end

function place_tile(x, y, id)
    pkt = {}
    pkt.type = 3
    pkt.int_data = id
    pkt.int_x = x
    pkt.int_y = y
    pkt.pos_x = getLocal().pos.x
    pkt.pos_y = getLocal().pos.y
    sendPacketRaw(pkt)
end

function wrench_tile(x, y)
    pkt = {}
    pkt.type = 3
    pkt.int_data = 32
    pkt.int_x = x
    pkt.int_y = y
    pkt.pos_x = getLocal().pos.x
    pkt.pos_y = getLocal().pos.y
    sendPacketRaw(pkt)
end

function findEmptyPlat()
    for _, tile in pairs(getTiles()) do
        if tile.fg == platid then
            if getTile(tile.pos.x, tile.pos.y - 1).fg == 0 then
                findPath(tile.pos.x, tile.pos.y - 1)
                sleep(100)
                place_tile(tile.pos.x, tile.pos.y - 1, seedid)
                sleep(200)
                return true
            end
        end
    end
    return false
end

function findGrassPlat()
    for _, tile in pairs(getTiles()) do
        if tile.fg == platid then
            if getTile(tile.pos.x, tile.pos.y - 1).fg == seedid then
                findPath(tile.pos.x, tile.pos.y - 1)
                sleep(100)
                hit_tile(tile.pos.x, tile.pos.y - 1)
                sleep(200)

                return true
            end
        end
    end
    return false
end

function break_tile(x, y)
    id = getTile(x, y)
    if id ~= 0 then
        hit_tile(x, y)
        sleep(70)
        id = getTile(x, y)
        sleep(70)
    end
end

mode = 0

farming = true
harvesting = false
planting = false

startx = 0
starty = 0

function hook(packet, type)
    if packet:find("action|input") and packet:find("stop") then
        farming = false
 sendPacket("action|input\n|text|Farming stopped, wait until loop is done.", 2)
    end
end

function hook2(vlist)
    if vlist[0]:find("OnDialogRequest") and vlist[1]:find("end_dialog|vending") then
        sendPacket("action|dialog_return\ndialog_name|vending\ntilex|"..tostring(startx).."|\ntiley|"..tostring(starty).."|\nbuttonClicked|addstock", 2)
        return true
    end
end

function farmgrass()
    sendPacket("action|input\n|text|Farming Started.", 2)
    startx = getLocal().pos.x / 32
    starty = getLocal().pos.y / 32
    while farming do
        findPath(startx, starty)
        sleep(30)
        if findItem(blockid) >= 10 then
            if findItem(seedid) < 100 then
                place_tile(startx - 1, starty, blockid)
                sleep(200)
                break_tile(startx - 1, starty)

            else
                planting = true
                while planting do
                    planting = findEmptyPlat()
                    if findItem(seedid) <= 10 then
                        planting = false
                    end
                end
                findPath(startx, starty)
                sleep(300)
                wrench_tile(startx, starty)
                sleep(interval)
            end
        else
            harvesting = true
            while harvesting do
                harvesting = findGrassPlat()
                if findItem(blockid) >= 180 then
                    harvesting = false
                end
            end
            if findItem(blockid) < 10 then
                planting = true
                while planting do
                    planting = findEmptyPlat()
                    if findItem(seedid) <= 10 then
                        planting = false
                    end
                end
                sleep(interval)
            end
        end
    end
   sendPacket("action|input\n|text|Farming stopped.", 2)
end

farmgrass()

addHook(1, "stophook", hook)
addHook(5, "vendhook", hook2)



