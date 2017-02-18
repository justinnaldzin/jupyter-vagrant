# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.box_url = "https://atlas.hashicorp.com/centos/boxes/7/versions/1611.01/providers/virtualbox.box"
  config.vm.network "forwarded_port", guest: 8888, host: 8888  # Jupyter Notebook
  config.vm.network "forwarded_port", guest: 4040, host: 4040  # Spark local application UI
  config.vm.provider :virtualbox do |vb|
    vb.name = "jupyter-vagrant"
    vb.memory = "2048"
  end
  config.vm.synced_folder ".", "/jupyter-vagrant"
  config.vm.provision :shell, :path => "scripts/base.sh"
  config.vm.provision :shell, :path => "scripts/python3_install.sh"
  config.vm.provision :shell, :path => "scripts/spark_install.sh"
  config.vm.provision "up", type: "shell", run: "always", inline: "jupyter notebook --notebook-dir=/jupyter-vagrant/notebook --no-browser --ip=0.0.0.0 --port=8888 --NotebookApp.token='' &"
end
