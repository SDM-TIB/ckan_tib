# CKAN Docker image

## Installation 安装
Build ckan_base 创建ckan_base
```sh
$ docker build ./ckan_base -t ckan
```
Build ckan with plugins
```sh
$ docker build ../. -t ckan
```
Build postgresql or postgresql:loaded 创建postgresql image （两行指令选择其中一条执行。第一行指令没有任何数据，第二行已将联通提供的样品数据导入数据库。建议只执行第二行指令即可。）
```sh
$ docker build ./postgresql/ -t postgresql
$ docker build ./postgresql-loaded/ -t postgresql-loaded
```
## Docker-compose Docker集成
* docker-compose is configured by default to work with postgresql:loaded 在docker-compose.yml中，postgresql:loaded是默认的image。如果选用postgresql，请将名字进行修改。
* CKAN_SITE_URL needs to be set to the correct ip/domain 在docker-compose.yml文件中，需要将“ CKAN_SITE_URL”的值改成自己的ip地址。

## First execution 第一次运行
CKAN is expecting to connect directly to the database. In the case of the preloaded image this is not possible since postgresql needs to execute *.sql scripts, so it is recommended to first run the database, and when the databases are ready, start ckan. 数据库导入需要一些时间，所以要先docker-compose其他image，之后再集成ckan。
```sh
$ docker-compose up -d pusher redis solr db
$ docker-compose up ckan
```

## Run 运行
Execute the docker-compose file. 当再次运行docker-compose文件时，可直接执行以下指令
```sh
$ docker-compose up
```

## Default credentials 默认管理员用户名密码
```
ckan = admin:admin
db = ckan:ckan
```

## Useful Commands 实用指令
### [CKAN] Create user or admin account 创建用户或管理员账号
User accounts and admin accounts can be created with paster command. 用户和管理员可以通过以下指令创建。
```sh
# Go inside the container 进入container
$ docker exec -ti ckan bash

# Create new user 创建新用户
$ ckan-paster --plugin=ckan user -c $CKAN_CONFIG/ckan.ini add username [ email=username@email.com password=password ]

# Create new admin 创建管理员
$ ckan-paster --plugin=ckan sysadmin -c $CKAN_CONFIG/ckan.ini add username [ email=username@email.com password=password ]
```
Either by going inside the cointainer ckan, or running it with a modified entrypoint. 既可以通过进入container内部，也可以通过自定义的entrypoint进行操作。
### [CKAN] Rebuild index 重建索引
Rebuild the index to make search engine match the current dataset. 重建索引，使搜索引擎和数据库匹配。
```sh
$ ckan-paster --plugin=ckan search-index rebuild -c $CKAN_CONFIG/ckan.ini
```