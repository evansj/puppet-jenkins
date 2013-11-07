#
# jenkins::package handles the actual installation of the Jenkins native
# package installation.
#
# The package might not specify a dependency on Java, so you may need to
# specify that yourself
class jenkins::package(
  $version = 'installed',
  $repo = undef
) {

  $yum_jenkins_gpg = $::lsbmajdistrelease ? {
      '5'     => '/etc/pki/rpm-gpg/RPM-GPG-KEY-jenkins.el5',
      default => '/etc/pki/rpm-gpg/RPM-GPG-KEY-jenkins',
  }
  
  file { $yum_jenkins_gpg :
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => "puppet:///modules/jenkins/${yum_jenkins_gpg}";
  }
  
  exec { 'httpd_yum_install':
      command => "/usr/bin/yum --disablerepo=* --enablerepo=${repo} -y install jenkins",
      creates => '/usr/lib/jenkins/jenkins.war',
      require => File[$yum_jenkins_gpg],
  }
  
  package {
    'jenkins' :
      ensure => $version;
  }
}
