# @author Vsevolod Ivanov

# Workaround to prevent missing linux headers making new installs fail.
# Put into Vagrantfile directly under your `config.vm.box` definition
# vagrant plugin install vagrant-vbguest; vagrant vbguest
class WorkaroundVbguest < VagrantVbguest::Installers::Linux
  def install(opts=nil, &block)
        puts 'Ensuring we\'ve got the correct build environment for vbguest...'
        communicate.sudo('apt-get -y --force-yes update', (opts || {}).merge(:error_check => false), &block)
        communicate.sudo('apt-get -y --force-yes install -y build-essential linux-headers-amd64 linux-image-amd64', (opts || {}).merge(:error_check => false), &block)
        puts 'Continuing with vbguest installation...'
      super
        puts 'Performing vbguest post-installation steps...'
          communicate.sudo('usermod -a -G vboxsf vagrant', (opts || {}).merge(:error_check => false), &block)
  end
  def reboot_after_install?(opts=nil, &block)
    true
  end
end

$script = <<-SCRIPT
#!/bin/bash
apt -y install tmux apache2 git vim
sudo cp /vagrant/configs/apache-default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf
a2enmod ssl
sudo systemctl restart apache2
echo 'Downloading silently go 1.16.2...'
wget -q https://dl.google.com/go/go1.16.2.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.16.2.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
go version
cd /vagrant
go build
sudo echo "" > /var/log/apache2/error.log
go run main.go -host 127.0.0.1:443
sleep 3
sudo tail -n 10 /var/log/apache2/error.log
SCRIPT

Vagrant.configure('2') do |config|
  config.vm.box = 'debian/buster64'
  config.vbguest.installer = WorkaroundVbguest
  config.vm.provision :shell, :inline => $script
end
