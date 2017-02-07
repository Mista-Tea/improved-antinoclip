--local prefix = "#tool."..debug.getinfo( 1, "S" ).source:match(".+[/?\\?](.+)%.lua").."."

local prefix = "#tool.antinoclip_improved."

localify.Bind( "en", prefix.."language_en", "English" )

--[[--------------------------------------------------------------------------
-- English Localization
--------------------------------------------------------------------------]]--

-- Tool Settings
localify.Bind( "en", prefix.."name",                     "Anti-NoClip - Improved" )
localify.Bind( "en", prefix.."desc",                     "Prevents players from noclipping through props" )
localify.Bind( "en", prefix.."left",                     "Apply Protection" )
localify.Bind( "en", prefix.."right",                    "Copy Protection" )
localify.Bind( "en", prefix.."reload",                   "Remove Protection" )
-- Errors

-- Labels
localify.Bind( "en", prefix.."label_language",           "Language: " )
localify.Bind( "en", prefix.."label_credits",            "" )
localify.Bind( "en", prefix.."label_affects",            "Apply effect(s) to: " )
localify.Bind( "en", prefix.."label_effects",            "Effects" )
localify.Bind( "en", prefix.."label_tooltip_scale",      "Tooltip Scale: " )
localify.Bind( "en", prefix.."label_halo_color",         "Halo color: " )
-- Checkboxes
localify.Bind( "en", prefix.."checkbox_bounce",          "Bounce" )
localify.Bind( "en", prefix.."checkbox_ignite",          "Ignite" )
localify.Bind( "en", prefix.."checkbox_kill",            "Kill" )
localify.Bind( "en", prefix.."checkbox_respawn",         "Respawn" )
localify.Bind( "en", prefix.."checkbox_stripweapons",    "Strip Weapons" )
localify.Bind( "en", prefix.."checkbox_teleport",        "Teleport" )
localify.Bind( "en", prefix.."checkbox_walk",            "Walk" )
localify.Bind( "en", prefix.."checkbox_tooltip_show",    "Always show tooltip" )
localify.Bind( "en", prefix.."checkbox_notifs",          "Display notifications" )
localify.Bind( "en", prefix.."checkbox_notifs_sound",    "Play notification sounds" )
localify.Bind( "en", prefix.."checkbox_halo",            "Add halos to ghosted props" )
-- Comboboxes
localify.Bind( "en", prefix.."combobox_default",         "Default" )
localify.Bind( "en", prefix.."combobox_affect_self",     "Affect only yourself" )
localify.Bind( "en", prefix.."combobox_affect_team",     "Affect only team" )
localify.Bind( "en", prefix.."combobox_affect_buddies",  "Affect only prop buddies" )
localify.Bind( "en", prefix.."combobox_affect_everyone", "Affect everyone" )
localify.Bind( "en", prefix.."combobox_ignore_self",     "Ignore only yourself" )
localify.Bind( "en", prefix.."combobox_ignore_admins",   "Ignore only admins" )
localify.Bind( "en", prefix.."combobox_ignore_team",     "Ignore only team" )
localify.Bind( "en", prefix.."combobox_ignore_buddies",  "Ignore only prop buddies" )
-- Descriptions
localify.Bind( "en", prefix.."help_tooltip_show",        "Shows the tooltip even when the anti-noclip tool is not being used." )
localify.Bind( "en", prefix.."help_tooltip_scale",       "Sets the size of the tooltip when drawing the HUD." )
localify.Bind( "en", prefix.."help_notifs",              "Enables helpful notifications when applying, copying, or removing an entity's noclip protection." )
localify.Bind( "en", prefix.."help_notifs_sound",        "Enables notification sounds when applying noclip protection to an entity." )
-- HUD Text

