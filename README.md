# QByanski Mission System for Qbox

A fully-featured **Daily, Hourly, and Hidden Mission System** for **Qbox servers**, featuring NPC interactions, progress tracking, and rewards. Built with **ox_lib**, this system is optimized for performance, clean UI, and easy integration.

---

## Features

- ✅ **Daily Missions**
  - Reset every 24 hours.
  - Receive random tasks with item or money rewards.
  - Check progress at any time.

- ✅ **Hourly Missions**
  - Reset every hour.
  - Quick tasks with smaller rewards.
  - Track progress live.

- ✅ **Hidden Missions**
  - Special missions that appear only at certain hours.
  - Can only be completed once per player.
  - Optional unique rewards.

- ✅ **NPC Interaction**
  - Daily, Hourly, and Hidden NPCs located in configurable positions.
  - Use `ox_target` for clean interaction menus.
  - Floating prompts (Press [E] to interact).

- ✅ **ox_lib Integration**
  - Modern menu system replacing `qb-menu`.
  - Event-driven, optimized for Qbox.
  - Supports keyboard and controller input.

- ✅ **Reward System**
  - Item rewards (inventory-compatible).
  - Money rewards (cash or bank).
  - Auto-removes required items when mission completed.

---

## Installation

1. Clone or download this repository into your `resources` folder:
   ```
   resources/[qb]/QByanski-Mission
   ```

2. Ensure dependencies are running in your `server.cfg`:
   ```cfg
   ensure ox_lib
   ensure ox_target
   ensure QByanski-Mission
   ```

3. Add your mission configurations in `config.lua`:
   - Daily NPC location & ped model
   - Hourly NPC location & ped model
   - Hidden mission NPCs, times, and ped models
   - Mission requirements and rewards

4. Start your server.

---

## Usage

### Accessing Missions
- Approach the **Daily/Hourly/Hidden NPC** and interact via the prompt.
- Menus will appear to:
  - Take a mission
  - Check mission progress
  - Exit the menu

### Commands
- **Reset Missions (Admin)**
  ```txt
  /resetmission [playerID]
  ```
  Resets the daily/hourly missions and timestamps for a player.

---

## Configuration

All configurable data is stored in `config.lua`:

```lua
Config.Daily_NPC = {
    ped = "a_m_m_farmer_01",
    coords = vector4(-250.0, -963.0, 30.2, 180.0)
}

Config.Hourly_NPC = {
    ped = "a_m_m_farmer_01",
    coords = vector4(-260.0, -965.0, 30.2, 90.0)
}

Config.Hidden_Mission = {
    ["secret1"] = {
        ped = "a_m_m_business_01",
        coords = vector4(-270.0, -970.0, 30.2, 45.0),
        min_time = 20, -- Available after 8 PM
        max_time = 22, -- Available until 10 PM
        required = { "item_name" = 5 },
        reward_item = { "reward_item_name" = 1 },
        reward_money = { cash = 1000 }
    }
}
```

---

## Notes

- Make sure **ox_lib** and **ox_target** are installed and updated.
- All menus and interactions are fully Qbox-native; no `qb-menu` dependency required.
- You can expand missions, NPCs, and rewards in `config.lua` without touching server/client logic.

---

## Contributing

1. Fork the repository
2. Create a new branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Create a Pull Request

---

## License

This project is **MIT Licensed** — feel free to use, modify, and distribute in your Qbox projects.

---

## Support

If you encounter any issues or need help integrating:

- Discord: [Your Discord Link Here]
- GitHub Issues: [Open a new issue on this repo]