# Android OpenGL-ES GPUImage

##1，YUV转RGB
 andorid  的camera数据是YUV数据，需要转换成rgb，但是普通的转换效率不高，即使使用jni转换也依然如此
 

修改fragment shader脚本如下：

        varying highp vec2 textureCoordinate;
        uniform sampler2D inputImageTexture;
        uniform sampler2D uvTexture;
        precision mediump float;
        void main(){
             vec4 y = vec4((texture2D(inputImageTexture, textureCoordinate).r - 16./255.) * 1.164);  
             vec4 u = vec4(texture2D(uvTexture, textureCoordinate).a - 128./255.);  
            vec4 v = vec4(texture2D(uvTexture, textureCoordinate).r - 128./255.);  
            y += v * vec4(1.596, -0.813, 0, 0);
            y += u * vec4(0, -0.392, 2.017, 0); 
            y.a = 1.0;
            gl_FragColor = y;//texture2D(inputImageTexture, textureCoordinate);
                   }


这是是关键代码 YUV数据转换成RGBA
### 2，坐标转换 
坐标转换 例如平移缩放旋转等
坐标脚本

    

        VERTEX_SHADER = "uniform mat4 uMVPMatrix;\n"
                    + "attribute vec4 position;\n" + "attribute vec4 inputTextureCoordinate;\n" + " \n"
                    + "varying vec2 textureCoordinate;\n" + " \n" + "void main()\n" + "{\n"
                    + "    gl_Position = uMVPMatrix * position; \n"
                    + "    textureCoordinate = inputTextureCoordinate.xy;\n" + "}";
                    
                    
                    
多添加了uMVPMatrix  


   Matrix.frustumM(mProjMatrix, 0, -ratio, ratio, -1, 1, 1, 2);

        Matrix.setLookAtM(mVMatrix, 0,//
                0, 0, cameraId == Camera.CameraInfo.CAMERA_FACING_FRONT ? -1 : 1, //eye
                0f, 0f, 0f,//center
                0f, 1f, 0f//up
        );
        //eye 坐标的eyez 正值时候看到的景物是折叠的

        float y = ((maxHeight - height) / 1f / maxHeight);
        Matrix.translateM(mVMatrix, 0,//
                0, y, 0f//x,y,z
        );

        Matrix.rotateM(mVMatrix, 0, mRotation.asInt(), 0, 0, -1);
