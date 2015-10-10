# OkHttpClient添加拦截器

初始化OkHttpClient

```
        mOkHttpClient = new OkHttpClient();
        mOkHttpClient.setConnectTimeout(DEFAULT_CONNECTION_TIMEOUT, TimeUnit.SECONDS);
        mOkHttpClient.setReadTimeout(DEFAULT_READ_TIMEOUT, TimeUnit.SECONDS);
        mOkHttpClient.networkInterceptors().add(new Interceptor() {
            @Override
            public Response intercept(Chain chain) throws IOException {
                return chain.proceed(chain.request()//发起请求
                        .newBuilder()//在原来发送请求的基础上 生成新的builder
                        .header("token", "...")//添加header   例如全局添加token  UA 什么的
                        .build());
                //                return null;
            }

        });
```

其他的就和标准的差不多

我们可以写标准的interface ，这样我们可以方便的切换到AndroidHttpClient 或者是URLConection什么的
