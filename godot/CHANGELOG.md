# Changelog

> Note: This repo may contain later milestone work. For **M0 Bootstrap** evaluation, use the **poc-0.1.0 (M0 Bootstrap)** section below.

## poc-0.1.3 (M3 Spike Wall + Knockback + Charger)
- Hazard: Spike Wall (HZD_SPIKE_WALL) with HP-ratio damage, enemy stun, per-enemy internal cooldown
- Knockback system (KnockbackComponent) with resistance + post-knockback immunity (anti-cheese)
- Player Skill1: Shove (skill1_btn) applying AoE knockback (no damage) + debug HUD cooldown display
- Enemy: Charger (ENY_CHARGER) with Bull Charge intent (telegraph/commit lock/execute dash/recover)
- Induced Success detection + feedback + telemetry events (spikewall_hit / knockback_applied / player_shove / induced_success)
- Test arena: SpikeArena_GauntletLane (ROOM_GAUNTLET_LANE)

## poc-0.1.2 (M2 Intent Combat Stabilization / Testability)
- TC01 entry friction reduced: MainMenu **Start** routes directly into **IntentArena_Slasher**
- Arena: IntentArena_Slasher emits deterministic `room_enter` on load (testability)
- ADR shipped: Logging unification direction chosen (Telemetry as canonical pipeline)
- Enemy framework: EnemyBase with intent state machine (ChooseIntent → Telegraph → Commit(LOCK) → Execute → Recover)
- TelegraphIndicator FX: ground line telegraph + damage label; Commit becomes thicker/solid + lock icon
- Enemy: ENY_SLASHER minimal with Lunge Slash (direction lock on Commit, dash execute, recover)
- Telemetry/events: intent_* + commit cue events available in JSONL under `user://logs/`

## poc-0.1.1 (M1 Player + Combat Core)
- Player: top-down keyboard movement (move_*) + Camera2D follow
- Combat: melee attack (auto-aim nearest dummy/targetable) + dash (cooldown + brief invulnerability)
- Components: HealthComponent (take_damage), Hurtbox/Hitbox (Area2D) with required damage telemetry
- Debug: DummyTarget scene with HP label
- HUD: HUD_Debug (FPS, Player HP, Dash cooldown, Scene name, Run timer)
- Telemetry: player_move (start/stop), player_attack, player_dash, damage_dealt, damage_taken (JSONL)

## poc-0.1.0 (M0 Bootstrap)
- Godot 4.x project skeleton with MainMenu → TestArena scene flow
- Autoloads: GameApp, RunManager, DataRepo, Telemetry
- Baseline telemetry JSONL logging to user://logs/
- Placeholder build/QA scripts under res://tools/
