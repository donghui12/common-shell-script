#!/bin/bash

image=""

# 处理命令行参数
function process_args {
    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            --image)
                image="$2"
                shift  # 跳过参数值
                ;;
            --help)
                show_help
                ;;
            *)
                echo "Invalid option: $key" >&2
                show_help
                ;;
        esac
        shift  # 移动到下一个参数
    done

    # 检查是否提供了必要参数
    if [ -z "$image" ]; then
        echo "Error: --image is required." >&2
        show_help
    fi
}

# 显示帮助信息
function show_help {
    echo "Usage: $0 [--image IMAGE]"
    echo ""
    echo "This script is used to build a multi-architecture Docker image."    
    echo ""
    echo "Options:"
    echo "  --image    Specify image"
    echo "  --help     Display this help message."

    exit 0
}

# 拉取 Docker 镜像
function pull_images {
    # 检查镜像是否已存在
    if ! docker image inspect "$image-amd64" &>/dev/null; then
        docker pull "$image-amd64"
    else
        echo "Image $image-amd64 already exists. Skipping pull."
    fi

    if ! docker image inspect "$image-arm64" &>/dev/null; then
        docker pull "$image-arm64"
    else
        echo "Image $image-arm64 already exists. Skipping pull."
    fi
}

# 创建 Docker manifest
function create_manifest {
    docker manifest create "$image" "$image-arm64" "$image-amd64"
}

# 添加 Docker manifest 注释
function annotate_manifest {
    docker manifest annotate "$image" "$image-amd64" --os linux --arch amd64
    docker manifest annotate "$image" "$image-arm64" --os linux --arch arm64
}

# 推送 Docker manifest
function push_manifest {
    docker manifest push "$image"
}

# 处理命令行参数
process_args "$@"

# 拉取 Docker 镜像
pull_images

# 创建 Docker manifest
create_manifest

# 添加 Docker manifest 注释
annotate_manifest

# 推送 Docker manifest
push_manifest
