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
    // 请求开源api, 获取历史上的今天数据
    getSoul() {
      fetch("https://api.btstu.cn/yan/api.php?charset=utf-8&encode=json", {
        method: "GET", // *GET, POST, PUT, DELETE, etc.
      })
        .then((res) => {
          return res.json();
        })
        .then((data) => {
          this.content = data.text;
        })
        .catch((err) => {
          console.log("err", err);
        });
    },
  },
});