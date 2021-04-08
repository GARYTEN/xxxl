/*
 * @Author: Xin https://github.com/Xin-code 
 * @Date: 2021-03-15 11:22:11 
 * @Last Modified by: Xin 
 * @Last Modified time: 2021-03-26 13:47:15
 */

const $ = Env('京东庄园')

const Cookie = []

// 任务列表
const TaskArrList = []

if ($.isNode()) {
  if (process.env.JDGH_XDZY_COOKIE && process.env.JDGH_XDZY_COOKIE.indexOf('#') > -1) {
    signcookie = process.env.JDGH_XDZY_COOKIE.split('#')
  } else {
    signcookie = process.env.JDGH_XDZY_COOKIE.split()
  }
  Object.keys(signcookie).forEach((item) => {
    if (signcookie[item]) {
      Cookie.push(signcookie[item])
    }
  })
}

const JD_API_HOST = `https://daojia.jd.com/client?_jdrandom=${new Date().getTime()}`



!(async () => {
  for (let i = 0; i < Cookie.length; i++) {
    console.log(`········【帐号${i+1}】开始········`)
    cookie = Cookie[i]
    await todoTask()
    console.log(`········【帐号${i+1}】结束········`)
  }
})()
    .catch((e) => $.logErr(e))
    .finally(() => $.done())
    
    
async function todoTask(){
  
  // 签到
  console.log(`🌱执行 -> 日常签到`)
  await CheckIn()

  // 收集水滴
  console.log(`\n🌱执行 -> 收集水滴`)
  await getWater()

  // 获取任务列表
  console.log(`\n🌱执行 -> 查看任务列表`)
  await getTask()

  // 去完成任务
  console.log(`\n🌱执行 -> 完成任务`)
  for (let i = 0; i < TaskArrList.length; i++) {
    Task = TaskArrList[i]
    await doFinishTask(Task)
    await $.wait(2000) // 避免 重复操作
  }

  // 任务领取奖励
  console.log(`\n🌱执行 -> 领取奖励`)
  for (let i = 0; i < TaskArrList.length; i++) {
    Task = TaskArrList[i]
    await doDailyTaskAward(Task)
    await $.wait(2000) // 避免 重复操作
  }

  // 单独任务 分享好友
  console.log(`\n🌱执行 -> 分享好友`)
  await shareFriend()

  // 点击果树掉落💧水滴
  console.log(`\n🌱执行 -> 点击果树`)
  for (let i = 0; i < 5; i++) {
    await doClickTree(i)
    await $.wait(2000) // 避免 重复操作
  }


  // 浇水
  console.log(`\n🌱执行 -> 浇水`)
  for(let i = 0; i<$.totalWater/100;i++){
    if($.totalWater/100<1){
      console.log(`💧水滴不够,不执行浇水操作···`)
    }else{
      console.log(`\n正在第【${i+1}】次浇水`)
      await watering()
      await $.wait(2000) // 避免 重复操作
    }
  }
  
  /*
	if(date.getDay() == 0) week = "星期日"
	if(date.getDay() == 1) week = "星期一"
	if(date.getDay() == 2) week = "星期二"
	if(date.getDay() == 3) week = "星期三"
	if(date.getDay() == 4) week = "星期四"
	if(date.getDay() == 5) week = "星期五"
	if(date.getDay() == 6) week = "星期六"
  */

  if(new Date().getDay()===1){
    console.log(`\n🕛今天星期一,开始领取上周奖励💰:`)
    await getLastWeekReward()
  }else{
    console.log(`\n🕛今天不是星期一，不执行收取奖励💰`);
    return
  }
  
}

// 签到
async function CheckIn() {
  return new Promise((resolve) => {
    $.get(taskUrl(`signin/userSigninNew`, {"channel":"qiandao_baibaoxiang"}), (err, resp, data) => {
      try {
        if (err) {
          console.log(`${JSON.stringify(err)}`)
          console.log(`API请求失败，请检查网路重试`)
        } else {
          result = JSON.parse(data)
          // 反馈信息
          // console.log(result)
          console.log(`✅ 已登录 \n${result.msg}`)
        }} catch (e) {
          console.log(e)
        } finally {
          resolve(data)
        }})
      })
}

