Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"

    config.vm.define :web do |web_config|
      web_config.vm.network "private_network", ip: "192.168.1.30"
        web_config.vm.provision "puppet" do |puppet|
        	puppet.manifest_file = "web.pp"
    	end
    end
end