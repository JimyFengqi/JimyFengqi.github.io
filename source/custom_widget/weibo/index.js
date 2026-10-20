new Vue({
  el: "#myWeibo", // el不要是最外面的id_name，应该是html: ''里的div的id
  data: function () {
    return {
      content: [],
      classOption: {
        singleHeight: 30,
      },
    };
  },
  created() {
    this.getWeiboList();
  },
  methods: {
    // 请求开源api, 获取微博热搜数据 (60s API, 替代已失效的 tenapi)
    getWeiboList() {
      fetch("https://60s.viki.moe/v2/weibo", {
        method: "GET", // *GET, POST, PUT, DELETE, etc.
      })
        .then((res) => {
          return res.json();
        })
        .then((data) => {
          // 60s 返回结构: { code, data: [ { title, hot_value, link } ] }
          // 适配旧模板使用的字段名: name / hot / url
          this.content = (data.data || []).map((item) => ({
            name: item.title,
            hot: item.hot_value,
            url: item.link,
          }));
        })
        .catch((err) => {
          console.log("err", err);
        });
    },
  },
});