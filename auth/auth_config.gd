class_name AuthConfig
extends RefCounted

# Entire file is about connecting the API key
const SUPABASE_URL := "https://xdqgzijcsepeyvunqunh.supabase.co"
const SUPABASE_ANON_KEY := "sb_publishable_e4ZApDGzsDMGLM9Mt70iOA_zrnVVETx"


static func is_configured() -> bool:
	return not SUPABASE_URL.contains("YOUR-PROJECT-ID") and not SUPABASE_ANON_KEY.begins_with("YOUR-")
