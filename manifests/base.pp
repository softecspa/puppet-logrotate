class logrotate::base {

	include logrotate::params

	package { 'logrotate':
		ensure	=> installed,
	}

	file { '/etc/logrotate.d':
		ensure	=> directory,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '755',
		require	=> Package['logrotate'],
	}

	file { '/etc/logrotate.conf':
		ensure	=> present,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '644',
		source	=> 'puppet:///modules/logrotate/logrotate.conf',
		require	=> Package['logrotate'],
	}

	file { '/etc/cron.daily/logrotate':
		ensure	=> present,
		owner	=> 'root',
		group	=> 'root',
		mode	=> '755',
		source	=> 'puppet:///modules/logrotate/logrotate_cron',
		require	=> Package['logrotate'],
		# notify	=> Service["${logrotate::params::cron_service_name}"],
	}

  $require = $logrotate::olddir_group?{
    'adm'   => Package['logrotate'],
    'root'  => Package['logrotate'],
    default => [ Package['logrotate'], Group[$logrotate::olddir_group] ]
  }

	file { "${logrotate::params::logrotate_archive_dir}":
		ensure	=> directory,
		owner	  => $logrotate::olddir_owner,
		group	  => $logrotate::olddir_group,
		mode	  => $logrotate::olddir_mode,
		require	=> $require
	}

  $require_subdir = $logrotate::olddir_group?{
    'adm'   => File[$logrotate::params::logrotate_archive_dir],
    'root'  => File[$logrotate::params::logrotate_archive_dir],
    default => [ File[$logrotate::params::logrotate_archive_dir], Group[$logrotate::olddir_group] ]
  }

	file { "${logrotate::params::logrotate_archive_dir}/wtmp":
		ensure	=> directory,
		owner	  => $logrotate::olddir_owner,
		group	  => $logrotate::olddir_group,
		mode	  => $logrotate::olddir_mode,
		require	=> $require_subdir
	}

	file { "${logrotate::params::logrotate_archive_dir}/btmp":
		ensure	=> directory,
    owner   => $logrotate::olddir_owner,
    group   => $logrotate::olddir_group,
    mode    => $logrotate::olddir_mode,
		require	=> $require_subdir
	}

	if $operatingsystem == "CentOS" {
		logrotate::file { 'yum':
			log			=> '/var/log/yum.log',
			interval	=> 'yearly',
			size		=> '30k',
			rotation	=> '4',
			archive		=> 'true',
			create		=> '0600 root root',
			options		=> [ 'missingok', 'notifempty', 'dateext' ],
		}
	}
}
