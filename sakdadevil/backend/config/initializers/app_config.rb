require 'ostruct'
require 'yaml'

config_dir_path = File.expand_path('../..',__FILE__)
config_file_path = "#{config_dir_path}/config.yml"
all_config = YAML.load_file(config_file_path) || {}
env_config = all_config[Rails.env] || {}
APP_CONFIG = OpenStruct.new(env_config)
