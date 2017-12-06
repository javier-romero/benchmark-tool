#!/bin/bash

# $1:  name of the experiment
name=$1

# set this
btool=$HOME/git/tmp/benchmark-tool

# this has to be the same as project name in run-benchmark.xml
project=project

# this has to be the command used in run-benchmark.xml
command=$PWD/solver.sh

dir=$PWD
bench=$dir/run-benchmark.xml

echo "start execution..."
rm -rf $dir/results/$name
mkdir -p $dir/results/$name 
cd $btool
rm -rf output/$project

echo "bgen..."
./bgen $bench

echo "$btool/output/$project/houat/start.py..."
./output/$project/houat/start.py

echo "beval..."
./beval $bench > $dir/results/$name/$name.beval 2> $dir/results/$name/$name.error

echo "bconv..."
cat $dir/results/$name/$name.beval | ./bconv -m time,ctime,csolve,ground0,groundN,models,timeout,restarts,conflicts,choices,domain,vars,cons,mem,error,memout > $dir/results/$name/$name.ods 2>> $dir/results/$name/$name.error

echo "tar..."
tar -czf $name.tar.gz output/$project
mv $name.tar.gz $dir/results/$name
cp $bench $dir/results/$name
cp $command $dir/results/$name
$rm -rf output/$project

echo "done"
echo $dir/results/$name/$name.ods
# send an email to report that the experiments are done
# echo "done $1" | mail -s "[benchmark_finished] $1 " -A $dir/results/$name/$name.ods <email>

