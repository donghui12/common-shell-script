#!/bin/bash

# 查看所有 test 开头 name 的服务状态
services_name=$(docker ps --filter "name=test-*" --format "{{.Names}}")
