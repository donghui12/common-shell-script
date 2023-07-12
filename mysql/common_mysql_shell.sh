#!/bin/bash

# ===========================================================================================================
# 批量创建，导入数据库
databases=("test1" "test2" "test3")

for db in "${databases[@]}"
do
  MYSQL_PWD=$password mysql -uroot -e "CREATE DATABASE $db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
  MYSQL_PWD="linuxgz110411" mysqldump -u "root" $db > $db".sql"
done
#-------------------------------------------------------------------------------------------------------------
