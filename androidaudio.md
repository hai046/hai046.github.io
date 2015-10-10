# android音频开发

使用AudioTrack

优点：灵活多变，自己可控，想播放那里就是那里，自己编解码想怎么弄就怎么弄

缺点：必须自己编解码，比MediaPlayer复杂

###声明：

    private synchronized AudioTrack getAudioTracker() {

        if (mAudioTracker == null) {
            int minBufferSize = AudioTrack.getMinBufferSize(AudioLib.AUDIO_SAMPLE_RATE_IN_HZ,
                    AudioFormat.CHANNEL_OUT_MONO, AudioLib.AUDIO_FORMAT);
            mStreamType = mSensorController.getStreamType();
            mAudioTracker = new AudioTrack(mStreamType, AudioLib.AUDIO_SAMPLE_RATE_IN_HZ,
                    AudioFormat.CHANNEL_OUT_MONO, AudioLib.AUDIO_FORMAT, minBufferSize,
                    AudioTrack.MODE_STREAM);
            Log.e(TAG, "minBufferSize=" + minBufferSize);//1280
        }
        mAudioTracker.flush();
        return mAudioTracker;

    }
    
 必须注意的是获取最新的缓存区大小 minBufferSize
 这个值是根据比特率，音频格式和声道技术出来的，不是随便给出的，一般是320的整数倍
 
在android中如果你想切换播放模式 例如从听筒模式切换到外放模式的时候【修改StreamType】，必须重新初始化AudioTrack ，MediaPlayer亦然


###播放

其实就是mAudioTracker.write(buffer, 0, lg);来播放buffer里面的内容
这个buffer必须是解码后的内容，必须是pcm格式

例如如下code【本人使用opus编解码】


    
    

     while (!isExit()) {
                lockWaitSyn();
                if (isExit()) {
                    break;
                }

                if (Log.DEBUG) {
                    Log.d(TAG, "Wav player begin");
                }

                try {
                    Utils.pauseMusic();
                    AudioLib.getLock().writeLock().lock();
                    registerSensor();
                    if (isPlaying) {

                        mAudioTracker = getAudioTracker();
                        if (mAudioTracker.getState() == AudioTrack.STATE_INITIALIZED) {
                            int readSize = 0;

                            mAudioTracker.play();

                            int minSize = AudioLib.initDecorder(mAudioFilePath, 0);
                            if (minSize < 0) {
                                Log.e(TAG, "initDecorder errr");
                                break;
                            }
                            short[] buffer = new short[minSize];
                            prepareAsync();
                            while (isPlaying) {
                                mAudioTrackPlaying = true;

                                checkPlayMode();

                                if (isPaused) {
                                    mAudioTracker.pause();
                                    if (isPlaying) {
                                        mAudioTracker.play();
                                    } else {
                                        break;
                                    }
                                }
                                int lg = 0;
                                if ((lg = AudioLib.decorderRead(buffer, 0, buffer.length)) > 0) {
                                    mAudioTracker.write(buffer, 0, lg);
                                } else {
                                    break;
                                }
                                mCurrentPosition += readSize;

                            }
                        }
                    }
                } catch (Throwable e) {
                    Log.e(TAG, "Wav player handle exception");
                    handleException(e);
                    String log = "play failure cpu=" + Utils.getProcessorType() + " "
                            + e.getMessage();
                    StatisticsManager.getIntance().addCommonLog(log);
                    StatisticsManager.getIntance().commit();
                } finally {
                    mAudioTrackPlaying = false;
                    reachAudioFileEnd();
                    AudioLib.destoryDecorder();
                    AudioLib.getLock().writeLock().unlock();
                    stopPlay();
                    AudioPlayerController.getIntance().playComplete();
                    unregisterSensor();
                    if (Log.DEBUG) {
                        Log.d(TAG, "Wav player end");
                    }
                }
            }
        }



注意如果如果在声明的时候设置stremType  例如music/in_call模式  听筒会比较小，那么我们可以这样
设置

    mAudioManager.setMode(AudioManager.MODE_IN_COMMUNICATION);
                mAudioManager.setSpeakerphoneOn(true/false);

完整code:


            if (mAudioManager != null) {
                if (mStreamType == AudioManager.STREAM_MUSIC) {
                    mAudioManager.setMode(AudioManager.MODE_IN_COMMUNICATION);
                    mAudioManager.setSpeakerphoneOn(true);
                } else if (mStreamType == AudioManager.STREAM_VOICE_CALL) {
                    mAudioManager.setMode(AudioManager.MODE_IN_COMMUNICATION);
                    mAudioManager.setSpeakerphoneOn(false);
                }

            }

            mAudioTracker = new AudioTrack(AudioManager.STREAM_MUSIC, AudioLib.AUDIO_SAMPLE_RATE_IN_HZ,
                    AudioFormat.CHANNEL_OUT_MONO, AudioLib.AUDIO_FORMAT, minBufferSize,
                    AudioTrack.MODE_STREAM);

    
    