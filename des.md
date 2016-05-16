
golang DES/ECB/PKCS5Padding实现 

```
package DES

//author denghaizhu

import (
	"encoding/base64"
	"fmt"
	"bytes"
	"encoding/binary"
	"crypto/des"
	"errors"
)

func PKCS5Padding(ciphertext []byte, blockSize int) []byte {
	padding := blockSize - len(ciphertext) % blockSize
	padtext := bytes.Repeat([]byte{byte(padding)}, padding)
	return append(ciphertext, padtext...)
}

func PKCS5UnPadding(origData []byte) []byte {
	length := len(origData)
	unpadding := int(origData[length - 1])
	return origData[:(length - unpadding)]
}

func DesEncrypt(src, key []byte) ([]byte, error) {
	block, err := des.NewCipher(key)
	if err != nil {
		return nil, err
	}
	bs := block.BlockSize()
	src = PKCS5Padding(src, bs)
	if len(src) % bs != 0 {
		return nil, errors.New("Need a multiple of the blocksize")
	}
	out := make([]byte, len(src))
	dst := out
	for len(src) > 0 {
		block.Encrypt(dst, src[:bs])
		src = src[bs:]
		dst = dst[bs:]
	}
	return out, nil
}

func DesDecrypt(src, key []byte) ([]byte, error) {
	block, err := des.NewCipher(key)
	if err != nil {
		return nil, err
	}
	out := make([]byte, len(src))
	dst := out
	bs := block.BlockSize()
	if len(src) % bs != 0 {
		return nil, errors.New("crypto/cipher: input not full blocks")
	}
	for len(src) > 0 {
		block.Decrypt(dst, src[:bs])
		src = src[bs:]
		dst = dst[bs:]
	}
	out = PKCS5UnPadding(out)
	return out, nil
}


// 注意2个问题:
//1,我们java 加密使用 DES/ECB/PKCS5Padding google认为ECB加密安全性低,没有对方开发,上面是自己实现的  @see https://gist.github.com/cuixin/10612934
//2,java 的byte是 int8,但是golang 是
//        System.out.println(Base64.encodeBase64URLSafeString(ImageConstants.DES_KEY));

func DesImageEncrypt(id int64, productionEnviornment bool) string {

	var key string;

	if productionEnviornment {
		key = "DicrJiFV9kg"
	} else {
		key = "D9gsCIXTm8Q"
	}

	base64er := base64.RawURLEncoding;


	decoder_buf, _ := base64er.DecodeString(key)

	buf := new(bytes.Buffer)
	err := binary.Write(buf, binary.BigEndian, id)

	if err != nil {
		fmt.Println("binary.Write failed:", err)
	}
	result, err := DesEncrypt(buf.Bytes(), decoder_buf);
	if err != nil {
		fmt.Println("binary.Write failed:", err)
	}

	uuid := base64er.EncodeToString(result);

	return uuid
}

```