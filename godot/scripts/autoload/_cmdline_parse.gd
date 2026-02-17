# Helper functions for parsing simple command-line flags.
# Intentionally tiny to avoid adding dependencies.

class_name CmdlineParse

static func get_flag_value(args: PackedStringArray, key: String) -> String:
	# Supports:
	# - --key=value
	# - --key value
	for i in range(args.size()):
		var a := args[i]
		if a.begins_with(key + "="):
			return a.substr((key + "=").length())
		if a == key and i + 1 < args.size():
			return args[i + 1]
	return ""

static func has_flag(args: PackedStringArray, key: String) -> bool:
	for a in args:
		if a == key:
			return true
		if a.begins_with(key + "="):
			return true
	return false
