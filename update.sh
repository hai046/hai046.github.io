#!bin/sh

target_pro=developer
if [ $1 ]
then
	cd $target_pro
	git pull
else
	git clone https://git.gitbook.com/hai046/developer.git $target_pro
	cd $target_pro
fi

gitbook build

cd ..

mv -r  $target_pro/_book/*  . 

