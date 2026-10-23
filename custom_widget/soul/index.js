// 欢迎挂件：左侧访客 IP 信息卡片 + 右侧毒鸡汤(一言)
// Vue 实例挂载在最外层 #ip_welcome 上，使 IP 卡片与毒鸡汤共用同一个实例。
new Vue({
  el: "#ip_welcome",
  data: function () {
    return {
      content: "干了这碗毒鸡汤",
      ip: {
        ip: "",
        loc: "",
        org: "",
        tz: "",
      },
    };
  },
  created() {
    this.getSoul();
    this.getIp();
  },
  methods: {
    change() {
      this.getSoul();
    },
    // 一言/毒鸡汤 (60s API)
    getSoul() {
      fetch("https://60s.viki.moe/v2/hitokoto", { method: "GET" })
        .then((res) => res.json())
        .then((data) => {
          this.content = (data.data && data.data.hitokoto) || this.content;
        })
        .catch((err) => console.log("soul err", err));
    },
    // 访客 IP 信息 (ip.011102.xyz, 返回 JSON, 支持 CORS)
    getIp() {
      fetch("https://ip.011102.xyz/", { method: "GET" })
        .then((res) => res.json())
        .then((data) => {
          var i = (data && data.IP) || {};
          var locParts = [i.Country, i.Region, i.City].filter(Boolean);
          this.ip = {
            ip: i.IP || "",
            loc: locParts.join(" · ") || "未知",
            org: i.ASOrganization || "未知",
            tz: i.Timezone || "未知",
          };
        })
        .catch((err) => console.log("ip err", err));
    },
  },
});
