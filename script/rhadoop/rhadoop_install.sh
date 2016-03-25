rpm -Uvh http://mirror01.idc.hinet.net/EPEL/6/i386/epel-release-6-8.noarch.rpm
yum update -y
yum search r-project -y
yum install R.x86_64 R-devel.x86_64 R-java.x86_64 -y
wget https://github.com/RevolutionAnalytics/rmr2/releases/download/3.3.1/rmr2_3.3.1.tar.gz
wget https://github.com/RevolutionAnalytics/plyrmr/releases/download/0.6.0/plyrmr_0.6.0.tar.gz
wget https://github.com/RevolutionAnalytics/rhdfs/blob/master/build/rhdfs_1.0.8.tar.gz
R -f install_dp.r
R CMD javareconf
sudo R CMD INSTALL rmr2_3.3.1.tar.gz
sudo HADOOP_CMD=/opt/cloudera/parcels/CDH/bin/hadoop R CMD INSTALL rhdfs_1.0.8.tar.gz
sudo R CMD INSTALL plyrmr_0.6.0.tar.gz