-- Notifications
localify.Bind( "en", prefix.."notif_applied",            "Applied Anti-NoClip" )
localify.Bind( "en", prefix.."notif_copied",             "Copied Anti-NoClip settings" )
localify.Bind( "en", prefix.."notif_removed",            "Removed Anti-NoClip" )
localify.Bind( "en", prefix.."notif_blocked",            "The server has blocked you from performing this action" )
localify.Bind( "en", prefix.."notif_no_handler",         "This entity does not have anti noclip protection" )

localify.Bind( "bg", prefix.."language_bg", "Български" )

--[[--------------------------------------------------------------------------
-- English Localization
--------------------------------------------------------------------------]]--

-- Tool Settings
localify.Bind( "bg", prefix.."name",                     "Анти-NoClip - Improved" )
localify.Bind( "bg", prefix.."desc",                     "Забранява на играчите да преминават през обекти" )
localify.Bind( "bg", prefix.."left",                     "Приложи Защита" )
localify.Bind( "bg", prefix.."right",                    "Копирай защита" )
localify.Bind( "bg", prefix.."reload",                   "Премахни защита" )
-- Errors

-- Labels
localify.Bind( "bg", prefix.."label_language",           "Език: " )
localify.Bind( "bg", prefix.."label_credits",            "[BA][Sk$Bh]Trick or treat KID!" )
localify.Bind( "bg", prefix.."label_affects",            "Приложи ефект(и) върху: " )
localify.Bind( "bg", prefix.."label_effects",            "Ефекти" )
localify.Bind( "bg", prefix.."label_tooltip_scale",      "Размер подсказка: " )
localify.Bind( "bg", prefix.."label_halo_color",         "Размер подсветка: " )
-- Checkboxes
localify.Bind( "bg", prefix.."checkbox_bounce",          "Отскачане" )
localify.Bind( "bg", prefix.."checkbox_ignite",          "Запалване" )
localify.Bind( "bg", prefix.."checkbox_kill",            "Убиване" )
localify.Bind( "bg", prefix.."checkbox_respawn",         "Прераждане" )
localify.Bind( "bg", prefix.."checkbox_stripweapons",    "Обезоръжаване" )
localify.Bind( "bg", prefix.."checkbox_teleport",        "Телепортиране" )
localify.Bind( "bg", prefix.."checkbox_walk",            "Ходене" )
localify.Bind( "bg", prefix.."checkbox_tooltip_show",    "Винаги показвай подсказка" )
localify.Bind( "bg", prefix.."checkbox_notifs",          "Показвай уведомления" )
localify.Bind( "bg", prefix.."checkbox_notifs_sound",    "Свири уведомителни звуци" )
localify.Bind( "bg", prefix.."checkbox_halo",            "Добави подсветки към обектите сянка" )
-- Comboboxes
localify.Bind( "bg", prefix.."combobox_default",         "По подразбиране" )
localify.Bind( "bg", prefix.."combobox_affect_self",     "Да влияе само на теб" )
localify.Bind( "bg", prefix.."combobox_affect_team",     "Да влияе на определен отбор" )
localify.Bind( "bg", prefix.."combobox_affect_buddies",  "Да влияе само на приятели по строене" )
localify.Bind( "bg", prefix.."combobox_affect_everyone", "Да влияе на всеки" )
localify.Bind( "bg", prefix.."combobox_ignore_self",     "Пренебрегни само себе си" )
localify.Bind( "bg", prefix.."combobox_ignore_admins",   "Пренебрегни само администратори" )
localify.Bind( "bg", prefix.."combobox_ignore_team",     "Пренебрегни само зададен отбор" )
localify.Bind( "bg", prefix.."combobox_ignore_buddies",  "Пренебрегни само приятели по строене" )
-- Descriptions
localify.Bind( "bg", prefix.."help_tooltip_show",        "Показва подсказката когато анти-noclip инструмента не се използва." )
localify.Bind( "bg", prefix.."help_tooltip_scale",       "Задава размера на подсказката когато се чертае HUD." )
localify.Bind( "bg", prefix.."help_notifs",              "Разрешава помощни уведомления при прилагане, копиране, или премахване на noclip защитата." )
localify.Bind( "bg", prefix.."help_notifs_sound",        "Разрешава уведомителни звуци при прилагане на noclip защитата на обект." )
-- HUD Text

