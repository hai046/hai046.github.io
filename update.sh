#!bin/sh

target_pro=developer
if [ -z $1 ]
then
	echo "start git  pull ...  "
	cd $target_pro
	git pull
	echo "update finish!"
else
	git clone https://git.gitbook.com/hai046/developer.git $target_pro
	cd $target_pro
	echo "clone finish"
fi

gitbook build

cd ..

cp -aRf developer/_book/*  .

echo "finish"

