# 高斯模糊效果

Android 4.2.1及其以后可以用系统自带的高斯模糊效果了



```
 if (Build.VERSION.SDK_INT > 16) {
                    bitmap = bitmap.copy(bitmap.getConfig(), true);
                    final RenderScript rs = RenderScript.create(AppContext.getContext());
                    final Allocation input = Allocation.createFromBitmap(rs, bitmap,
                            Allocation.MipmapControl.MIPMAP_NONE, Allocation.USAGE_SCRIPT);
                    final Allocation output = Allocation.createTyped(rs, input.getType());
                    final ScriptIntrinsicBlur script = ScriptIntrinsicBlur.create(rs,
                            Element.U8_4(rs));
                    script.setRadius(14);
                    script.setInput(input);
                    script.forEach(output);
                    output.copyTo(bitmap);
                    rs.destory();//必须要关闭，不然会内存泄露
                    return bitmap;
                }
```


系统直接提供，也是直接调用GPU来渲染处理，不过这样感觉比自己写更easy，另外还有其他的
```
ScriptGroup.Builder	Helper class to build a ScriptGroup. 
ScriptIntrinsic	Base class for all Intrinsic scripts. 
ScriptIntrinsic3DLUT	Intrinsic for converting RGB to RGBA by using a 3D lookup table. 
ScriptIntrinsicBlend	Intrinsic kernels for blending two Allocation objects. 
ScriptIntrinsicBlur	Intrinsic Gausian blur filter. 
ScriptIntrinsicColorMatrix	Intrinsic for applying a color matrix to allocations. 
ScriptIntrinsicConvolve3x3	Intrinsic for applying a 3x3 convolve to an allocation. 
ScriptIntrinsicConvolve5x5	Intrinsic for applying a 5x5 convolve to an allocation. 
ScriptIntrinsicHistogram	Intrinsic Histogram filter. 
ScriptIntrinsicLUT	Intrinsic for applying a per-channel lookup table. 
ScriptIntrinsicYuvToRGB	Intrinsic for converting an Android YUV buffer to RGB. 
```