-- Notifications
localify.Bind( "bg", prefix.."notif_applied",            "Приложен Анти-NoClip" )
localify.Bind( "bg", prefix.."notif_copied",             "Копирани Анти-NoClip настройки" )
localify.Bind( "bg", prefix.."notif_removed",            "Премахнат Анти-NoClip" )
localify.Bind( "bg", prefix.."notif_blocked",            "Сървъра ви е блокирал да извършите това действие" )
localify.Bind( "bg", prefix.."notif_no_handler",         "Този обект няма анти-noclip защита" )


--[[--------------------------------------------------------------------------
-- <Other> Localization
--------------------------------------------------------------------------]]--
--[[
-- Tool Settings
localify.Bind( "", prefix.."name",                     "" )
localify.Bind( "", prefix.."desc",                     "" )
localify.Bind( "", prefix.."0",                        "" )
-- Errors
localify.Bind( "", prefix.."error_zero_weight",        "" )
localify.Bind( "", prefix.."error_invalid_phys",       "" )
localify.Bind( "", prefix.."error_max_weight",         "" )
-- Labels
localify.Bind( "", prefix.."label_colorscale",         "" )
localify.Bind( "", prefix.."label_weight",             "" )
localify.Bind( "", prefix.."label_decimals",           "" )
localify.Bind( "", prefix.."label_tooltip_scale",      "" )
localify.Bind( "", prefix.."label_language",           "" )
localify.Bind( "", prefix.."label_credits",            "" )
-- Checkboxes
localify.Bind( "", prefix.."checkbox_round",           "" )
localify.Bind( "", prefix.."checkbox_tooltip_show",    "" )
localify.Bind( "", prefix.."checkbox_tooltip_legacy",  "" )
localify.Bind( "", prefix.."checkbox_notifs",          "" )
localify.Bind( "", prefix.."checkbox_notifs_sound",    "" )
-- Comboboxes
localify.Bind( "", prefix.."combobox_green_to_red",    "" )
localify.Bind( "", prefix.."combobox_green_to_yellow", "" )
localify.Bind( "", prefix.."combobox_green_to_blue",   "" )
localify.Bind( "", prefix.."combobox_blue_to_red",     "" )
localify.Bind( "", prefix.."combobox_none",            "" )

localify.Bind( "", prefix.."combobox_minimum",         "" )
localify.Bind( "", prefix.."combobox_maximum",         "" )
localify.Bind( "", prefix.."combobox_default",         "" )
-- Descriptions
localify.Bind( "", prefix.."help_colorscale",          "" )
localify.Bind( "", prefix.."help_decimals",            "" )
localify.Bind( "", prefix.."help_tooltip_show",        "" )
localify.Bind( "", prefix.."help_tooltip_scale",       "" )
localify.Bind( "", prefix.."help_tooltip_legacy",      "" )
localify.Bind( "", prefix.."help_notifs",              "" )
localify.Bind( "", prefix.."help_notifs_sound",        "" )
-- HUD Text
localify.Bind( "", prefix.."hud_original",             "" )
localify.Bind( "", prefix.."hud_modified",             "" )
-- Notifications
localify.Bind( "", prefix.."notif_applied",            "" )
localify.Bind( "", prefix.."notif_copied",             "" )
localify.Bind( "", prefix.."notif_restored",           "" )
]]

-- Hopefully will add more with community/crowdsource support.

-- If you are multi/bilingual, please consider helping me translate the phrases above into other languages.
-- Create an issue on the Github page ( https://github.com/Mista-Tea/improved-weight ) or
-- add me on Steam ( http://steamcommunity.com/profiles/76561198015280374 ). Thanks!
