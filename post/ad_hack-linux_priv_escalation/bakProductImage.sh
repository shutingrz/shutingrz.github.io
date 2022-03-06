#!/bin/bash


bakDir(){
	img_dir_path=$1
	dir_name=`basename $img_dir_path`
	tar -C `dirname $img_dir_path` -cf $work_dir/$dir_name.tar $dir_name
}


ecshop_dir=/var/www/html
image_root=$ecshop_dir/images
bak_dir=/var/backups/ecshop
date=`date +"%Y%m%d"`

TMP=`mktemp -d`
trap "rm -rf $TMP" EXIT
work_dir=$TMP/$date

mkdir $work_dir

#archive product image dir

image_dirs=`find $image_root -maxdepth 1 -type d`

for dir in $image_dirs; do
	isProductDir=`find $dir -maxdepth 1 -name 'goods_img' -type d  |wc -l`
	if [ $isProductDir -eq 1 ]; then
		bakDir $dir
	fi
done

#backup
tar -C `dirname $work_dir` -cf $bak_dir/$date.tar `basename $work_dir`
chown ecadmin $bak_dir/$date.tar

rm -rf $TMP
