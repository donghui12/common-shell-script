pg_dump -d database > databasename.dump # 将 database 替换为需要导出的数据库名称

# 切换用户
su - postgres

# 导入数据库
psql -d database < databasename.dump. // 将 database 替换为需要导入的数据库名称

\l; // 查看数据列表
\c databasename; //切换数据库
\d; //查看当前数据库中表列表


GRANT ALL PRIVILEGES ON DATABASE databasename TO username; // 赋予 username databasename 的全部权限


# 赋予一个用户 增删查改权限
GRANT update,delete,insert,select ON ALL TABLES IN SCHEMA public TO biloop;

# 赋予一个用户，所有权限
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO biloop;
