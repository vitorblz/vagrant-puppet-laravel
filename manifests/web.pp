exec { "add-rep-php7":
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin/", "/usr/local/"],
    command => "add-apt-repository ppa:ondrej/php"
}

exec { "apt-update":
    command => "/usr/bin/apt-get update",
    require => Exec["add-rep-php7"]
}

package { ["php7.0","php7.0-fpm", "php7.0-mysql", "libapache2-mod-php7.0", "php7.0-mcrypt", "php7.0-curl", "php7.0-json", "php7.0-xml", "php7.0-zip", "php7.0-mbstring", "apache2", "openssl", "curl"]:
    ensure => installed,
    require => Exec["apt-update"]
}

exec { "install-composer":
    command => "/usr/bin/curl -sS https://getcomposer.org/installer | sudo /usr/bin/php -- --install-dir=/usr/local/bin --filename=composer",
    require => Package["php7.0", "curl"]
}

exec { "add-swap":
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin/", "/usr/local/"],
    command => 'sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024; sudo /sbin/mkswap /var/swap.1; sudo /sbin/swapon /var/swap.1',
    require => Exec["install-composer"]
}

exec { "install-laravel":
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin/", "/usr/local/"],
    command => '/usr/local/bin/composer global require "laravel/installer"',
    environment => ["COMPOSER_HOME=/home/vagrant/"],
    cwd         => "/home/vagrant/", 
    user        => vagrant, 
    group       => vagrant,
    require => Exec["add-swap"],
}

exec { "set-environment-var-path":
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin/", "/usr/local/"],
    command => 'sed -e "s|PATH=\"|PATH=\"/home/vagrant/vendor/bin:|" -i /etc/environment',
    require => Exec["install-laravel"]
}