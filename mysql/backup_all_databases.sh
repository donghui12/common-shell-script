#!/bin/bash

function backup_all_databases {
  # 获取当前日期
  local date_tag=$(date +%Y%m%d)
  local time_tag=$(date +%H:%M:%S)

  # 获取所有数据库名称并用空格分割成列表
  local databases=$(MYSQL_PWD="$3" mysql -u "$2" -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)" | tr '\n' ' ')

  # 定义备份文件名前缀
  local sql_prefix="database_"
  local tar_prefix="database_"

  # 遍历数据库列表并备份
  for db in $databases; do
    # 定义备份文件名
    local sql_tag="${sql_prefix}${db}_${date_tag}.sql"
    local tar_tag="${tar_prefix}${db}_${date_tag}.tar.gz"

    # 打印备份开始时间
    echo -e "\e[32m[$time_tag]\e[0m Starting backup of database \e[33m$db\e[0m"

    # 备份数据库
    MYSQL_PWD="$3" mysqldump -h "$1" -u "$2" "$db" > "$4/$sql_tag"

    # 打印备份完成时间
    time_tag=$(date +%H:%M:%S)
    echo -e "\e[32m[$time_tag]\e[0m Backup of database \e[33m$db\e[0m completed"

    # 压缩备份文件并删除原文件
    cd "$4"
    tar -czf "$tar_tag" "$sql_tag"
    rm -rf "$sql_tag"

    # 打印压缩完成时间
    time_tag=$(date +%H:%M:%S)
    echo -e "\e[32m[$time_tag]\e[0m Compression of backup file \e[33m$tar_tag\e[0m completed"
  done
}

time_tag=$(date +%H:%M:%S)
echo -e "\e[32m[$time_tag]\e[0m Backup of all databases starting"
# 调用备份函数并传入参数
backup_all_databases "localhost" "root" "linuxgz110411" "/home/apps/sql_back/mysql_back"
# 打印所有数据库备份完成时间
echo -e "\e[32m[$time_tag]\e[0m Backup of all databases completed"
