require 'serverspec'
require 'docker'

set :backend,      :docker
set :docker_image, 'box-tebukuro'
