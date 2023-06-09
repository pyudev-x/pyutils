local can_say_run_time = false
local alert_node_events = false
local alert_crafts = false
local timer = 0
local commands = {";help", ";toggle_runtime", ";toggle_alert_node_events", ";toggle_alert_crafts", ";cmd"}

-- Player events

minetest.register_on_joinplayer(function(ObjectRef, last_login)
    minetest.chat_send_player(ObjectRef:get_player_name(), "Welcome to Pyutils! Type ;help in the chat for a list of commands.")
end)

minetest.register_on_leaveplayer(function(ObjectRef, timed_out)
    minetest.chat_send_all("Everyone say bye to: " .. ObjectRef:get_player_name() .. ", Goodbye!")
end)

minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
    if alert_crafts then
        minetest.chat_send_all(itemstack:get_name() .. " was crafted by: " .. player:get_player_name() .. "! They crafted " .. itemstack:get_count() .. " " .. itemstack:get_name() .. "!")
    end
end)


-- Node events

minetest.register_on_dignode(function(pos, oldnode, digger)
    if alert_node_events then
        minetest.chat_send_all("A node was destroyed at: " .. tostring(pos) .. "!")
    end
end)

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    if alert_node_events then
        minetest.chat_send_all("A node was placed at: " .. tostring(pos) .. "!")
    end
end)

-- Runtime Code

minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    if can_say_run_time then
        minetest.chat_send_all("Server running for " .. timer .. " seconds!")
    end
    
end)

-- Commands

minetest.register_on_chat_message(function(name, message)
    local cmd = string.split(message, " ")
    
    if message == ";help" then
        minetest.chat_send_player(name, "The Prefix: ';' The Commands: ")

        for _k, v in pairs(commands) do
            minetest.chat_send_player(name, v)
        end
    end
    
    if message == ";toggle_runtime" then
        if can_say_run_time then
            can_say_run_time = false
        else
            can_say_run_time = true
        end
    end

    if message == ";toggle_alert_node_events" then
        if alert_node_events then
            alert_node_events = false
            minetest.chat_send_player(name, "Node events will no longer be sent in the chat.")
        else
            alert_node_events = true
            minetest.chat_send_player(name, "Node events will now be sent in the chat.")
        end
    end

    if message == ";toggle_alert_crafts" then
        if alert_crafts then
            alert_crafts = false
            minetest.chat_send_player(name, "Craft events will no longer be sent in the chat.")
        else
            alert_crafts = true
            minetest.chat_send_player(name, "Craft events will now be sent in the chat.")
        end
    end

    if message == ";cmd" then
        minetest.chat_send_player(name, "Hello, world!")
    end

end)

