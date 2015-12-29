define logrotate::file (
  $log=false,
  $interval=false,
  $rotation=false,
  $size=false,
  $minsize=false,
  $options=false,
  $archive=false,
  $olddir="${logrotate::params::logrotate_archive_dir}/$name",
  $olddir_owner = $logrotate::olddir_owner,
  $olddir_group = $logrotate::olddir_group,
  $olddir_mode = $logrotate::olddir_mode,
  $create=false,
  $scripts=false,
  $postrotate=false
) {
  include logrotate

    if !defined(File[$olddir]) {
      file { "$olddir":
        ensure	=> directory,
        owner	  => $olddir_owner,
        group	  => $olddir_group,
        mode	  => $olddir_mode,
      }
    }


  file { "/etc/logrotate.d/${name}":
    ensure  => present,
    owner	  => 'root',
    group	  => 'root',
    mode	  => '644',
    content	=> template('logrotate/logrotate_file.erb'),
    require	=> File['/etc/logrotate.d'],
  }

}


