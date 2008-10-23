Merb::BootLoader.after_app_loads do
end

use_orm :datamapper
use_test :rspec

use_template_engine :erb

Merb::Router.prepare do
  match('/').to(:controller => "lol_u_all_suk", :action =>'index')
  default_routes
end

Merb::Config.use { |c|
  c[:environment]         = 'production',
  c[:framework]           = {},
  c[:log_level]           = :debug,
  c[:log_stream]          = STDOUT,
  # or use file for logging:
  # c[:log_file]          = Merb.root / "log" / "merb.log",
  c[:use_mutex]           = false,
  c[:session_store]       = 'cookie',
  c[:session_id_key]      = '_session_id',
  c[:session_secret_key]  = '5321f6d8504111d91a1dbaf10ee1d4ce03d0f916',
  c[:exception_details]   = true,
  c[:reload_classes]      = true,
  c[:reload_templates]    = true,
  c[:reload_time]         = 0.5
}
