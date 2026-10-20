var htmer_time = document.getElementById("htmer_time");
var htmer_time_time = null;

function setTime() {
  // 恋爱纪念起点：2019-09-19 06:45:00（北京时间 UTC+8）
  // 北京 06:45 == 前一日 UTC 22:45，用 Date.UTC 精确表示这一绝对时刻
  var create_time = Math.round(
    Date.UTC(2019, 08, 18, 22, 45, 0) / 1000
  );
  // Date.now()/getTime() 返回的是与时区无关的绝对 Unix 时间戳，
  // 两个绝对时刻相减即为真实时间差，不需要(也不能)再 +8 小时。
  var timestamp = Math.round(new Date().getTime() / 1000);
  currentTime = secondToDate(timestamp - create_time);
  currentTimeHtml =
    currentTime[0] +
    " 年 " +
    currentTime[1] +
    " 天 " +
    currentTime[2] +
    " 时 " +
    currentTime[3] +
    " 分 " +
    currentTime[4] +
    " 秒";
  htmer_time.innerHTML = currentTimeHtml;
}
function secondToDate(second) {
  var time = new Array(0, 0, 0, 0, 0);
  if (!second || second < 0) {
    return time; // 始终返回数组，避免 currentTime[x] 为 undefined
  }
  if (second >= 365 * 24 * 3600) {
    time[0] = parseInt(second / (365 * 24 * 3600));
    second %= 365 * 24 * 3600;
  }
  if (second >= 24 * 3600) {
    time[1] = parseInt(second / (24 * 3600));
    second %= 24 * 3600;
  }
  if (second >= 3600) {
    time[2] = parseInt(second / 3600);
    second %= 3600;
  }
  if (second >= 60) {
    time[3] = parseInt(second / 60);
    second %= 60;
  }
  if (second > 0) {
    time[4] = second;
  }
  return time;
}

if (htmer_time) {
  htmer_time_time = setInterval(setTime, 1000);
} else {
  clearInterval(htmer_time_time);
}