// 收集水滴
async function getWater() {
  return new Promise((resolve) => {
    $.post(taskUrlBody(`plantBeans/getWater`, {"activityId":"23d9550546014be"}), (err, resp, data) => {
      try {
        if (err) {
          console.log(`${JSON.stringify(err)}`)
          console.log(`API请求失败，请检查网路重试`)
        } else {
          result = JSON.parse(data)
          $.totalWater = result.result.water
          // console.log(result)
          if(result.code!=='0'){
            console.log(`❌ ${result.msg}`)
          }else{
            console.log(`本次收集：【${result.result.addWater}g】💧`)
            console.log(`目前可浇水：【${result.result.water}g】💧`)
            console.log(`当日总共收集：【${result.result.dailyWater}g】💧`)
          }
        }
      } catch (e) {
        console.log(e)
      } finally {
        resolve(data)
      }})
    })
}

// 任务列表
async function getTask() {
  return new Promise((resolve) => {
    $.get(taskUrl(`task/list`, {"modelId":"M10003","plateCode":1}), async(err, resp, data) => {
      try {
        if (err) {
          console.log(`${JSON.stringify(err)}`)
          console.log(`API请求失败，请检查网路重试`)
        } else {
          result = JSON.parse(data)
          // console.log(result)
          if(result.code!=='0'){
            console.log(`❌ ${result.msg}`)
          }else{
            console.log(`获取任务列表: ✅ ${result.msg}`)
            // 任务列表 数组形式
            taskInfoList = result.result.taskInfoList
            taskInfoList.forEach((item)=>{
              // 每个任务
              // console.log(item)
              // 把 任务中 内容都推送到TaskArrList内
              // 采用对象格式 [{},{},{},{}]
              let taskInfo = {
                'modelId':`${item.modelId}`,
                'taskId':`${item.taskId}`,
                'taskType':`${item.taskType}`,
                'plateCode':1,
              }
              // 去完成内容 推到数组内
              TaskArrList.push(taskInfo)
            })
          }
        }} catch (e) {
        console.log(e)
      } finally {
        resolve(data)
      }})
    })
}

// 浇水操作
async function watering() {
  return new Promise((resolve) => {
    $.post(taskUrlBody(`plantBeans/watering`, {"activityId":"23d9550546014be","waterAmount":100}), async(err, resp, data) => {
      try {
        if (err) {
          console.log(`${JSON.stringify(err)}`)
          console.log(`API请求失败，请检查网路重试`)
        } else {
          result = JSON.parse(data)
          // console.log(result)
          if(result.code!=='0'){
            console.log(`❌ ${result.msg}`)
          }else{
            beanInfo = result.result
            console.log(`当前【${beanInfo.levelUp}】级,还差`+((1-(beanInfo.levelProgress/beanInfo.totalProgress))*100).toFixed(2)+`%升级`)
            console.log(`当前还剩💧【${beanInfo.water}g】💧,还可以浇${(beanInfo.water/100).toFixed()-1}次`)
            if((beanInfo.water/100).toFixed()-1===0){
              console.log(`💧不够,不进行浇水操作···`)
              return
            }
          }
        }
      } catch (e) {
        console.log(e)
      } finally {
        resolve(data)
      }})
    })
}

/*
{
  code: '0',
  msg: '成功',
  result: {
    level: -1,
    dailyWater: 1969,
    waterCart: 0,
    levelProgress: 6000,
    totalProgress: 6500,
    water: 589,
    maxLevel: false
  },
  success: true
}
*/

// 完成任务
async function doFinishTask(Task) {
  return new Promise((resolve) => {
    $.get(taskUrl(`task/finished`, Task), async(err, resp, data) => {
      try {
        if (err) {
          console.log(`${JSON.stringify(err)}`)
          console.log(`API请求失败，请检查网路重试`)
        } else {
          result = JSON.parse(data)
          // console.log(result)
          if(result.code!=='0'){
            // 未去做任务 显示失败原因
            console.log(result.msg)
          }else{
            // 去做任务
            console.log(`📝去做任务：【${result.result.taskName}】 - 任务奖励【${result.result.awardValue}g】💧 - 待领取奖励💰`)
          }
        }} catch (e) {
        console.log(e)
      } finally {
        resolve(data)
      }})
    })
}

