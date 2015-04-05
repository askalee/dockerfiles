require 'spec_helper'

%w[
  sudo adduser curl ca-certificates openssl git lv vim-tiny man-db whiptail zsh net-tools
  etckeeper locales tzdata localepurge sysvinit openssh-server rsyslog cron
].each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe file("/etc/default/locale") do
  its(:content){ should include 'LANG=C' }
end

describe file("/etc/locale.gen") do
  its(:content){ should match /^en_US\.UTF-8\s+UTF-8\s*/ }
  its(:content){ should match /^ja_JP\.UTF-8\s+UTF-8\s*/ }
end

describe file("/etc/timezone") do
  its(:content){ should include 'Asia/Tokyo' }
end

describe file("/etc/localtime") do
  its(:md5sum){ should eq '9e165b3822e5923e4905ee1653a2f358' }
end

describe file("/etc/locale.nopurge") do
  its(:content){ should match /^en$/ }
  its(:content){ should match /^en_US$/ }
  its(:content){ should match /^en_US\.UTF-8$/ }
  its(:content){ should match /^ja$/ }
  its(:content){ should match /^ja_JP\.UTF-8$/ }
end

describe file("/etc/inittab") do
  its(:content) { should match %r!^#si::sysinit:/etc/init.d/rcS! }
  its(:content) { should match %r!^#1:2345:respawn:/sbin/getty 38400 tty1$! }
  its(:content) { should match %r!^#[2-7]:23:respawn:/sbin/getty 38400 tty[2-7]$! }
end

describe file("/etc/default/hwclock") do
  its(:content) { should match /^HWCLOCKACCESS=no$/ }
end

describe file("/etc/sudoers") do
  it { should be_mode 440 }
  its(:content) { should match /^#%sudo\s+/ }
end

describe file("/etc/sudoers.d/local") do
  it { should be_mode 440 }
  its(:content) { should include '%sudo ALL=(ALL:ALL) NOPASSWD: ALL' }
end

describe group('debian') do
  it { should be_exist }
  it { should have_gid 2000 }
end

describe user('debian') do
  it { should be_exist }
  it { should belong_to_group 'debian' }
  it { should belong_to_group 'sudo' }
  it { should belong_to_group 'adm' }
  it { should have_uid 2000 }
  it { should have_home_directory '/home/debian' }
  it { should have_login_shell '/bin/bash' }
end

%w[ssh cron rsyslog].each do |svc|
  describe service(svc) do
    it { should be_enabled }
    it { should be_running }
  end
end
