#!/bin/sh

target_pro=developer
if [  -d $target_pro ]
then
	echo "start git  pull ...  "
	cd $target_pro
	git pull
	echo "update finish!"
else
	git clone https://github.com/hai046/developer.git $target_pro
	cd $target_pro
	echo "clone finish"
fi
gitbook install
gitbook build

cd ..

for f in `find developer/_book  -type f` 
do
	f2=`echo ${f:16}`
#	echo "f=$f,f2=$f2"
	temp=`cmp $f $f2 `
#	echo $temp
	if [ "$temp" != "" ]; then
#			echo same continue;
#	else
		echo "different  cp \t$f to \t$f2 :\n \t $temp"
		cp -aRf $f $f2	
	fi 
done
#cp -aRf developer/_book/*  .
git status
echo "finish"