// 领取奖励
async function doDailyTaskAward(Task) {
  return new Promise((resolve) => {
    $.get(taskUrl(`task/sendPrize`, Task), async(err, resp, data) => {
      try {
        if (err) {
          console.log(`${JSON.stringify(err)}`)
          console.log(`API请求失败，请检查网路重试`)
        } else {
          result = JSON.parse(data)
          // console.log(result)
          // 任务是否完成
          if(result.code!=='0'){
            // 未完成
            // { code: '-3', msg: '未达到领取奖励的条件', success: false }
            console.log(result.msg)
          }else{
            // 任务完成
            console.log(`收取奖励💰：任务【${result.result.taskName}】-${result.result.buttonText}-获得【${result.result.awardValue}g】💧`)
          }
        }} catch (e) {
        console.log(e)
      } finally {
        resolve(data)
      }})
    })
}
/*
{
  code: '0',
  msg: '成功',
  result: {
    modelId: 'M10003',
    taskId: '23de4e8b8654a15',
    taskName: '达达 领权益-APP',
    taskType: 901,
    awardType: 1,
    awardValue: '5',
    taskIcon: 'https://img30.360buyimg.com/mobilecms/jfs/t1/168107/32/1539/8590/5ff7cf69E45cb12aa/b6126b6daa7951b8.png',
    taskTitle: '去达达快送领现金',
    taskSubTitle: '每天瓜分10万元现金',
    buttonText: '已完成',
    status: 3,
    to: 'web',
    params: { path: '', appId: '', url: 'weixin://dl/business/?t=4RlDUcPlwHn' },
    unreceiveTaskJumpFlag: 0,
    isShow: 0,
    identificationCode: '',
    secondsLeft: 0,
    rules: '',
    unreceivedAwardValue: '0',
    browseTime: -1,
    ifCanReEnter: 0,
    toast: '',
    nextDayUnReceivedAwardValue: 0,
    finishNum: 1,
    totalNum: 1,
    showPosition: 1,
    finishType: 402,
    extraFinishMQType: 0,
    todayFinishNum: 1,
    ifCanFinishTask: 0,
    uniqueId: '23e41b4cca78efe'
  },
  success: true
}
*/

// 上周奖励
async function getLastWeekReward() {
  return new Promise((resolve) => {
    $.post(taskUrlBody(`plantBeans/getPoints`, {"activityId":"23d9550546014be"}), async(err, resp, data) => {
      try {
        if (err) {
          console.log(`${JSON.stringify(err)}`)
          console.log(`API请求失败，请检查网路重试`)
        } else {
          result = JSON.parse(data)
          if(result.code!=='0'){
            // 重复领取
            console.log(`❌ ${result.msg}`)
          }else{
            // 领取奖励
            rewardInfo = result.result
            console.log(`收取奖励💰:${rewardInfo.title}`)
          }
        }} catch (e) {
        console.log(e)
      } finally {
        resolve(data)
      }})
    })
}
/*
{
  "code":"0",
  "msg":"成功",
  "result":{
    "title":"恭喜获得364鲜豆",
    "subTitle":"参与下期活动继续瓜分",
    "buttonId":0,
    "buttonText":"参与下期瓜分"
  },
  "success":true}
*/

// 分享好友
async function shareFriend() {
  return new Promise((resolve) => {
    $.get(taskUrl(`task/received`, {"modelId":"M10003","taskId":"22e7e29aaefea08","taskType":503,"plateCode":1}), async(err, resp, data) => {
      try {
        if (err) {
          console.log(`${JSON.stringify(err)}`)
          console.log(`API请求失败，请检查网路重试`)
        } else {
          result = JSON.parse(data)
          if(result.code!=='0'){
            console.log(`❌ ${result.msg}`)
          }else{
            console.log(`任务【${result.result.buttonText}】${result.msg},奖励水滴:【${result.result.awardValue}g】💧`);
          }
        }
      } catch (e) {
        console.log(e)
      } finally {
        resolve(data)
      }})
    })
}


