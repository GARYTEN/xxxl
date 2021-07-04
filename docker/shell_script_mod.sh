#!/bin/sh

function diycron(){
    for jsname in /scripts/jddj_*.js /scripts/long_*.js; do
        jsnamecron="$(cat $jsname | grep -oE "/?/?cron \".*\"" | cut -d\" -f2)"
        test -z "$jsnamecron" || echo "$jsnamecron node $jsname >> /scripts/logs/$(echo $jsname | cut -d/ -f3).log 2>&1" >> /scripts/docker/merged_list_file.sh
    done
    
    # 修改docker_entrypoint.sh执行频率
    ln -sf /usr/local/bin/docker_entrypoint.sh /usr/local/bin/docker_entrypoint_mix.sh
    echo "18,48 */1 * * * docker_entrypoint_mix.sh >> /scripts/logs/default_task.log 2>&1" >> /scripts/docker/merged_list_file.sh
    # 京喜财富岛提现
    echo "59 23 * * * sleep 59; node /scripts/jx_cfdtx.js >> /scripts/logs/jx_cfdtx.log 2>&1" >> /scripts/docker/merged_list_file.sh
    #收集助力码
    echo "30 * * * * sh +x /scripts/docker/auto_help.sh collect |ts >> /scripts/logs/auto_help_collect.log 2>&1" >> /scripts/docker/merged_list_file.sh
    #东东工厂修改执行频率
    echo "*/43 * * * * node /scripts/jd_jdfactory.js >> /scripts/logs/jd_jdfactory.log 2>&1" >> /scripts/docker/merged_list_file.sh
    
}


