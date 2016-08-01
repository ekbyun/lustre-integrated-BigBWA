# Introduction
The goal of lustre-integrated BigBWA is to complement BigBWA(https://github.com/citiususc/BigBWA) to be executed on lustre file system environment to enhance performance and compatibility. It works with a lustre-hadoop adapter released by Seagate Inc.(https://github.com/Seagate/lustrefs)

# Requirements
- BigBWA(https://github.com/citiususc/BigBWA)
- Apache Hadoop 2.6.0 or later
- mountable Lustre file system
- Lustre-Hadoop Adapter(https://github.com/Seagate/lustrefs)
- MPI (OpenMPI or mvapich)

# Install
1. Mount lustre file system and create directory <lustre mount point>/hadoop/user/<username> and grant permission to user who will run Hadoop
2. check if MPI is installed by run "mpicc --version" and "mpirun --version"
3. Download apache hadoop src, apply patch(MAPRED-6636.patch,https://issues.apache.org/jira/browse/HADOOP-6636) for handling large file(greater than 2GB), build and install
4. Install lustre-hadoop adapter and configure hadoop
5. Configure hadoop, 
  in <hadoop home>/etc/hadoop/core-site.xml add
"
\<property\>
  <name>fs.lustrefs.shared_tmp.dir</name>
  <value>${fs.lustrefs.mount}/user/${user.name}/shared-tmp</value>
</property>
"
6. Download lustre-integrated BigBWA, copy files in /src to BigBWA/src, and apply patches(Makefile, Makefile.common, src/BigBWA.java) on BigBWA directory
7. build BigBWA 

# Run
1. locate input files (pair of .fastq)  under <lustre mount>/hadoop/user/<username>/
2. on build directory run run.sh
"
  USAGE : run.sh <# of partitions> <# of threads per mapper> <input_1> <input_2> <outputdir>
  *input output file location is relative path from HDFS user home directory
"
3. output file will be created on <lustre mount>/hadoop/user/<username>/<outputdir>/merged.sam
