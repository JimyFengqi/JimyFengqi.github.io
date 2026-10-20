new Vue({
  el: "#soul", // el不要是最外面的id_name，应该是html: ''里的div的id
  data: function () {
    return {
      content:'干了这碗毒鸡汤',
      classOption: {
        singleHeight: 30,
      },
    };
  },
  created() {
    this.getSoul();
  },
  methods: {
    change(){
       this.getSoul();
    },
    // 请求开源api, 获取一言/毒鸡汤 (60s API, 替代已失效的 btstu)
    getSoul() {
      fetch("https://60s.viki.moe/v2/hitokoto", {
        method: "GET", // *GET, POST, PUT, DELETE, etc.
      })
        .then((res) => {
          return res.json();
        })
        .then((data) => {
          // 60s 返回结构: { code, data: { hitokoto } }
          this.content = (data.data && data.data.hitokoto) || this.content;
        })
        .catch((err) => {
          console.log("err", err);
        });
    },
  },
});