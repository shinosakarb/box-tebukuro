require 'spec_helper'

%w(vim curl wget git apt-transport-https).each do |name|
  describe package(name) do
    it { should be_installed }
  end
end

%w(autoconf bison build-essential libssl-dev libyaml-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev).each do |name|
  describe package(name) do
    it { should be_installed }
  end
end

describe command('rbenv versions') do
  its(:stdout) { should match /2.3.3/ }
  its(:stdout) { should match /2.4.0/ }
end

describe command('rbenv global 2.3.3') do
  describe package('bundler') do
    it { should be_installed.by('gem') }
  end
end

describe command('rbenv global 2.4.0') do
  describe package('bundler') do
    it { should be_installed.by('gem') }
  end
end

describe command('n bin 7.3.0') do
  its(:stdout) { should match /\/root\/n\/n\/versions\/node\/7.3.0/ }
end

describe command('n bin 6.9.2') do
  its(:stdout) { should match /\/root\/n\/n\/versions\/node\/6.9.2/ }
end

describe package('yarn') do
  it { should be_installed }
end
