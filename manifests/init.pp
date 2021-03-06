# Public: installs java jre-7u21 and JCE unlimited key size policy files
#
# Examples
#
#    include java
class java {
  include boxen::config

  $jre_url = 'http://sdlc-esd.sun.com/ESD6/JSCDL/jdk/7u51-b13/jre-7u51-macosx-x64.dmg?AuthParam=1390235074_3eef9964bc12c9e711a238ff30a33360&GroupName=JSC&FilePath=/ESD6/JSCDL/jdk/7u51-b13/jre-7u51-macosx-x64.dmg&File=jre-7u51-macosx-x64.dmg&BHost=javadl.sun.com'
  $jdk_url = 'http://sdlc-esd.sun.com/ESD6/JSCDL/jdk/7u51-b13/jdk-7u51-macosx-x64.dmg?AuthParam=1390235074_3eef9964bc12c9e711a238ff30a33360&GroupName=JSC&FilePath=/ESD6/JSCDL/jdk/7u51-b13/jdk-7u51-macosx-x64.dmg&File=jdk-7u51-macosx-x64.dmg&BHost=javadl.sun.com'
  $wrapper = "${boxen::config::bindir}/java"
  $sec_dir = '/Library/Java/JavaVirtualMachines/jdk1.7.0_51.jdk/Contents/Home/jre/lib/security'

  package {
    'jre-7u51.dmg':
      ensure   => present,
      alias    => 'java-jre',
      provider => pkgdmg,
      source   => $jre_url ;
    'jdk-7u51.dmg':
      ensure   => present,
      alias    => 'java',
      provider => pkgdmg,
      source   => $jdk_url ;
  }

  file { $wrapper:
    source  => 'puppet:///modules/java/java.sh',
    mode    => '0755',
    require => Package['java']
  }


  # Allow 'large' keys locally.
  # http://www.ngs.ac.uk/tools/jcepolicyfiles

  file { $sec_dir:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'wheel',
    mode    => '0775',
    require => Package['java']
  }

  file { "${sec_dir}/local_policy.jar":
    source  => 'puppet:///modules/java/local_policy.jar',
    owner   => 'root',
    group   => 'wheel',
    mode    => '0664',
    require => File[$sec_dir]
  }

  file { "${sec_dir}/US_export_policy.jar":
    source  => 'puppet:///modules/java/US_export_policy.jar',
    owner   => 'root',
    group   => 'wheel',
    mode    => '0664',
    require => File[$sec_dir]
  }
}
