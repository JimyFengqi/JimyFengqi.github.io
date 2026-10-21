'use strict';

function postAudio(args) {
  const src = args[0].trim();
  return `<div class="audio"><audio controls preload><source src='${src}' type='audio/mp3'>Your browser does not support the audio tag.</audio></div>`;
}

function postVideo(args) {
  const src = args[0].trim();
  return `<div class="video"><video controls preload><source src='${src}' type='video/mp4'>Your browser does not support the video tag.</video></div>`;
}

function postVideos(args, content) {
  args = args.join(' ').split(',');
  var cls = args[0];
  if (cls.length > 0) {
    cls = ' ' + cls;
  }
  var col = Number(args[1]) || 0;
  if (col > 0) {
    return `<div class="videos${cls}" col='${col}'>${content}</div>`;
  }
  return `<div class="videos${cls}">${content}</div>`;

}

// 音频网格布局，与 videos 对应: {% audios, 列数 %} ... {% endaudios %}
function postAudios(args, content) {
  args = args.join(' ').split(',');
  var cls = args[0];
  if (cls.length > 0) {
    cls = ' ' + cls;
  }
  var col = Number(args[1]) || 0;
  if (col > 0) {
    return `<div class="audios${cls}" col='${col}'>${content}</div>`;
  }
  return `<div class="audios${cls}">${content}</div>`;
}

hexo.extend.tag.register('audio', postAudio);
hexo.extend.tag.register('video', postVideo);
hexo.extend.tag.register('videos', postVideos, {ends: true});
hexo.extend.tag.register('audios', postAudios, {ends: true});
