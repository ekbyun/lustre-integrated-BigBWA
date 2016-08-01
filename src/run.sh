#/bin/sh
if [ $# -lt 5 ]
then
        echo "USAGE : run.sh <# of partitions> <# of threads per mapper> <input_1> <input_2> <outputdir (relative in HDFS user home)>"
        echo "   input output file location is relative path from HDFS user home directory"
        exit 1
fi

LUSTRE_ADAPTER=/home/bwauser/lustrefs/target/lustrefs-hadoop-0.9.1.jar
RG=/lustre/scratch/bwauser/Data/HumanBase/hg19.fa

MOUNT_LOC=`hdfs getconf -confKey fs.lustrefs.mount`
MOUNT_LOC=${MOUNT_LOC}/user/${USER}/$5
PREFIX=${MOUNT_LOC}/out/Output
OUTPUT=${MOUNT_LOC}/merged.sam

time hadoop jar BigBWA.jar -archives bwa.zip -libjars ${LUSTRE_ADAPTER},BigBWA.jar -partitions $1 -threads $2 -algorithm mem -reads paired -index ${RG} $3 $5/out
hdfs dfs -rm -r -f $5/out

time hadoop jar BigBWA.jar -archives bwa.zip -libjars ${LUSTRE_ADAPTER},BigBWA.jar -partitions $1 -threads $2 -algorithm mem -reads paired -index ${RG} $4 $5/out

NP=`ls -l ${PREFIX}* | wc -l`

time mpirun -np $NP -hostfile ../etc/hosts ./reduce ${PREFIX} ${OUTPUT}

hdfs dfs -rm -r -f $5/out
