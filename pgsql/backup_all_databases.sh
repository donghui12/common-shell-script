#!/bin/bash

function backup_all_databases {
  # 获取当前日期
  local date_tag=$(date +%Y%m%d)
  local time_tag=$(date +%H:%M:%S)

  # 获取所有数据库名称并用空格分割成列表
  local databases=$(PGPASSWORD="$3" psql -U "$2" -l -t -A | cut -d '|' -f 1 | grep -vE '^(postgres|template[0|1]|postgres=CTc/postgres|biloop=CTc/biloop|biloop=CTc/postgres)$' | tr '\n' ' ')

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
    pg_dumpall --database="$db" --file="$5/$sql_tag"

    # 打印备份完成时间
    time_tag=$(date +%H:%M:%S)
    echo -e "\e[32m[$time_tag]\e[0m Backup of database \e[33m$db\e[0m completed"

    # 压缩备份文件并删除原文件
    cd "$5"
    tar -czf "$tar_tag" "$sql_tag"
    rm "$sql_tag"
  done

  # 打印所有数据库备份完成时间
  time_tag=$(date +%H:%M:%S)
  echo -e "\e[32m[$time_tag]\e[0m Backup of all databases completed"
}

# 调用函数进行备份
backup_all_databases "localhost" "postgres" "LpqjRQ4g-Qcrv6bmo-RyfYQ3Vk-GexZw4KH" "5432" "/home/apps/sql_back/pgsql_back/"
