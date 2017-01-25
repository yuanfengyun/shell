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
    done

    return 0
}

function cmd_shutdown(){
    find_one_service monitor
    echo "call ${addr} 'shutdown'" >&5
    read -t 5 line
    echo $line
}


function cmd_update_res(){
    find_one_service share
    echo "call ${addr} 'sharedata_update','resources'" >&5
    sleep 2.0
    echo "clearcache" >&5
}

function cmd_agent(){
    echo "clearcache" >&5
    find_one_service "login"
    echo "login addr: $addr"
    echo "inject ${addr} test/robot/preset/clear_agent_pool.lua" >&5
}

function select_cmd(){
    local cmd
    select cmd in shutdown update_res agent
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
            agent)
                cmd_agent
                break
                ;;
            *)
                ;;
        esac
    done
}

connect
if [ -z $cmd ]; then
    select_cmd
else
    $cmd
fi
