# 暂停正在播放的音乐

    public static void pauseMusic() {

        KeyEvent ke = new KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_MEDIA_PAUSE);
        Intent intent = new Intent(Intent.ACTION_MEDIA_BUTTON);
        intent.addFlags(Intent.FLAG_RECEIVER_FOREGROUND);

        // construct a PendingIntent for the media button and unregister it
        Intent mediaButtonIntent = new Intent(Intent.ACTION_MEDIA_BUTTON);
        PendingIntent pi = PendingIntent.getBroadcast(AppContext.getContext(),
                0/*requestCode, ignored*/, mediaButtonIntent, 0/*flags*/);
        intent.putExtra(Intent.EXTRA_KEY_EVENT, ke);
        sendKeyEvent(pi, AppContext.getContext(), intent);

        ke = new KeyEvent(KeyEvent.ACTION_UP, KeyEvent.KEYCODE_MEDIA_PAUSE);
        intent.putExtra(Intent.EXTRA_KEY_EVENT, ke);
        sendKeyEvent(pi, AppContext.getContext(), intent);

        //        android.intent.action.MEDIA_BUTTON

    }

    private static void sendKeyEvent(PendingIntent pi, Context context, Intent intent) {
        try {
            pi.send(context, 0, intent);
        } catch (PendingIntent.CanceledException e) {
            Log.e(TAG, "Error sending media key down event:", e);
        }
    }