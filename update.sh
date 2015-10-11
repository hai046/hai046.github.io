#!bin/sh

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

cp -aRf developer/_book/*  .

echo "finish"

