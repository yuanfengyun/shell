#/bin/bash
# 热更新程序，shell版

ip=$1
port=$2

ip=${ip:=127.0.0.1}
port=${port:=8000}
# 全局变量，存放服务地址
addr=
# 全局变量，存放服务地址数组
service_list=()

# 连接debug_console端口
function connect(){
    exec 5<>/dev/tcp/$ip/$port
    if (( $? != 0 )); then
        return 1
    fi
    local welcome
    read -t5 welcome <&5
    if [ -z welcome ]; then
        close_socket
        return 1
    fi
    echo $welcome
    return 0
}

# 关闭socket连接
function close_socket(){
    exec 5<&-   # 关闭socket读
    exec 5>&-   # 关闭socket写
}

function error_msg(){
    local msg=$1
    echo -e "\033[31m错误: ${msg} \033[0m"
}

# 根据服务启动参数找到服务地址
function find_one_service(){
    addr=
    local name
    local line
    echo "list" >&5
    while read -t5 line <&5 ; do
        name=`echo $line | cut -d' ' -f3`
        if [ -z addr ] || [ "$name"x = "$1"x ]; then
            addr=`echo $line | cut -d' ' -f1`
        fi

        if [ "$line"x = "<CMD OK>"x ]; then
            break
        fi
    done

    if [ -z line ]; then
        error_msg "根据启动参数$1查找单个服务失败"
        return 1
    fi

    return 0
}

# 根据服务启动参数获取所有服务，例agent获取所有agent服务地址数组
function find_all_service(){
    service_list=()

    local name
    local line
    echo "list" >&5
    local i=0
    declare -i i
    while read -t5 line <&5 ; do
        name=`echo $line | cut -d' ' -f3`
        if [ "$name"x = "$1"x ]; then
            service_list[i]=`echo $line | cut -d' ' -f1`
            i=i+1
        fi

        if [ "$line"x = "<CMD OK>"x ]; then
            break
        fi
    done

    if [ -z line ]; then
        error_msg "根据启动参数$1查找所有服务失败"
        return 1
    fi

    return 0
}

#根据服务注册名找到服务地址
function find_service_by_name(){
    addr=
    local name
    local line
    echo "service" >&5
    while read -t3 line <&5 ; do
        # 列表结束
        if [ "$line"x = "<CMD OK>"x ]; then
            break
        fi

        # 已经找到了服务，不再比较
        if [ -n addr ]; then
            continue
        fi

        name=`echo $line | cut -d' ' -f1`
        echo "$name"
        if [ "$name"x = "$1"x ] || [ "$name"x = "@$1"x ]; then
            addr=`echo $line | cut -d' ' -f2`
        fi
    done

    if [ -z addr ]; then
        error_msg "根据服务注册名$1获取服务地址失败!"
        return 1
    fi

    return 0
}

# 向monitor服务发送shutdown指令
function cmd_shutdown(){
    find_one_service monitor
    if [ -z addr ]; then
        error_msg "关服失败：找不到monitor服务地址"
        return 1
    fi

    echo "call ${addr} 'shutdown',$1" >&5
    local line
    while read -t 20 line <&5; do
        echo $line
        if [ "$line"x = "<CMD OK>"x ]; then
            break
        fi
    done

    if [ "$line"x != "<CMD OK>"x ]; then
        error_msg "等待停机命令返回超时(命令可能执行失败)"
        return 1
    fi

    return 0
}

# 取消关服
function cmd_cancel_shutdown(){
    find_one_service monitor

    if [ -z addr ]; then
        error_msg "取消关服失败：找不到monitor服务地址"
        return 1
    fi

    echo "call ${addr} 'shutdown_cancel'" >&5
    local line

    while read -t 20 line <&5; do
        echo $line
        if [ "$line"x = "<CMD OK>"x ]; then
            break
        fi
    done

    if [ "$line"x != "<CMD OK>"x ]; then
        error_msg "等待取消停机命令返回超时(命令可能执行失败)"
        return 1
    fi

    return 0
}

# 向.share服务发送sharedata_update指令
function cmd_update_res(){
    find_one_service share

    if [ -z addr ]; then
        error_msg "更新配置文件失败：找不到share服务地址"
        return 1
    fi

    echo "call ${addr} 'sharedata_update','resources'" >&5

    local line
    while read -t 10 line <&5; do
        echo $line
        if [ "$line"x = "<CMD OK>"x ]; then
            break
        fi
    done

    echo "clearcache" >&5
    read -t 5 line

    return 0
}

