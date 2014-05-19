class logrotate (
  $olddir_owner  = 'root',
  $olddir_group  = 'adm',
  $olddir_mode   = '2750',
){
  include logrotate::base
}


