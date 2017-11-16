#!/bin/bash

# $1: set name to a name that does not appear in the directory 'results' 
name=$1

# we use the directory $HOME/benchmark-tool/general 
general=general
dir=$PWD
bench=$dir/run-benchmark.xml

echo "start execution..."
rm -rf $dir/results/$name
mkdir -p $dir/results/$name 
cd $HOME/benchmark-tool
rm -rf output/$general

echo "bgen..."
./bgen $bench

echo "$HOME/benchmark-tool/output/$general/houat/start.py..."
./output/$general/houat/start.py

echo "beval..."
./beval $bench > $dir/results/$name/$name.beval 2> $dir/results/$name/$name.error

echo "bconv..."
cat $dir/results/$name/$name.beval | ./bconv -m time,ctime,csolve,ground0,groundN,models,timeout,restarts,conflicts,choices,domain,vars,cons,mem,error,memout > $dir/results/$name/$name.ods 2>> $dir/results/$name/$name.error

echo "mv..."
mv output/$general/* $dir/results/$name
#mv output/$general/houat/results/seq-suite/* $dir/results/$name
# warning: next line won't work with many runs
#for i in $(find $dir/results/$name -name run1        -type d); do mv $i/* $i/..; rm -rf $i;   done
#for i in $(find $dir/results/$name -name general-0-* -type d); do rename 's/general-0-//' $i; done
echo "done"
echo $dir/results/$name/$name.ods