# 更新指定服务名的服务的指定模块
function cmd_update_named_service_module(){
    echo "pass"
}

# 清除agent_pool，下线再上线以后,agent会使用最新的代码
function cmd_clear_agent_pool(){
    local line
    echo "clearcache" >&5
    read -t 10 line <&5
    find_one_service "login"
    echo "inject ${addr} test/robot/preset/clear_agent_pool.lua" >&5

    while read -t 10 line <&5; do
        echo $line
        if [ "$line"x = "<CMD OK>"x ]; then
            break
        fi
    done
}

# 更新agent,player目录下模块
function cmd_update_agent_submodule(){
    local line
    echo "clearcache" >&5
    read -t5 line <&5
    local module_name=$1
    find_all_service "agent"

    for addr in ${service_list[*]}; do
        echo "call ${addr} 'hotfix_submodule','${module_name}'" >&5
        while read -t 10 line <&5; do
            if [ "$line"x = "<CMD OK>"x ]; then
                echo "${addr}: success"
                break
            fi
        done
    done
}

# 更新agent,service目录下模块
function cmd_update_agent_service(){
    local line
    echo "clearcache" >&5
    read -t5 line <&5
    local service_name=$1
    find_all_service "agent"

    for addr in ${service_list[*]}; do
        echo "call ${addr} 'hotfix_service','${service_name}'" >&5
        while read -t 10 line <&5; do
            if [ "$line"x = "<CMD OK>"x ]; then
                echo "${addr}: success"
                break
            fi
        done
    done
}

# 更新agent,quest_mgr模块
function cmd_update_agent_quest_mgr(){
    local line
    echo "clearcache" >&5
    read -t5 line <&5
    local service_name=$1
    find_all_service "agent"

    for addr in ${service_list[*]}; do
        echo "call ${addr} 'hotfix_quest_mgr'" >&5
        while read -t 10 line <&5; do
            if [ "$line"x = "<CMD OK>"x ]; then
                echo "${addr}: success"
                break
            fi
        done
    done
}

# 更新agent,quest_mgr模块
function cmd_update_agent_scene_mgr(){
    local line
    echo "clearcache" >&5
    read -t5 line <&5
    local service_name=$1
    find_all_service "agent"

    for addr in ${service_list[*]}; do
        echo "call ${addr} 'hotfix_scene_mgr'" >&5
        while read -t 10 line <&5; do
            if [ "$line"x = "<CMD OK>"x ]; then
                echo "${addr}: success"
                break
            fi
        done
    done
}

function select_cmd(){
    selection=()
    selection[0]=立即关服
    selection[1]=延迟60秒关服
    selection[2]=取消关服
    selection[3]=更新配置文件
    selection[4]=清除agent_pool
    selection[5]=更新agent子模块
    selection[6]=更新agent网络子模块
    selection[7]=更新agent任务模块
    selection[8]=更新agent场景模块
    selection[9]=退出
    local cmd
    select cmd in ${selection[*]}
    do
        case $cmd in
            立即关服)
                cmd_shutdown 5
                break
                ;;
            延迟60秒关服)
                cmd_shutdown 60
                break
                ;;
            取消关服)
                cmd_cancel_shutdown
                break
                ;;
            更新配置文件)
                cmd_update_res
                break
                ;;
            清除agent_pool)
                cmd_clear_agent_pool
                break
                ;;
            更新agent子模块)
                echo -n "please input submodule name: "
                local module
                read module
                cmd_update_agent_submodule $module
                break
                ;;
            更新agent网络子模块)
                echo -n "please input service name: "
                local service
                read service
                cmd_update_agent_service $service
                break
                ;;
            更新agent任务模块)
                cmd_update_agent_quest_mgr
                break
                ;;
            更新agent场景模块)
                cmd_update_agent_scene_mgr
                break
                ;;
            退出)
                break
                ;;
            *)
                echo "wrong option!!!"
                ;;
        esac
    done
}

function main(){
    connect
    if [ $? -ne 0 ]; then
        error_msg "连接${ip}:${port}失败"
        return 1
    fi

    select_cmd
    close_socket
}

main
