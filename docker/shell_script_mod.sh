#!/bin/sh



function diycron(){
    for jsname in /scripts/ddo_*.js /scripts/jd_*.js /scripts/long_*.js; do
        jsnamecron="$(cat $jsname | grep -oE "/?/?cron \".*\"" | cut -d\" -f2)"
        test -z "$jsnamecron" || echo "$jsnamecron node $jsname >> /scripts/logs/$(echo $jsname | cut -d/ -f3).log 2>&1" >> /scripts/docker/merged_list_file.sh
    done
    # 启用京价保
    echo "40 9 1/3 * * node /scripts/jd_price.js >> /scripts/logs/jd_price.log 2>&1" >> /scripts/docker/merged_list_file.sh
    # 修改docker_entrypoint.sh执行频率
    ln -sf /usr/local/bin/docker_entrypoint.sh /usr/local/bin/docker_entrypoint_mix.sh
    echo "18,38,58 */1 * * * docker_entrypoint_mix.sh >> /scripts/logs/default_task.log 2>&1" >> /scripts/docker/merged_list_file.sh
   
    # 京喜财富岛提现
    echo "59 23 * * * sleep 59; node /scripts/jx_cfdtx.js >> /scripts/logs/jx_cfdtx.log 2>&1" >> /scripts/docker/merged_list_file.sh
    
    echo "0 10 * * * node /scripts/jd_qmwxj.js >> /scripts/logs/jd_qmwxj.log 2>&1" >> /scripts/docker/merged_list_file.sh
    
}

