require 'yaml'

APP_CONFIG = YAML.load(
  File.open('config/app.yml').read
).freeze

ROOT_DIR = "#{__dir__}/../"
