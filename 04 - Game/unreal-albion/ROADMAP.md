# Soft Power — Roadmap

## Unreal Albion (Godot 4 Narrative RPG)

Engine: Godot 4. Project: `04 - Game/unreal-albion/`

### Vertical Slice: "The Albion: Night One"
- [x] Project bootstrap — directory tree, project.godot, .gitignore, placeholder assets
- [x] Core singletons — EventBus, GameState, DialogueManager, SceneManager, AudioManager
- [x] UI foundation — HUD (stat bars), DialogueBox (typewriter + choices), Phone UI, Transition
- [x] Scene 1: Camden Approach — walk to venue, inspect interactions, first choice
- [x] Scene 2: Door Negotiation — Mara gatekeeper, 4 entry paths
- [x] Scene 3: Albion Main Room Hub — 3 NPCs (Jules/Viv/Bootsy), 2-of-3 timer constraint
- [x] Scene 4: Back-Room Recovery — 3 mutually exclusive recovery options
- [x] Scene 5: Stage Confrontation — 3-round turn-based musical combat, 5 actions, 2 enemies
- [x] Scene 6: Three endings — Breakthrough, Compromise, Fold
- [x] Dialogue JSON data — all scenes, NPC conversations, enemy data, passive inserts
- [ ] Audio integration — convert 7 Streets MP3 to 3 OGG stems (calm/rising/overheat)
- [ ] Playtest and balance — full branch testing, stat tuning
- [ ] Real art assets — replace placeholder PNGs with illustrated backgrounds and portraits
- [ ] Loop mechanic (New Game Plus) — persistent flags, Loop 2 dialogue variants

### Future
- [ ] Expand to full campaign (10 scenes, 3 acts)
- [ ] Destiny Vegas integration (Loop 2 secret route)
- [ ] Yoshikoko quest line
- [ ] Original soundtrack with adaptive stems per scene