// 点击果树
async function doClickTree(i) {
  return new Promise((resolve) => {
    $.post(taskUrlBody(`plantBeans/beansLottery`, {"activityId":"23d9550e68124ae"}), async(err, resp, data) => {
      try {
        if (err) {
          console.log(`${JSON.stringify(err)}`)
          console.log(`API请求失败，请检查网路重试`)
        } else {
          result = JSON.parse(data)
          // console.log(result)
          if(result.code!=='0'){
            console.log(`❌ ${result.msg}`)
          }else{
            // 文字
            if(result.result.lotteryType!=='WATER'){
              console.log(`第${i+1}次点击了果树··>获得一段话：${(result.result.text).slice(1)}`);
            }else{
              // 水滴
              console.log(`第${i+1}次点击了果树··>${result.result.title}获得:【${result.result.water}g】💧`)
            }
          }
        }
      } catch (e) {
        console.log(e)
      } finally {
        resolve(data)
      }})
    })
}

/*
{
  "code":"0",
  "msg":"成功",
  "result":{
    "lotteryType":"WATER",
    "water":100,
    "title":"发现了露水"
  },
  "success":true}

  {
  code: '0',
  msg: '成功',
  result: { text: '\n我这么可爱，记得每天来看看我呀', lotteryType: 'TEXT' },
  success: true
}
*/



// url
function taskUrl(function_id, params = {}) {
  return {
    url: `${JD_API_HOST}&functionId=${function_id}&isNeedDealError=true&body=${escape(JSON.stringify(params))}`,
    headers: {
      'Accept': '*/*',
      'Connection': 'keep-alive',
      'Content-Type': 'application/x-www-form-urlencoded',
      'cookie':cookie,
      'Host': 'daojia.jd.com',
      'Origin': 'https://daojia.jd.com',
      'Referer':'https://daojia.jd.com/taroh5/h5dist/',
      'User-Agent': `Mozilla/5.0 (iPhone; CPU iPhone OS 14_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile`,
    }
  }
}

// Body
function taskUrlBody(function_id, params = {}) {
  return {
    url: `${JD_API_HOST}`,
    // escape() 函数可对字符串进行编码
    body:`functionId=${function_id}&body=${escape(JSON.stringify(params))}`,
    headers: {
      'Accept': '*/*',
      'Connection': 'keep-alive',
      'Content-Type': 'application/x-www-form-urlencoded',
      'cookie':cookie,
      'Host': 'daojia.jd.com',
      'Origin': 'https://daojia.jd.com',
      'Referer':'https://daojia.jd.com/taroh5/h5dist/',
      'User-Agent': `Mozilla/5.0 (iPhone; CPU iPhone OS 14_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile`,
    }
  }
}


