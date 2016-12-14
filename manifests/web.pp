exec { "apt-update":
    command => "/usr/bin/apt-get update"
}

package { ["php5","php5-mcrypt", "php5-gd", "apache2", "libapache2-mod-php5"]:
    ensure => installed,
    require => Exec["apt-update"]
}

exec { "curl":
    command => "/usr/bin/curl -sS https://getcomposer.org/installer | sudo /usr/bin/php -- --install-dir=/usr/local/bin --filename=composer",
    require => Package["php5"]
}

exec { "php5enmod":
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
    command => "php5enmod mcrypt",
    require => Package["php5"]
}

exec { "create-laravel-folder":
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin/", "/usr/local/"],
    command => 'mkdir /home/vagrant/laravel',
    require => Exec["php5enmod"]
}

exec { "install-laravel":
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin/", "/usr/local/"],
    command => 'sudo composer create-project laravel/laravel /home/vagrant/laravel/ "5.0.*" --prefer-dist',
    require => Exec["create-laravel-folder"]
}