function jd_diy(){
    cp -f /scripts/logs/jdJxncTokens.js /scripts
    cp -f /jd_diy/scripts/*.js /scripts
    
    cat /dev/null > /scripts/docker/auto_help.sh
    cat /jd_diy/shell/auto_help.sh >> /scripts/docker/auto_help.sh
}



function jddj_diy(){
    ## 克隆jddj_diy仓库
    if [ ! -d "/jddj_diy/" ]; then
        echo "未检查到克隆jddj_diy仓库，初始化下载相关脚本..."
        git clone -b main https://ghproxy.com/https://github.com/717785320/JDDJ.git /jddj_diy
    else
        echo "更新jddj_diy脚本相关文件..."
        git -C /jddj_diy reset --hard
        git -C /jddj_diy pull origin main --rebase
    fi  
    cp -f /jddj_diy/jddj_*.js /scripts
}

function didi_diy(){
    ## 克隆jddj_diy仓库
    if [ ! -d "/didi_diy/" ]; then
        echo "未检查到克隆didi_diy仓库，初始化下载相关脚本..."
        git clone -b main https://github.com/passerby-b/didi_fruit.git /didi_diy
    else
        echo "更新didi_diy脚本相关文件..."
        git -C /didi_diy reset --hard
        git -C /didi_diy pull origin main --rebase
    fi  
       #rm -rf /jddj_diy/sendNotify.js
       cp -f /didi_diy/dd_*.js /scripts
       
       #滴滴果园
       echo "10 0,8,12,18 * * * node /scripts/dd_fruit.js >> /scripts/logs/dd_fruit.js.log 2>&1" >> /scripts/docker/merged_list_file.sh
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


function panghu_diy(){
    ## 克隆panghu999仓库
    if [ ! -d "/panghu_diy/" ]; then
        echo "未检查到克隆panghu_diy仓库，初始化下载相关脚本..."
        git clone -b master https://gitee.com/l107868382/panghu.git /panghu_diy
    else
        echo "更新hyzaw脚本相关文件..."
        git -C /panghu_diy reset --hard
        git -C /panghu_diy pull origin master --rebase
    fi  
       cp -f /panghu_diy/jd_qmwxj.js /panghu_diy/jd_wsdlb.js /panghu_diy/jd_zjb.js /panghu_diy/jd_hwsx.js /panghu_diy/jd_ppdz.js /panghu_diy/jd_tyt.js /scripts
       echo "0 10 * * * node /scripts/jd_qmwxj.js >> /scripts/logs/jd_qmwxj.log 2>&1" >> /scripts/docker/merged_list_file.sh
       echo "5 0-23/6 * * * node /scripts/jd_wsdlb.js >> /scripts/logs/jd_wsdlb.log 2>&1" >> /scripts/docker/merged_list_file.sh
       echo "0 5 * * * node /scripts/jd_zjb.js >> /scripts/logs/jd_zjb.log 2>&1" >> /scripts/docker/merged_list_file.sh
       echo "20 12,14 * * * node /scripts/jd_hwsx.js >> /scripts/logs/jd_hwsx.log 2>&1" >> /scripts/docker/merged_list_file.sh
       echo "1 0 * * * node /scripts/jd_ppdz.js >> /scripts/logs/jd_ppdz.log 2>&1" >> /scripts/docker/merged_list_file.sh
}




function panghu999_jd_diy(){
    ## 克隆panghu999仓库
    if [ ! -d "/panghu999_jd_diy/" ]; then
        echo "未检查到克隆panghu999_jd_diy仓库，初始化下载相关脚本..."
        git clone -b master https://ghproxy.com/https://github.com/panghu999/jd_scripts.git /panghu999_jd_diy
    else
        echo "更新hyzaw脚本相关文件..."
        git -C /panghu999_jd_diy reset --hard
        git -C /panghu999_jd_diy pull origin master --rebase
    fi  
       cp -f /panghu999_jd_diy/jd_jdfactory.js /scripts
       sed -i "s/P04z54XCjVWnYaS5u2ak7ZCdan1Bdd2GGiWvC6_uERj/T026aHXGlb6y6IJ_j8x-NCGt4d06TgCjVWnYaS5kRrbA/g" /scripts/jd_jdfactory.js
       sed -i "s/P04z54XCjVWnYaS5m9cZ2ariXVJwHf0bgkG7Uo/T0225KkcR0of9wLfJRKikvIPJQCjVWnYaS5kRrbA/g" /scripts/jd_jdfactory.js
}


# wuzhi_diy
function wuzhi_diy(){
    if [ ! -d "/wuzhi/" ]; then
        echo "未检查到wuzhi仓库脚本，初始化下载相关脚本..."
        git clone -b main https://ghproxy.com/https://github.com/wuzhi04/MyActions.git /wuzhi
    else
        echo "更新wuzhi脚本相关文件..."
        git -C /wuzhi reset --hard
        git -C /wuzhi pull origin main --rebase
    fi
    cp -f /wuzhi/*.js /scripts
    cat /dev/null > /scripts/docker/merged_list_file.sh
    cat /wuzhi/docker/crontab_list.sh >> /scripts/docker/merged_list_file.sh
    sed -i "s/jx_cfdtx.js/jx_cfdtx_bak.js/g" /scripts/docker/merged_list_file.sh
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
    cp -f /moposmall/Me/jx_*.js /scripts
    
    # 京喜牧场
    echo "10 0,12,22 * * * node /scripts/jx_mc.js >> /scripts/logs/jx_mc.log 2>&1" >> /scripts/docker/merged_list_file.sh
    echo "10 * * * * node /scripts/jx_mc_coin.js >> /scripts/logs/jx_mc_coin.log 2>&1" >> /scripts/docker/merged_list_file.sh
}

# Wenmoux_diy
function Wenmoux_diy(){
    if [ ! -d "/Wenmoux/" ]; then
        echo "未检查到wuzhi仓库脚本，初始化下载相关脚本..."
        git clone -b master https://ghproxy.com/https://github.com/DovFork/Wenmoux.git /Wenmoux
    else
        echo "更新wuzhi脚本相关文件..."
        git -C /Wenmoux reset --hard
        git -C /Wenmoux pull origin master --rebase
    fi
    cp -f /Wenmoux/jd/*.js /scripts
    echo "1 0-23/2 * * * node /scripts/jd_qqxing.js >> /scripts/logs/jd_qqxing.log 2>&1" >> /scripts/docker/merged_list_file.sh
    echo "59 9 * * * node /scripts/jd_europeancup.js >> /scripts/logs/jd_europeancup.log 2>&1" >> /scripts/docker/merged_list_file.sh
    echo "28 7 * * * node /scripts/jd_SplitRedPacket.js >> /scripts/logs/jd_SplitRedPacket.log 2>&1" >> /scripts/docker/merged_list_file.sh
    echo "25 7 * * * node /scripts/jd_ddnc_farmpark.js >> /scripts/logs/jd_ddnc_farmpark.log 2>&1" >> /scripts/docker/merged_list_file.sh
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
    cp -f /star261/scripts/*_*.js /scripts
    
     echo "10 1,13,21 * * * node /scripts/jd_jxmc.js >> /scripts/logs/jd_jxmc.log 2>&1" >> /scripts/docker/merged_list_file.sh

}



# 替换
function otherreplace(){
    echo " otherreplace "
    # 注释掉 lxk jd_xtg的启动时间,新建启动时间
    sed -i "s/jd_xtg.js/jd_xtg_bak.js/g" /scripts/docker/merged_list_file.sh
    sed -i "s/https:\/\/wuzhi03.coding.net\/p\/dj\/d\/RandomShareCode\/git\/raw\/main\/JD_Fruit.json/https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/l107868382\/sharcode\/main\/v1\/JD_Fruit.json/g" /scripts/jd_fruit.js
    sed -i "s/let helpAuthor = true/let helpAuthor = false/g" /scripts/jd_fruit.js
    sed -i "s/https:\/\/wuzhi03.coding.net\/p\/dj\/d\/RandomShareCode\/git\/raw\/main\/JD_Cash.json/https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/GARYTEN2\/xxxl\/sharecode\/shareCodes\/JD_Cash.json/g" /scripts/jd_cash.js
    sed -i "s/https:\/\/wuzhi03.coding.net\/p\/dj\/d\/shareCodes\/git\/raw\/main\/jd_updateCash.json/https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/GARYTEN2\/xxxl\/sharecode\/shareCodes\/jd_updateCash.json/g" /scripts/jd_cash.js
    sed -i "s/https:\/\/wuzhi03.coding.net\/p\/dj\/d\/RandomShareCode\/git\/raw\/main\/JD_Dream_Factory.json/https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/GARYTEN2\/xxxl\/sharecode\/shareCodes\/JD_Dream_Factory.json/g" /scripts/jd_dreamFactory.js
    sed -i "s/https:\/\/wuzhi03.coding.net\/p\/dj\/d\/RandomShareCode\/git\/raw\/main\/JD_Health.json/https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/GARYTEN2\/xxxl\/sharecode\/shareCodes\/JD_Health.json/g" /scripts/jd_health.js
    sed -i "s/https:\/\/wuzhi03.coding.net\/p\/dj\/d\/RandomShareCode\/git\/raw\/main\/JD_Plant_Bean.json/https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/GARYTEN2\/xxxl\/sharecode\/shareCodes\/JD_Plant_Bean.json/g" /scripts/jd_plantBean.js
    sed -i "s/https:\/\/wuzhi03.coding.net\/p\/dj\/d\/RandomShareCode\/git\/raw\/main\/JD_Pet.json/https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/GARYTEN2\/xxxl\/sharecode\/shareCodes\/JD_Pet.json/g" /scripts/jd_pet.js
    sed -i "s/https:\/\/wuzhi03.coding.net\/p\/dj\/d\/RandomShareCode\/git\/raw\/main\/JD_Factory.json/https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/GARYTEN2\/xxxl\/sharecode\/shareCodes\/JD_Factory.json/g" /scripts/jd_jdfactory.js

  
    #echo "0 6 * * * node /scripts/jd_xtg.js >> /scripts/logs/jd_xtg.log 2>&1" >> /scripts/docker/merged_list_file.sh
    # echo "28 0,12,18,21 * * * node /scripts/jd_carnivalcity.js >> /scripts/logs/jd_carnivalcity.log 2>&1" >> /scripts/docker/merged_list_file.sh
    # sed -i "s/inviteCodes\[tempIndex\].split('@')/[]/g" /scripts/jd_city.js
    # sed -i "s/http:\/\/share.turinglabs.net\/api\/v3\/city\/query\/10\//https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/l107868382\/sharcode\/main\/v1\/jd_city.json/g" /scripts/jd_city.js
   
}


function main(){
    wuzhi_diy
    # 京东到家
    jddj_diy
    didi_diy
    star261_diy
    # 柠檬
    panghu_diy
    longzhuzhu_diy
    # 柠檬_jd
    #panghu999_jd_diy
    # Wenmoux
    Wenmoux_diy
    moposmall_diy
    #hyzaw_diy
    # 判断外网IP,运行自己的代码
    curl icanhazip.com > ./ipstr.txt
    iptxt=$(tail -1 ./ipstr.txt)
    ipbd="152.70"
    result=$(echo $iptxt | grep "${ipbd}")
    if [[ "$result" != "" ]]
    then
      echo "l107服务器，执行性化代码--------------------------------------------------------"
      jd_diy
    else
      echo "非l107服务器，不执行个性化代码---------------------------------------------------"
    fi    
    diycron
    otherreplace
}

main