// pretty-ignore
function Env(t,e){class s{constructor(t){this.env=t}send(t,e="GET"){t="string"==typeof t?{url:t}:t;let s=this.get;return"POST"===e&&(s=this.post),new Promise((e,i)=>{s.call(this,t,(t,s,r)=>{t?i(t):e(s)})})}get(t){return this.send.call(this.env,t)}post(t){return this.send.call(this.env,t,"POST")}}return new class{constructor(t,e){this.name=t,this.http=new s(this),this.data=null,this.dataFile="box.dat",this.logs=[],this.isMute=!1,this.isNeedRewrite=!1,this.logSeparator="\n",this.startTime=(new Date).getTime(),Object.assign(this,e),this.log("",`\ud83d\udd14${this.name}, \u5f00\u59cb!`)}isNode(){return"undefined"!=typeof module&&!!module.exports}isQuanX(){return"undefined"!=typeof $task}isSurge(){return"undefined"!=typeof $httpClient&&"undefined"==typeof $loon}isLoon(){return"undefined"!=typeof $loon}toObj(t,e=null){try{return JSON.parse(t)}catch{return e}}toStr(t,e=null){try{return JSON.stringify(t)}catch{return e}}getjson(t,e){let s=e;const i=this.getdata(t);if(i)try{s=JSON.parse(this.getdata(t))}catch{}return s}setjson(t,e){try{return this.setdata(JSON.stringify(t),e)}catch{return!1}}getScript(t){return new Promise(e=>{this.get({url:t},(t,s,i)=>e(i))})}runScript(t,e){return new Promise(s=>{let i=this.getdata("@chavy_boxjs_userCfgs.httpapi");i=i?i.replace(/\n/g,"").trim():i;let r=this.getdata("@chavy_boxjs_userCfgs.httpapi_timeout");r=r?1*r:20,r=e&&e.timeout?e.timeout:r;const[o,h]=i.split("@"),a={url:`http://${h}/v1/scripting/evaluate`,body:{script_text:t,mock_type:"cron",timeout:r},headers:{"X-Key":o,Accept:"*/*"}};this.post(a,(t,e,i)=>s(i))}).catch(t=>this.logErr(t))}loaddata(){if(!this.isNode())return{};{this.fs=this.fs?this.fs:require("fs"),this.path=this.path?this.path:require("path");const t=this.path.resolve(this.dataFile),e=this.path.resolve(process.cwd(),this.dataFile),s=this.fs.existsSync(t),i=!s&&this.fs.existsSync(e);if(!s&&!i)return{};{const i=s?t:e;try{return JSON.parse(this.fs.readFileSync(i))}catch(t){return{}}}}}writedata(){if(this.isNode()){this.fs=this.fs?this.fs:require("fs"),this.path=this.path?this.path:require("path");const t=this.path.resolve(this.dataFile),e=this.path.resolve(process.cwd(),this.dataFile),s=this.fs.existsSync(t),i=!s&&this.fs.existsSync(e),r=JSON.stringify(this.data);s?this.fs.writeFileSync(t,r):i?this.fs.writeFileSync(e,r):this.fs.writeFileSync(t,r)}}lodash_get(t,e,s){const i=e.replace(/\[(\d+)\]/g,".$1").split(".");let r=t;for(const t of i)if(r=Object(r)[t],void 0===r)return s;return r}lodash_set(t,e,s){return Object(t)!==t?t:(Array.isArray(e)||(e=e.toString().match(/[^.[\]]+/g)||[]),e.slice(0,-1).reduce((t,s,i)=>Object(t[s])===t[s]?t[s]:t[s]=Math.abs(e[i+1])>>0==+e[i+1]?[]:{},t)[e[e.length-1]]=s,t)}getdata(t){let e=this.getval(t);if(/^@/.test(t)){const[,s,i]=/^@(.*?)\.(.*?)$/.exec(t),r=s?this.getval(s):"";if(r)try{const t=JSON.parse(r);e=t?this.lodash_get(t,i,""):e}catch(t){e=""}}return e}setdata(t,e){let s=!1;if(/^@/.test(e)){const[,i,r]=/^@(.*?)\.(.*?)$/.exec(e),o=this.getval(i),h=i?"null"===o?null:o||"{}":"{}";try{const e=JSON.parse(h);this.lodash_set(e,r,t),s=this.setval(JSON.stringify(e),i)}catch(e){const o={};this.lodash_set(o,r,t),s=this.setval(JSON.stringify(o),i)}}else s=this.setval(t,e);return s}getval(t){return this.isSurge()||this.isLoon()?$persistentStore.read(t):this.isQuanX()?$prefs.valueForKey(t):this.isNode()?(this.data=this.loaddata(),this.data[t]):this.data&&this.data[t]||null}setval(t,e){return this.isSurge()||this.isLoon()?$persistentStore.write(t,e):this.isQuanX()?$prefs.setValueForKey(t,e):this.isNode()?(this.data=this.loaddata(),this.data[e]=t,this.writedata(),!0):this.data&&this.data[e]||null}initGotEnv(t){this.got=this.got?this.got:require("got"),this.cktough=this.cktough?this.cktough:require("tough-cookie"),this.ckjar=this.ckjar?this.ckjar:new this.cktough.CookieJar,t&&(t.headers=t.headers?t.headers:{},void 0===t.headers.Cookie&&void 0===t.cookieJar&&(t.cookieJar=this.ckjar))}get(t,e=(()=>{})){t.headers&&(delete t.headers["Content-Type"],delete t.headers["Content-Length"]),this.isSurge()||this.isLoon()?(this.isSurge()&&this.isNeedRewrite&&(t.headers=t.headers||{},Object.assign(t.headers,{"X-Surge-Skip-Scripting":!1})),$httpClient.get(t,(t,s,i)=>{!t&&s&&(s.body=i,s.statusCode=s.status),e(t,s,i)})):this.isQuanX()?(this.isNeedRewrite&&(t.opts=t.opts||{},Object.assign(t.opts,{hints:!1})),$task.fetch(t).then(t=>{const{statusCode:s,statusCode:i,headers:r,body:o}=t;e(null,{status:s,statusCode:i,headers:r,body:o},o)},t=>e(t))):this.isNode()&&(this.initGotEnv(t),this.got(t).on("redirect",(t,e)=>{try{if(t.headers["set-cookie"]){const s=t.headers["set-cookie"].map(this.cktough.Cookie.parse).toString();s&&this.ckjar.setCookieSync(s,null),e.cookieJar=this.ckjar}}catch(t){this.logErr(t)}}).then(t=>{const{statusCode:s,statusCode:i,headers:r,body:o}=t;e(null,{status:s,statusCode:i,headers:r,body:o},o)},t=>{const{message:s,response:i}=t;e(s,i,i&&i.body)}))}post(t,e=(()=>{})){if(t.body&&t.headers&&!t.headers["Content-Type"]&&(t.headers["Content-Type"]="application/x-www-form-urlencoded"),t.headers&&delete t.headers["Content-Length"],this.isSurge()||this.isLoon())this.isSurge()&&this.isNeedRewrite&&(t.headers=t.headers||{},Object.assign(t.headers,{"X-Surge-Skip-Scripting":!1})),$httpClient.post(t,(t,s,i)=>{!t&&s&&(s.body=i,s.statusCode=s.status),e(t,s,i)});else if(this.isQuanX())t.method="POST",this.isNeedRewrite&&(t.opts=t.opts||{},Object.assign(t.opts,{hints:!1})),$task.fetch(t).then(t=>{const{statusCode:s,statusCode:i,headers:r,body:o}=t;e(null,{status:s,statusCode:i,headers:r,body:o},o)},t=>e(t));else if(this.isNode()){this.initGotEnv(t);const{url:s,...i}=t;this.got.post(s,i).then(t=>{const{statusCode:s,statusCode:i,headers:r,body:o}=t;e(null,{status:s,statusCode:i,headers:r,body:o},o)},t=>{const{message:s,response:i}=t;e(s,i,i&&i.body)})}}time(t){let e={"M+":(new Date).getMonth()+1,"d+":(new Date).getDate(),"H+":(new Date).getHours(),"m+":(new Date).getMinutes(),"s+":(new Date).getSeconds(),"q+":Math.floor(((new Date).getMonth()+3)/3),S:(new Date).getMilliseconds()};/(y+)/.test(t)&&(t=t.replace(RegExp.$1,((new Date).getFullYear()+"").substr(4-RegExp.$1.length)));for(let s in e)new RegExp("("+s+")").test(t)&&(t=t.replace(RegExp.$1,1==RegExp.$1.length?e[s]:("00"+e[s]).substr((""+e[s]).length)));return t}msg(e=t,s="",i="",r){const o=t=>{if(!t)return t;if("string"==typeof t)return this.isLoon()?t:this.isQuanX()?{"open-url":t}:this.isSurge()?{url:t}:void 0;if("object"==typeof t){if(this.isLoon()){let e=t.openUrl||t.url||t["open-url"],s=t.mediaUrl||t["media-url"];return{openUrl:e,mediaUrl:s}}if(this.isQuanX()){let e=t["open-url"]||t.url||t.openUrl,s=t["media-url"]||t.mediaUrl;return{"open-url":e,"media-url":s}}if(this.isSurge()){let e=t.url||t.openUrl||t["open-url"];return{url:e}}}};if(this.isMute||(this.isSurge()||this.isLoon()?$notification.post(e,s,i,o(r)):this.isQuanX()&&$notify(e,s,i,o(r))),!this.isMuteLog){let t=["","==============\ud83d\udce3\u7cfb\u7edf\u901a\u77e5\ud83d\udce3=============="];t.push(e),s&&t.push(s),i&&t.push(i),console.log(t.join("\n")),this.logs=this.logs.concat(t)}}log(...t){t.length>0&&(this.logs=[...this.logs,...t]),console.log(t.join(this.logSeparator))}logErr(t,e){const s=!this.isSurge()&&!this.isQuanX()&&!this.isLoon();s?this.log("",`\u2757\ufe0f${this.name}, \u9519\u8bef!`,t.stack):this.log("",`\u2757\ufe0f${this.name}, \u9519\u8bef!`,t)}wait(t){return new Promise(e=>setTimeout(e,t))}done(t={}){const e=(new Date).getTime(),s=(e-this.startTime)/1e3;this.log("",`\ud83d\udd14${this.name}, \u7ed3\u675f! \ud83d\udd5b ${s} \u79d2`),this.log(),(this.isSurge()||this.isQuanX()||this.isLoon())&&$done(t)}}(t,e)}