function jd_diy(){
    ## 克隆jd_diy仓库
    if [ ! -d "/jd_diy/" ]; then
        echo "未检查到克隆jd_diy仓库，初始化下载相关脚本..."
        git clone -b lxk0301_shell https://github.com/l107868382/dd_diy.git /jd_diy
    else
        echo "更新jd_diy脚本相关文件..."
        git -C /jd_diy reset --hard
        git -C /jd_diy pull origin lxk0301_shell --rebase
    fi
    cp -f /scripts/logs/jdJxncTokens.js /scripts
    cp -f /jd_diy/scripts/*.js /scripts
    cp -f /jd_diy/docker/crontab_list.sh /scripts/docker
}



function hyzaw_diy(){
    ## 克隆hyzawr仓库
    if [ ! -d "/hyzaw/" ]; then
        echo "未检查到hyzaw仓库脚本，初始化下载相关脚本..."
        #git clone -b monk https://github.com/l107868382/dd_syc.git /monk
        git clone -b main https://github.com/hyzaw/scripts.git /hyzaw
        
    else
        echo "更新hyzawr脚本相关文件..."
        git -C /hyzaw reset --hard
        git -C /hyzaw pull origin main --rebase
    fi
    cp -f /hyzaw/*_*.js /scripts
}

function jddj_diy(){
    ## 克隆jddj_diy仓库
    if [ ! -d "/jddj_diy/" ]; then
        echo "未检查到克隆jddj_diy仓库，初始化下载相关脚本..."
        git clone -b main https://github.com/717785320/JDDJ.git /jddj_diy
    else
        echo "更新jddj_diy脚本相关文件..."
        git -C /jddj_diy reset --hard
        git -C /jddj_diy pull origin main --rebase
    fi  
       #rm -rf /jddj_diy/sendNotify.js
       cp -f /jddj_diy/jddj_*.js /scripts
       cp -f /scripts/logs/jddj_cookie.js /scripts
}

# 下载龙猪猪 红包雨脚本
function longzhuzhu_diy(){
    if [ ! -d "/longzhuzhu/" ]; then
        echo "未检查到longzhuzhu仓库脚本，初始化下载相关脚本..."
        git clone -b main https://github.com/longzhuzhu/nianyu.git /longzhuzhu
    else
        echo "更新longzhuzhu脚本相关文件..."
        git -C /longzhuzhu reset --hard
        git -C /longzhuzhu pull origin main --rebase
    fi
    cp -f /longzhuzhu/qx/*_*.js /scripts
}

# yangtingxiao jd_zoo
function yangtingxiao_diy(){
    if [ ! -d "/yangtingxiao/" ]; then
        echo "未检查到yangtingxiao仓库脚本，初始化下载相关脚本..."
        git clone -b master https://github.com/yangtingxiao/QuantumultX.git /yangtingxiao
    else
        echo "更新yangtingxiao脚本相关文件..."
        git -C /yangtingxiao reset --hard
        git -C /yangtingxiao pull origin master --rebase
    fi
    cp -f /yangtingxiao/scripts/jd/jd_zoo.js /scripts
    
    # 动物联萌 618活动
    echo "5 * * * * node /scripts/jd_zoo.js >> /scripts/logs/jd_zoo.js.log 2>&1" >> /scripts/docker/merged_list_file.sh
}


# wuzhi_diy
function wuzhi_diy(){
    if [ ! -d "/wuzhi/" ]; then
        echo "未检查到wuzhi仓库脚本，初始化下载相关脚本..."
        git clone -b main https://github.com/wuzhi04/MyActions.git /wuzhi
    else
        echo "更新wuzhi脚本相关文件..."
        git -C /wuzhi reset --hard
        git -C /wuzhi pull origin main --rebase
    fi
    cp -f /wuzhi/jd_zoo.js /wuzhi/jd_zooCollect.js /wuzhi/ZooFaker.js /scripts
}

# zooPanda
function zooPanda_diy(){
    if [ ! -d "/zooPanda/" ]; then
        echo "未检查到zooPanda仓库脚本，初始化下载相关脚本..."
        git clone -b dev https://github.com/zooPanda/zoo.git /zooPanda
    else
        echo "更新zooPanda脚本相关文件..."
        git -C /zooPanda reset --hard
        git -C /zooPanda pull origin dev --rebase
    fi
    cp -f /zooPanda/zoo*.js /scripts
    echo "15 9 9-20 6 * node /scripts/zooOpencard06.js >> /scripts/logs/zooOpencard06.log 2>&1" >> /scripts/docker/merged_list_file.sh
    echo "11 9 1-18 6 * node /scripts/zooOpencard07.js >> /scripts/logs/zooOpencard07.log 2>&1" >> /scripts/docker/merged_list_file.sh
    echo "11 9 1-18 6 * node /scripts/zooOpencard08.js >> /scripts/logs/zooOpencard08.log 2>&1" >> /scripts/docker/merged_list_file.sh
    echo "11 10 * * * node /scripts/zooElecsport.js >> /scripts/logs/zooElecsport.log 2>&1" >> /scripts/docker/merged_list_file.sh
    
}

# 京喜牧场
function moposmall_diy(){
     if [ ! -d "/moposmall/" ]; then
        echo "未检查到moposmall仓库脚本，初始化下载相关脚本..."
        git clone -b main https://github.com/moposmall/Script.git /moposmall
    else
        echo "更新moposmall脚本相关文件..."
        git -C /moposmall reset --hard
        git -C /moposmall pull origin main --rebase
    fi
    cp -f /moposmall/Me/jx_mc.js /scripts
    
    # 京喜牧场
    echo "10 0,12,22 * * * node /scripts/jx_mc.js >> /scripts/logs/jx_mc.log 2>&1" >> /scripts/docker/merged_list_file.sh
}

# star261
function star261_diy(){
     if [ ! -d "/star261/" ]; then
        echo "未检查到star261仓库脚本，初始化下载相关脚本..."
        git clone -b main https://github.com/star261/jd.git /star261
    else
        echo "更新star261脚本相关文件..."
        git -C /star261 reset --hard
        git -C /star261 pull origin main --rebase
    fi
    cp -f /star261/scripts/*.js /scripts

}


# 删除和lxk重复的脚本
function removeJs(){
    rm -rf /scripts/ddo_joy_reward.js
}

# 替换
function otherreplace(){
    echo " otherreplace "
    # 注释掉 lxk jd_xtg的启动时间,新建启动时间
    sed -i "s/jd_xtg.js/jd_xtg_bak.js/g" /scripts/docker/merged_list_file.sh
    #echo "0 6 * * * node /scripts/jd_xtg.js >> /scripts/logs/jd_xtg.log 2>&1" >> /scripts/docker/merged_list_file.sh
    sed -i "s/jd_xtg_help.js/jd_xtg_help_bak.js/g" /scripts/docker/merged_list_file.sh
    sed -i "s/https:\/\/cdn.jsdelivr.net\/gh\/gitupdate\/updateTeam@master\/shareCodes\/jxhb.json/https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/l107868382\/sharcode\/main\/v1\/jxhb.json/g" /scripts/jd_jxlhb.js
    
    
    #echo "0 6 * * * node /scripts/jd_xtg_help.js >> /scripts/logs/jd_xtg_help.log 2>&1" >> /scripts/docker/merged_list_file.sh
    # 替换 超级直播间红包雨
    #sed -i "s/jd_live_redrain.js/jd_live_redrain_bak.js/g" /scripts/docker/merged_list_file.sh
    #echo "1,31 0-23/1 * * * sleep 15; node /scripts/jd_live_redrain.js >> /scripts/logs/jd_live_redrain.log 2>&1" >> /scripts/docker/merged_list_file.sh
    
    # 重新设置手机狂欢城的启动时间---
    sed -i "s/jd_carnivalcity.js/jd_carnivalcity_bak.js/g" /scripts/docker/merged_list_file.sh
    sed -i "s/jd_zoo.js/jd_zoo_bak.js/g" /scripts/docker/merged_list_file.sh
    sed -i "s/jd_zooCollect.js/jd_zooCollect_bak.js/g" /scripts/docker/merged_list_file.sh
    sed -i "s/jd_star_shop.js/jd_star_shop_bak.js/g" /scripts/docker/merged_list_file.sh
    sed -i "s/jd_mcxhd.js/jd_mcxhd_bak.js/g" /scripts/docker/merged_list_file.sh
    
    # echo "28 0,12,18,21 * * * node /scripts/jd_carnivalcity.js >> /scripts/logs/jd_carnivalcity.log 2>&1" >> /scripts/docker/merged_list_file.sh
    # sed -i "s/inviteCodes\[tempIndex\].split('@')/[]/g" /scripts/jd_city.js
    # sed -i "s/http:\/\/share.turinglabs.net\/api\/v3\/city\/query\/10\//https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/l107868382\/sharcode\/main\/v1\/jd_city.json/g" /scripts/jd_city.js

    
}





# 下载lxk 备份
function lxk_diy(){
    if [ ! -d "/lxk/" ]; then
        echo "未检查到lxk仓库脚本，初始化下载相关脚本..."
        git clone -b dd https://github.com/l107868382/ddnaichai.git /lxk
    else
        echo "更新lxk脚本相关文件..."
        git -C /lxk reset --hard
        git -C /lxk pull origin dd --rebase
    fi
    cp -f /lxk/*_*.js /scripts
}

function main(){
    #lxk_diy
    wuzhi_diy
    longzhuzhu_diy
    zooPanda_diy
    star261_diy
    #hyzaw_diy
    #moposmall_diy
    
    # 判断外网IP,运行自己的代码
    curl icanhazip.com > ./ipstr.txt
    iptxt=$(tail -1 ./ipstr.txt)
    ipbd="43.129"
    result=$(echo $iptxt | grep "${ipbd}")
    if [[ "$result" != "" ]]
    then
      echo "l107服务器，执行性化代码--------------------------------------------------------"
      # 自己diy代码
      jd_diy
      # 京东到家
      jddj_diy
    else
      echo "非l107服务器，不执行个性化代码---------------------------------------------------"
    fi    
    removeJs
    diycron
    otherreplace
}

main

## 拷贝京东超市兑换脚本
#cp -f /scripts/jd_blueCoin.js /scripts/l_jd_bluecoin.js
# cat /jd_diy/remote_crontab_list.sh >> /scripts/docker/merged_list_file.sh

