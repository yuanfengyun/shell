#/bin/bash
# 热更新程序，shell版

cmd=$1
ip=$2
port=$3

ip=${ip:=127.0.0.1}
port=${port:=8000}
addr=

function connect(){
    exec 5<>/dev/tcp/$ip/$port
    local d
    read -t5 d <&5
    echo $d
}

# 根据服务启动参数找到服务地址
function find_one_service(){
    local name
    local line
    echo "list" >&5
    while read -t3 line <&5 ; do
        name=`echo $line | cut -d' ' -f3`
        if [ "$name"x = "$1"x ]; then
            addr=`echo $line | cut -d' ' -f1`
            break
        fi

        if [ "$line"x = "<CMD OK>"x ]; then
            break
        fi
    done

    return 0
}

function find_all_service(){
    service_list=()

    local name
    local line
    echo "list" >&5
    local i=0
    declare -i i
    while read -t3 line <&5 ; do
        name=`echo $line | cut -d' ' -f3`
        if [ "$name"x = "$1"x ]; then
            service_list[i]=`echo $line | cut -d' ' -f1`
            i=i+1
        fi

        if [ "$line"x = "<CMD OK>"x ]; then
            break
        fi
    done

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
            echo -e "\033[30m错误：根据服务注册名获取服务地址失败: $1 \033[0m"
            break
        fi

        name=`echo $line | cut -d' ' -f1`
        echo "$name"
        if [ "$name"x = "$1"x ] || [ "$name"x = "@$1"x ]; then
            addr=`echo $line | cut -d' ' -f2`
            break
        fi
    done

    return 0
}

# 向monitor服务发送shutdown指令
function cmd_shutdown(){
    find_one_service monitor
    echo "call ${addr} 'shutdown'" >&5
    read -t 5 line
    echo $line
}

# 向.share服务发送sharedata_update指令
function cmd_update_res(){
    find_one_service share
    echo "call ${addr} 'sharedata_update','resources'" >&5
    sleep 2.0
    echo "clearcache" >&5
}

# 更新指定服务名的服务的指定模块
function cmd_update_named_service_module(){
    echo "pass"
}

# 清除agent_pool，下线再上线以后,agent会使用最新的代码
function cmd_clear_agent_pool(){
    echo "clearcache" >&5
    find_one_service "login"
    echo "login addr: $addr"
    echo "inject ${addr} test/robot/preset/clear_agent_pool.lua" >&5
}

# 更新agent,player目录下模块
function cmd_update_agent_submodule(){
    local line
    echo "clearcache" >&5
    read -t5 line
    local module_name=$1
    find_all_service "agent"

    echo ${service_list[*]}
    for addr in ${service_list[*]}; do
        echo "call ${addr} 'hotfix_submodule','${module_name}'" >&5
        while read -t5 line; do
            echo $line
        done
    done
}

# 更新agent,service目录下模块
function cmd_update_agent_service(){
    local line
    echo "clearcache" >&5
    read -t5 line
    local service_name=$1
    find_all_service "agent"

    echo ${service_list[*]}
    for addr in ${service_list[*]}; do
        echo "call ${addr} 'hotfix_service','${service_name}'" >&5
        while read -t5 line; do
            echo $line
        done
    done
}


function select_cmd(){
    local cmd
    select cmd in shutdown update_res clear_agent_pool update_agent_submodule update_agent_service
    do
        case $cmd in
            shutdown)
                cmd_shutdown
                break
                ;;
            update_res)
                cmd_update_res
                break
                ;;
            clear_agent_pool)
                cmd_clear_agent_pool
                break
                ;;
            update_agent_submodule)
                echo -n "please input submodule name: "
                local module
                read module
                cmd_update_agent_submodule $module
                break
                ;;
            update_agent_service)
                echo -n "please input service name: "
                local service
                read service
                cmd_update_agent_service $service
                break
                ;;
            *)
                ;;
        esac
    done
}

connect
select_cmd
