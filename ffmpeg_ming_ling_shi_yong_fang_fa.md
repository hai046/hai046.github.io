# ffmpeg 命令使用方法

# 从视频截取image

```
ffmpeg -ss 01:35:00  -i 港囧\ \(蓝光原盘\).mkv   -y images/image_%02d.png
```

后面的%2d 这是一个命名规则，会截取一系列的图片  ，如果不安装这种命名规则来的话回报错

```
[image2 @ 0x7fcde9876000] Could not get frame filename number 2 from pattern 'images/image_01.png' (either set updatefirst or use a pattern like %03d within the filename pattern)
av_interleaved_write_frame(): Invalid argument
```

另外  参数-ss 是开始截取的时间点  必须放在前面  是先seek然后在截屏 否则非常慢 


# 格式转换

```
fmpeg -i 港囧\ \(蓝光原盘\).mkv -acodec copy -vcodec libx264  -ss 00:01:00 -t 00:01:00 -f mp4 01.mp4 
```

-t 是截取的duration

